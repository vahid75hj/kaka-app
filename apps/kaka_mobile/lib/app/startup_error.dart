import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shown instead of a silent crash when Kaka can't start (keystore, ledger,
/// settings). Bilingual on purpose: localization may be what failed.
class StartupErrorApp extends StatefulWidget {
  const StartupErrorApp({
    super.key,
    required this.error,
    required this.stack,
    required this.onRetry,
    required this.onReset,
  });

  final Object error;
  final StackTrace stack;
  final Future<void> Function() onRetry;
  final Future<String?> Function() onReset;

  @override
  State<StartupErrorApp> createState() => _StartupErrorAppState();
}

class _StartupErrorAppState extends State<StartupErrorApp> {
  bool _busy = false;

  String get _report => 'Kaka startup error\n${widget.error}\n\n${widget.stack}';

  Future<void> _confirmReset(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('شروع از نو؟ / Start fresh?'),
        content: const Text(
          'دفتر فعلی پاک نمی‌شود؛ کنار گذاشته می‌شود و کاکا با دفتر خالی باز می‌شود. '
          'بعداً می‌توانی پشتیبان .kaka را بازگردانی.\n\n'
          'The current ledger is moved aside (not deleted) and Kaka opens empty. '
          'You can restore a .kaka backup afterwards.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('نه / No')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('بله / Yes')),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _busy = true);
    await widget.onReset();
    await widget.onRetry();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Builder(
      builder: (context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'کاکا باز نشد',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Text("Kaka couldn't start", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                const Text(
                  'متن خطا را کپی کن و برای سازنده بفرست. / Copy the error and send it to the developer.',
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                      child: SelectableText(_report, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('کپی خطا / Copy error'),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _report));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('کپی شد / Copied')));
                  },
                ),
                OutlinedButton(
                  onPressed: _busy
                      ? null
                      : () {
                          setState(() => _busy = true);
                          widget.onRetry();
                        },
                  child: const Text('دوباره امتحان کن / Try again'),
                ),
                TextButton(
                  onPressed: _busy ? null : () => _confirmReset(context),
                  child: const Text('شروع از نو با دفتر خالی / Start fresh'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
