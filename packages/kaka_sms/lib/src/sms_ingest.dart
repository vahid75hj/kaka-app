import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:kaka_domain/kaka_domain.dart';

import 'account_ref.dart';
import 'parser_catalog.dart';
import 'sms_parser.dart';
import 'sms_text.dart';

/// One SMS as delivered by the platform (inbox row, broadcast, share or paste).
class IncomingSms {
  const IncomingSms({required this.body, required this.receivedAt, this.sender});
  final String body;
  final String? sender;
  final DateTime receivedAt;
}

enum IngestResult { added, duplicate, unreadable, ignoredSender }

/// Which Kaka account an SMS belongs to, given the user's links.
abstract final class SmsAccountMatcher {
  static String? match(List<SmsLink> links, {String? sender, String? accountRef}) {
    final s = sender == null ? null : SmsText.sender(sender);
    bool sameSender(SmsLink l) => l.sender != null && s != null && l.sender == s;
    bool sameNumber(SmsLink l) =>
        l.accountNumber != null && accountRef != null && AccountRef.matches(accountRef, l.accountNumber!);
    // 1. sender + number  2. number from any sender  3. the sender's default account
    for (final pick in [
      (SmsLink l) => sameSender(l) && sameNumber(l),
      (SmsLink l) => sameNumber(l),
      (SmsLink l) => sameSender(l) && l.accountNumber == null,
    ]) {
      final hit = links.where((l) => pick(l) && l.accountId != null).firstOrNull;
      if (hit != null) return hit.accountId;
    }
    return null;
  }

  /// Senders the user chose to process.
  static Set<String> linkedSenders(List<SmsLink> links) => {
    for (final l in links)
      if (l.sender != null) l.sender!,
  };
}

/// Application service: SMS → parser → account match → question-queue draft.
/// Never writes to the ledger; the user confirms each draft.
class SmsIngestService {
  SmsIngestService({
    required this.parser,
    required this.links,
    required this.drafts,
    required this.bankName,
    DateTime Function()? clock,
  }) : _now = clock ?? DateTime.now;

  final SmsParser parser;
  final SmsLinkRepository links;
  final DraftService drafts;

  /// Localized bank name for the draft note.
  final String Function(BankParser bank) bankName;
  final DateTime Function() _now;

  /// [onlyLinkedSenders] is used by automatic reading: SMS from senders the
  /// user did not pick are skipped without being parsed or stored.
  Future<IngestResult> ingest(IncomingSms sms, {required DraftSource source, bool onlyLinkedSenders = false}) async {
    final all = await links.getAll();
    if (onlyLinkedSenders) {
      final s = sms.sender == null ? null : SmsText.sender(sms.sender!);
      if (s == null || !SmsAccountMatcher.linkedSenders(all).contains(s)) return IngestResult.ignoredSender;
    }
    final parsed = parser.parse(sms.body, sender: sms.sender, receivedAt: sms.receivedAt);
    if (parsed == null) return IngestResult.unreadable;
    final bank = parsed.bankId == null
        ? null
        : parser.catalog.banks.where((b) => b.bankId == parsed.bankId).firstOrNull;
    final draft = Draft(
      id: Ids.next(),
      source: source,
      isExpense: parsed.isDebit,
      amount: parsed.amount,
      createdAt: _now(),
      occurredAt: parsed.occurredAt ?? sms.receivedAt,
      rawText: sms.body.trim(),
      note: bank == null ? '' : bankName(bank),
      bankId: parsed.bankId,
      accountRef: parsed.account,
      accountId: SmsAccountMatcher.match(all, sender: sms.sender, accountRef: parsed.account),
      balance: parsed.balance,
      sender: sms.sender == null ? null : SmsText.sender(sms.sender!),
      confidence: parsed.confidence,
      dedupKey: dedupKey(sms, parsed),
    );
    return await drafts.enqueue(draft) ? IngestResult.added : IngestResult.duplicate;
  }

  /// With a full timestamp the parsed content identifies the transaction, so
  /// the inbox copy and a shared copy collapse. Otherwise sender + body + time.
  static String dedupKey(IncomingSms sms, ParsedSms parsed) {
    if (parsed.occurredAt != null) return 'tx:${parsed.dedupKey}';
    final body = sha256.convert(utf8.encode(SmsText.normalize(sms.body))).toString();
    return 'sms:${SmsText.sender(sms.sender ?? '')}|$body|${sms.receivedAt.millisecondsSinceEpoch ~/ 60000}';
  }
}

/// A sender found in the inbox, for the "which sender is which account" setup.
class SenderSummary {
  const SenderSummary({required this.sender, required this.count, required this.samples});
  final String sender;
  final int count;
  final List<String> samples;
}

class SenderInsight {
  const SenderInsight(this.summary, {this.bank, this.accounts = const {}, required this.looksLikeBank});
  final SenderSummary summary;
  final BankParser? bank;

  /// Account fragments seen in this sender's messages.
  final Set<String> accounts;
  final bool looksLikeBank;
}

extension SenderClassification on SmsParser {
  SenderInsight classify(SenderSummary s) {
    BankParser? bank = detectBank('', sender: s.sender);
    final accounts = <String>{};
    var hits = 0;
    for (final body in s.samples) {
      final p = parse(body, sender: s.sender);
      if (p == null || p.confidence < 0.5) continue;
      hits++;
      if (p.account != null) accounts.add(p.account!);
      bank ??= p.bankId == null ? null : catalog.banks.where((b) => b.bankId == p.bankId).firstOrNull;
    }
    return SenderInsight(s, bank: bank, accounts: accounts, looksLikeBank: hits > 0);
  }
}
