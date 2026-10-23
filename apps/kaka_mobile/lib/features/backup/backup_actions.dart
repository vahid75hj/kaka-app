import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_data/kaka_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/providers.dart';
import '../../core/l10n_x.dart';

/// Export: snapshot → Argon2id + XChaCha20-Poly1305 (in a background isolate) → share sheet.
Future<void> exportBackup(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final password = await _askPassword(context, confirm: true);
  if (password == null || !context.mounted) return;
  final done = _progress(context, l.backupWorking);
  try {
    final snapshot = await LedgerSnapshot(ref.read(databaseProvider)).export();
    final bytes = await Isolate.run(() => BackupCodec.encrypt(snapshot, password));
    final now = DateTime.now();
    final stamp = '${now.year}${_two(now.month)}${_two(now.day)}-${_two(now.hour)}${_two(now.minute)}';
    final file = File('${(await getTemporaryDirectory()).path}/kaka-$stamp.kaka');
    await file.writeAsBytes(bytes, flush: true);
    done();
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path, mimeType: 'application/octet-stream')]));
  } catch (_) {
    done();
    if (context.mounted) _snack(context, l.errGeneric);
  }
}

/// Restore: pick a `.kaka` file → password → confirm → replace everything atomically.
Future<void> restoreBackup(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final picked = await FilePicker.pickFiles();
  if (picked.isEmpty || !context.mounted) return;
  final data = await picked.first.xFile.readAsBytes();
  if (!context.mounted) return;
  final password = await _askPassword(context, confirm: false);
  if (password == null || !context.mounted) return;
  final done = _progress(context, l.backupWorking);
  final Map<String, Object?> snapshot;
  try {
    final bytes = Uint8List.fromList(data);
    snapshot = await Isolate.run(() => BackupCodec.decrypt(bytes, password));
  } on BackupException catch (e) {
    done();
    if (context.mounted) {
      _snack(context, switch (e.code) {
        'backup.wrong_password' => l.backupWrongPassword,
        'backup.not_kaka' => l.backupNotKaka,
        _ => l.backupCorrupt,
      });
    }
    return;
  }
  done();
  if (!context.mounted) return;
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(l.restoreTitle),
      content: Text(l.restoreBody),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l.restoreAction)),
      ],
    ),
  );
  if (ok != true) return;
  try {
    await LedgerSnapshot(ref.read(databaseProvider)).restore(snapshot);
    await ref.read(settingsProvider.notifier).reload();
    if (context.mounted) _snack(context, l.restoreDone);
  } catch (_) {
    if (context.mounted) _snack(context, l.backupCorrupt);
  }
}

String _two(int v) => v.toString().padLeft(2, '0');

void _snack(BuildContext context, String text) =>
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(content: Text(text)));

VoidCallback _progress(BuildContext context, String text) {
  final nav = Navigator.of(context, rootNavigator: true);
  var open = true;
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: AlertDialog(
        content: Row(
          children: [
            const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5)),
            const SizedBox(width: 16),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    ),
  ).whenComplete(() => open = false);
  return () {
    if (open) nav.pop();
  };
}

Future<String?> _askPassword(BuildContext context, {required bool confirm}) {
  final l = context.l10n;
  final a = TextEditingController();
  final b = TextEditingController();
  String? error;
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setState) => AlertDialog(
        title: Text(confirm ? l.backupPasswordTitle : l.backupEnterPassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (confirm) Text(l.backupPasswordHint, style: const TextStyle(fontSize: 13, height: 1.5)),
            TextField(
              controller: a,
              obscureText: true,
              autofocus: true,
              decoration: InputDecoration(labelText: l.password, errorText: confirm ? null : error),
            ),
            if (confirm)
              TextField(
                controller: b,
                obscureText: true,
                decoration: InputDecoration(labelText: l.passwordRepeat, errorText: error),
              ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l.cancel)),
          FilledButton(
            onPressed: () {
              if (a.text.length < 8) return setState(() => error = l.passwordTooShort);
              if (confirm && a.text != b.text) return setState(() => error = l.passwordMismatch);
              Navigator.pop(dialogContext, a.text);
            },
            child: Text(l.ok),
          ),
        ],
      ),
    ),
  );
}
