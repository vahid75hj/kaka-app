import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../app/providers.dart';
import '../../core/l10n_x.dart';
import '../../theme/kaka_colors.dart';

/// Asks the OS for biometrics or the device PIN/pattern. Kaka never stores a PIN itself.
class DeviceAuth {
  final _auth = LocalAuthentication();

  Future<bool> available() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(localizedReason: reason, persistAcrossBackgrounding: true);
    } catch (_) {
      return false;
    }
  }
}

final deviceAuthProvider = Provider<DeviceAuth>((ref) => DeviceAuth());

/// Covers the app while locked; locks on start and after 30 s in the background.
class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate> with WidgetsBindingObserver {
  static const _grace = Duration(seconds: 30);
  late bool _locked = ref.read(settingsProvider).appLock;
  DateTime? _pausedAt;
  var _authenticating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (_locked) WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!ref.read(settingsProvider).appLock || _authenticating) return;
    if (state == AppLifecycleState.paused) _pausedAt = DateTime.now();
    if (state == AppLifecycleState.resumed && _pausedAt != null) {
      if (DateTime.now().difference(_pausedAt!) > _grace) {
        setState(() => _locked = true);
        _unlock();
      }
      _pausedAt = null;
    }
  }

  Future<void> _unlock() async {
    if (_authenticating) return;
    _authenticating = true;
    final ok = await ref.read(deviceAuthProvider).authenticate(context.l10n.lockReason);
    _authenticating = false;
    if (ok && mounted) setState(() => _locked = false);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = ref.watch(settingsProvider.select((s) => s.appLock));
    if (!enabled || !_locked) return widget.child;
    final c = KakaColors.of(context);
    final l = context.l10n;
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: Material(
            color: c.background,
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_outline_rounded, size: 56, color: c.accentText),
                    const SizedBox(height: 16),
                    Text(l.lockedTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _unlock,
                      icon: const Icon(Icons.fingerprint_rounded),
                      label: Text(l.unlock),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
