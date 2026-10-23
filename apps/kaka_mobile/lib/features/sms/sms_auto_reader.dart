import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_sms/kaka_sms.dart';

import '../../app/providers.dart';
import 'sms_platform.dart';

final smsPlatformProvider = Provider<SmsPlatform>((ref) => SmsPlatform());

/// Opt-in automatic reading. Off → no permission prompt, no reading, no receiver.
class SmsAutoReader {
  SmsAutoReader(this._ref);
  final Ref _ref;

  /// How far back the first scan looks.
  static const firstScanWindow = Duration(days: 30);

  SmsPlatform get _platform => _ref.read(smsPlatformProvider);

  /// Asks for the permission; returns false if denied (the setting stays off).
  Future<bool> enable() async {
    if (!await _platform.requestPermission()) return false;
    await _ref.read(settingsProvider.notifier).update((s) => s.copyWith(smsAutoRead: true));
    await _platform.startListening(_onLive);
    return true;
  }

  Future<void> disable() async {
    await _platform.stopListening();
    await _ref.read(settingsProvider.notifier).update((s) => s.copyWith(smsAutoRead: false));
  }

  /// Called at start-up and on resume: (re)attach the receiver and scan what was missed.
  Future<int> resume() async {
    if (!_ref.read(settingsProvider).smsAutoRead) return 0;
    if (!await _platform.hasPermission()) {
      // Permission revoked in system settings: turn the feature off rather than nag.
      await disable();
      return 0;
    }
    await _platform.startListening(_onLive);
    return scan();
  }

  /// Ingests inbox SMS from linked senders since the last scan.
  Future<int> scan({DateTime? since}) async {
    final s = _ref.read(settingsProvider);
    if (!s.smsAutoRead) return 0;
    final links = await _ref.read(smsLinkRepositoryProvider).getAll();
    final senders = SmsAccountMatcher.linkedSenders(links).toList();
    if (senders.isEmpty) return 0;
    final from = since ?? s.smsLastScan ?? DateTime.now().subtract(firstScanWindow);
    final messages = await _platform.inbox(since: from, senders: senders);
    final service = await _ref.read(smsIngestServiceProvider.future);
    var added = 0;
    DateTime? newest;
    for (final m in messages) {
      final r = await service.ingest(m, source: DraftSource.sms, onlyLinkedSenders: true);
      if (r == IngestResult.added) added++;
      if (newest == null || m.receivedAt.isAfter(newest)) newest = m.receivedAt;
    }
    if (newest != null) {
      await _ref.read(settingsProvider.notifier).update((s) => s.copyWith(smsLastScan: () => newest));
    }
    return added;
  }

  Future<void> _onLive(IncomingSms sms) async {
    if (!_ref.read(settingsProvider).smsAutoRead) return;
    final service = await _ref.read(smsIngestServiceProvider.future);
    await service.ingest(sms, source: DraftSource.sms, onlyLinkedSenders: true);
  }
}

final smsAutoReaderProvider = Provider<SmsAutoReader>(SmsAutoReader.new);

/// Runs [SmsAutoReader.resume] on start and whenever the app returns to the foreground.
class SmsLifecycle extends ConsumerStatefulWidget {
  const SmsLifecycle({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<SmsLifecycle> createState() => _SmsLifecycleState();
}

class _SmsLifecycleState extends ConsumerState<SmsLifecycle> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _resume());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _resume();
  }

  void _resume() {
    if (!ref.read(settingsProvider).smsAutoRead) return;
    ref.read(smsAutoReaderProvider).resume().ignore();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
