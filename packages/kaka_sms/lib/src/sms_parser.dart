import 'package:kaka_domain/kaka_domain.dart';

import 'parser_catalog.dart';
import 'sms_date.dart';
import 'sms_text.dart';

enum SmsDirection { debit, credit }

class ParsedSms {
  const ParsedSms({
    required this.amount,
    required this.direction,
    required this.confidence,
    this.bankId,
    this.templateId,
    this.balance,
    this.account,
    this.occurredAt,
  });

  /// `null` when the bank could not be recognised (e.g. "پرداخت گروهی" SMS).
  final String? bankId;

  /// `null` when the heuristic parser produced the result.
  final String? templateId;
  final Money amount;
  final SmsDirection direction;
  final Money? balance;

  /// Account number fragment as printed (digits and dashes), e.g. `06009`.
  final String? account;
  final DateTime? occurredAt;

  /// 0..1. Templates ≈ 0.95; the heuristic scores how many parts it found.
  final double confidence;

  bool get isDebit => direction == SmsDirection.debit;

  /// Same transaction seen via SMS inbox, share and paste → same key.
  String get dedupKey => [
    bankId ?? '',
    SmsText.digitsOnly(account ?? ''),
    amount.minor,
    direction.name,
    occurredAt?.toIso8601String() ?? '',
    balance?.minor ?? '',
  ].join('|');
}

/// Declarative templates first, then a heuristic fallback. No AI, no network.
class SmsParser {
  SmsParser(this.catalog, {this.includeUnverified = true, this.useHeuristics = true});

  final ParserCatalog catalog;

  /// Run `needs_samples`/`community` templates too.
  final bool includeUnverified;
  final bool useHeuristics;

  final _cache = <String, RegExp>{};

  static String normalize(String text) => SmsText.normalize(text);

  ParsedSms? parse(String text, {String? sender, DateTime? receivedAt}) {
    final normalized = SmsText.normalize(text);
    final at = receivedAt ?? DateTime.now();
    final bank = detectBank(normalized, sender: sender);
    for (final b in [?bank, ...catalog.banks.where((b) => b != bank)]) {
      if (!includeUnverified && !b.enabledByDefault) continue;
      for (final t in b.templates) {
        final parsed = _apply(b, t, normalized, at);
        if (parsed != null) return parsed;
      }
    }
    return useHeuristics ? HeuristicSmsParser.parse(normalized, bankId: bank?.bankId, receivedAt: at) : null;
  }

  /// Bank by sender address, else by a name keyword in the text.
  BankParser? detectBank(String normalized, {String? sender}) {
    if (sender != null) {
      final s = SmsText.sender(sender);
      for (final b in catalog.banks) {
        if (b.senders.map(SmsText.sender).contains(s)) return b;
      }
    }
    for (final b in catalog.banks) {
      if (b.keywords.any((k) => normalized.contains(SmsText.normalize(k)))) return b;
    }
    return null;
  }

  ParsedSms? _apply(BankParser bank, SmsTemplate t, String text, DateTime receivedAt) {
    final re = _cache.putIfAbsent(t.pattern, () => RegExp(t.pattern, multiLine: true, unicode: true));
    final m = re.firstMatch(text);
    if (m == null) return null;
    String? group(String name) => m.groupNames.contains(name) ? m.namedGroup(name) : null;

    final unit = DisplayUnit.byCode(t.unit);
    final amount = parseAmount(group('amount'), unit);
    if (amount == null) return null;
    final sign = group('sign');
    final dirText = group('direction') ?? text;
    final SmsDirection direction;
    if (sign == '-') {
      direction = SmsDirection.debit;
    } else if (sign == '+') {
      direction = SmsDirection.credit;
    } else if (t.creditWords.any(dirText.contains)) {
      direction = SmsDirection.credit;
    } else if (t.debitWords.any(dirText.contains)) {
      direction = SmsDirection.debit;
    } else if (t.defaultDirection != null) {
      direction = t.defaultDirection == 'credit' ? SmsDirection.credit : SmsDirection.debit;
    } else {
      return null;
    }
    return ParsedSms(
      bankId: bank.bankId,
      templateId: t.id,
      amount: amount.abs(),
      direction: direction,
      confidence: 0.95,
      balance: parseAmount(group('balance'), unit),
      account: group('account') ?? group('last4'),
      occurredAt: SmsDate.find(text, receivedAt: receivedAt),
    );
  }

