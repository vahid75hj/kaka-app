import 'parser_catalog.dart';
import 'sms_parser.dart';
import 'sms_text.dart';

enum _Kind { text, number, dateLike, sign }

class _Token {
  const _Token(this.kind, this.value);
  final _Kind kind;
  final String value;
}

/// What a learned slot means.
enum SlotRole { amount, balance, account, direction, sign, ignored }

class LearnedSlot {
  const LearnedSlot(this.role, this.values);
  final SlotRole role;

  /// The value of this slot in each sample, in order.
  final List<String> values;
}

class LearnResult {
  const LearnResult._({this.bank, this.error, this.previews = const [], this.slots = const []});
  final BankParser? bank;

  /// `need_samples`, `layout_mismatch`, `no_amount`, `no_direction`, `self_test_failed`.
  final String? error;

  /// What the learned template reads from each sample (for the confirm screen).
  final List<ParsedSms?> previews;
  final List<LearnedSlot> slots;

  bool get ok => bank != null;
}

/// Learns a declarative template from 3–5 SMS of one bank by aligning them
/// token by token: text that is the same everywhere becomes a literal, the
/// parts that vary become named groups, classified by their neighbours
/// (`مانده` → balance, `حساب` → account, signed/comma number → amount).
abstract final class TemplateLearner {
  static final _tokenizer = RegExp(r'(\d+(?:[/:\-]\d+)+)|(\d[\d,]*)|([+-])|([^\d\s+\-]+)');

  static List<_Token> _tokens(String text) => [
    for (final m in _tokenizer.allMatches(text))
      if (m[1] != null)
        _Token(_Kind.dateLike, m[1]!)
      else if (m[2] != null)
        _Token(_Kind.number, m[2]!)
      else if (m[3] != null)
        _Token(_Kind.sign, m[3]!)
      else
        _Token(_Kind.text, m[4]!),
  ];

  static LearnResult learn(
    List<String> samples, {
    required String nameFa,
    required String nameEn,
    List<String> senders = const [],
    String? defaultDirection,
    DateTime? receivedAt,
  }) {
    if (samples.length < 2) return const LearnResult._(error: 'need_samples');
    final normalized = samples.map(SmsText.normalize).toList();
    final tokens = normalized.map(_tokens).toList();
    final n = tokens.first.length;
    if (tokens.any((t) => t.length != n)) return const LearnResult._(error: 'layout_mismatch');
    for (var i = 0; i < n; i++) {
      final kinds = tokens.map((t) => t[i].kind == _Kind.dateLike ? _Kind.number : t[i].kind).toSet();
      if (kinds.length > 1) return const LearnResult._(error: 'layout_mismatch');
    }

    final parts = <String>[];
    final slots = <LearnedSlot>[];
    var hasAmount = false, hasBalance = false, hasAccount = false, hasDirection = false;
    final directionWords = <String>{};
    String lastText = '';

    for (var i = 0; i < n; i++) {
      final column = [for (final t in tokens) t[i]];
      final first = column.first;
      final same = column.every((t) => t.value == first.value);
      List<String> values() => [for (final t in column) t.value];

      switch (first.kind) {
        case _Kind.text:
          if (same) {
            parts.add(RegExp.escape(first.value));
            lastText = first.value;
          } else {
            parts.add(r'(?<direction>[^\d\s+\-]+)');
            directionWords.addAll(values());
            hasDirection = true;
            slots.add(LearnedSlot(SlotRole.direction, values()));
          }
        case _Kind.sign:
          final next = i + 1 < n ? tokens.first[i + 1].kind : null;
          final afterNumber = i > 0 && tokens.first[i - 1].kind == _Kind.number;
          if (afterNumber || next == _Kind.number) {
            // A sign glued to a number carries the direction (+ credit, − debit).
            parts.add(r'(?<sign>[+-])');
            hasDirection = true;
            slots.add(LearnedSlot(SlotRole.sign, values()));
          } else {
            parts.add(RegExp.escape(first.value));
          }
        case _Kind.number || _Kind.dateLike:
          final dashedAccount = column.every((t) => RegExp(r'^\d+(?:-\d+){2,}$').hasMatch(t.value));
          final isDate = !dashedAccount && column.any((t) => t.kind == _Kind.dateLike);
          final hasComma = column.any((t) => t.value.contains(','));
          SlotRole role;
          if (isDate) {
            role = SlotRole.ignored;
          } else if (lastText.contains('مانده') && !hasBalance) {
            role = SlotRole.balance;
          } else if ((lastText.contains('حساب') || lastText.contains('کارت') || dashedAccount) && !hasAccount) {
            role = SlotRole.account;
          } else if (!hasAmount && (hasComma || column.every((t) => t.value.length >= 4)) && !same) {
            role = SlotRole.amount;
          } else if (!hasAccount && !hasComma && column.every((t) => t.value.length >= 5)) {
            role = SlotRole.account;
          } else if (!hasAmount && hasComma) {
            role = SlotRole.amount;
          } else {
            role = SlotRole.ignored;
          }
          switch (role) {
            case SlotRole.amount:
              parts.add(r'(?<amount>[\d,]+)');
              hasAmount = true;
            case SlotRole.balance:
              parts.add(r'(?<balance>[\d,]+)');
              hasBalance = true;
            case SlotRole.account:
              parts.add(r'(?<account>[\d\-]+)');
              hasAccount = true;
            default:
              parts.add(r'[\d,/:\-]+');
          }
          slots.add(LearnedSlot(role, values()));
          lastText = '';
      }
    }
    if (!hasAmount) return LearnResult._(error: 'no_amount', slots: slots);

    // Constant keywords (e.g. every sample says "برداشت") also give a direction.
    final literalText = normalized.first;
    final debit = HeuristicSmsParser.debitWords.where((w) => directionWords.any((d) => d.contains(w))).toList();
    final credit = HeuristicSmsParser.creditWords.where((w) => directionWords.any((d) => d.contains(w))).toList();
    String? fallback = defaultDirection;
    if (!hasDirection && fallback == null) {
      if (HeuristicSmsParser.creditWords.any(literalText.contains)) {
        fallback = 'credit';
      } else if (HeuristicSmsParser.debitWords.any(literalText.contains)) {
        fallback = 'debit';
      } else {
        return LearnResult._(error: 'no_direction', slots: slots);
      }
    }

    final id = 'local.${DateTime.now().millisecondsSinceEpoch}';
    final template = SmsTemplate(
      id: '$id.v1',
      pattern: parts.join(r'\s*'),
      debitWords: debit,
      creditWords: credit,
      defaultDirection: fallback ?? (hasDirection && debit.isEmpty && credit.isEmpty ? 'debit' : null),
    );
    final bank = BankParser(
      bankId: id,
      nameEn: nameEn,
      nameFa: nameFa,
      senders: senders,
      keywords: const [],
      status: ParserStatus.local,
      templates: [template],
    );
    final parser = SmsParser(
      const ParserCatalog(schemaVersion: 1, catalogVersion: 'local', banks: []).withLocal([bank]),
      useHeuristics: false,
    );
    final previews = [for (final s in samples) parser.parse(s, receivedAt: receivedAt)];
    if (previews.any((p) => p == null)) {
      return LearnResult._(error: 'self_test_failed', previews: previews, slots: slots);
    }
    return LearnResult._(bank: bank, previews: previews, slots: slots);
  }
}
