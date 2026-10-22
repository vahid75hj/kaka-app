import 'package:kaka_domain/kaka_domain.dart';

import 'parser_catalog.dart';

enum SmsDirection { debit, credit }

class ParsedSms {
  const ParsedSms({
    required this.bankId,
    required this.templateId,
    required this.amount,
    required this.direction,
    this.balance,
    this.last4,
    this.date,
    this.time,
  });

  final String bankId;
  final String templateId;
  final Money amount;
  final SmsDirection direction;
  final Money? balance;
  final String? last4;
  final String? date;
  final String? time;

  /// Same purchase seen via SMS, share and notification → same key.
  String get dedupKey => [bankId, last4 ?? '', amount.minor, direction.name, date ?? '', time ?? ''].join('|');
}

/// Runs catalog templates over an SMS. No AI, no network.
class SmsParser {
  SmsParser(this.catalog, {this.includeUnverified = false});

  final ParserCatalog catalog;

  /// Run `needs_samples`/`community` parsers too (used by tests and a dev toggle).
  final bool includeUnverified;

  final _cache = <String, RegExp>{};

  /// Normalizes digits, Arabic letters and invisible marks the way banks vary them.
  static String normalize(String text) => Digits.normalize(text)
      .replaceAll('ي', 'ی')
      .replaceAll('ك', 'ک')
      .replaceAll(RegExp('[\u200c\u200e\u200f\u202a-\u202e]'), ' ')
      .replaceAll(RegExp(r'[ \t]+'), ' ')
      .trim();

  ParsedSms? parse(String text, {String? sender}) {
    final normalized = normalize(text);
    for (final bank in catalog.banks) {
      if (!includeUnverified && !bank.enabledByDefault) continue;
      if (sender != null && bank.senders.isNotEmpty && !bank.senders.contains(sender)) continue;
      for (final t in bank.templates) {
        final parsed = _apply(bank, t, normalized);
        if (parsed != null) return parsed;
      }
    }
    return null;
  }

  ParsedSms? _apply(BankParser bank, SmsTemplate t, String text) {
    final re = _cache.putIfAbsent(t.pattern, () => RegExp(t.pattern, multiLine: true, unicode: true));
    final m = re.firstMatch(text);
    if (m == null) return null;
    String? group(String name) => m.groupNames.contains(name) ? m.namedGroup(name) : null;

    final unit = DisplayUnit.byCode(t.unit);
    final amount = _amount(group('amount'), unit);
    if (amount == null) return null;
    final dirText = group('direction') ?? text;
    final SmsDirection direction;
    if (t.creditWords.any(dirText.contains)) {
      direction = SmsDirection.credit;
    } else if (t.debitWords.any(dirText.contains)) {
      direction = SmsDirection.debit;
    } else {
      return null;
    }
    return ParsedSms(
      bankId: bank.bankId,
      templateId: t.id,
      amount: amount.abs(),
      direction: direction,
      balance: _amount(group('balance'), unit),
      last4: group('last4'),
      date: group('date'),
      time: group('time'),
    );
  }

  static Money? _amount(String? raw, DisplayUnit unit) {
    if (raw == null) return null;
    final cleaned = raw.replaceAll(RegExp(r'[,٬.،\s]'), '');
    try {
      return AmountParser.parse(cleaned.replaceFirst('+', ''), unit);
    } on DomainException {
      return null;
    }
  }
}