  static Money? parseAmount(String? raw, DisplayUnit unit) {
    if (raw == null) return null;
    final cleaned = raw.replaceAll(RegExp(r'[,.\s+\-]'), '');
    if (cleaned.isEmpty) return null;
    try {
      return AmountParser.parse(cleaned, unit);
    } on DomainException {
      return null;
    }
  }
}

/// Reads unknown layouts: finds a signed or labelled amount, the balance after
/// `مانده`, an account fragment and a (possibly partial) Jalali date.
abstract final class HeuristicSmsParser {
  static const debitWords = ['برداشت', 'خرید', 'پرداخت', 'کسر', 'انتقال از', 'انتقالی', 'انتقال'];
  static const creditWords = ['واریز', 'سود', 'انتقال به', 'افزایش', 'بستانکار'];
  static const _amountLabels = ['مبلغ', ...debitWords, ...creditWords];

  static final _number = RegExp(r'\d{1,3}(?:,\d{3})+|\d{4,}');
  static final _balance = RegExp(r'مانده(?:\s*حساب)?\s*:?\s*([\d,]+)');
  static final _accountLabel = RegExp(r'(?:حساب|کارت|سپرده)\s*:?\s*([\d][\d\-.*]*\d)');
  static final _accountLine = RegExp(r'^[\d\-]{10,}$');

  static ParsedSms? parse(String text, {String? bankId, required DateTime receivedAt}) {
    final unit = DisplayUnit.byCode('IRR');
    var score = 0.25;

    Money? balance;
    final b = _balance.firstMatch(text);
    if (b != null) {
      balance = SmsParser.parseAmount(b[1], unit);
      if (balance != null) score += 0.15;
    }

    String? account;
    final al = _accountLabel.firstMatch(text);
    if (al != null) {
      account = al[1]!.replaceAll(RegExp(r'[.*]'), '');
    } else {
      for (final line in text.split('\n')) {
        if (_accountLine.hasMatch(line) && !line.contains(',')) {
          account = line;
          break;
        }
      }
    }
    if (account != null) score += 0.1;

    // Scan lines for the amount, skipping balance / account / date fragments.
    Money? amount;
    SmsDirection? direction;
    for (final raw in text.split('\n')) {
      if (raw.contains('مانده')) continue;
      var line = raw;
      for (final p in SmsDate.patterns) {
        line = line.replaceAll(p, ' ');
      }
      if (account != null && SmsText.digitsOnly(line) == SmsText.digitsOnly(account)) continue;
      if (_accountLabel.hasMatch(line)) continue;
      final n = _number.firstMatch(line);
      if (n == null) continue;
      final after = line.substring(n.end).trimLeft();
      final before = line.substring(0, n.start).trimRight();
      final labelled = _amountLabels.any(before.contains);
      final signAfter = after.startsWith('-') || after.startsWith('+');
      final signBefore = before.endsWith('-') || before.endsWith('+');
      if (!labelled && !signAfter && !signBefore) continue;
      amount = SmsParser.parseAmount(n[0], unit);
      if (amount == null || amount.isZero) continue;
      final sign = signAfter ? after[0] : (signBefore ? before[before.length - 1] : null);
      if (sign != null) direction = sign == '-' ? SmsDirection.debit : SmsDirection.credit;
      score += labelled ? 0.15 : 0.1;
      break;
    }
    if (amount == null) return null;

    direction ??= _directionFromWords(text);
    if (direction != null) {
      score += 0.2;
    } else {
      direction = SmsDirection.debit; // most bank SMS are spending; the user confirms anyway
    }
    final at = SmsDate.find(text, receivedAt: receivedAt);
    if (at != null) score += 0.1;
    if (bankId != null) score += 0.05;

    return ParsedSms(
      bankId: bankId,
      amount: amount,
      direction: direction,
      confidence: score.clamp(0, 0.9).toDouble(),
      balance: balance,
      account: account,
      occurredAt: at,
    );
  }

  static SmsDirection? _directionFromWords(String text) {
    // Credit words first: "انتقال به" must beat the generic "انتقال".
    for (final w in creditWords) {
      if (text.contains(w)) return SmsDirection.credit;
    }
    for (final w in debitWords) {
      if (text.contains(w)) return SmsDirection.debit;
    }
    return null;
  }
}
