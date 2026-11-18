import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';

/// Keeps the app behind biometric authentication when the user enables it.
class SecurityGate extends ConsumerStatefulWidget {
  const SecurityGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<SecurityGate> createState() => _SecurityGateState();
}

class _SecurityGateState extends ConsumerState<SecurityGate>
    with WidgetsBindingObserver {
  bool _checking = true;
  bool _enabled = false;
  bool _unlocked = true;
  bool _authenticating = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_load());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      if (_enabled && !_unlocked) return;
      if (_enabled) setState(() => _unlocked = false);
    }
  }

  Future<void> _load() async {
    var enabled = false;
    try {
      enabled = await ref.read(securityRepositoryProvider).isBiometricEnabled();
    } on Object {
      enabled = false;
    }
    if (!mounted) return;
    setState(() {
      _enabled = enabled;
      _unlocked = !enabled;
      _checking = false;
    });
    if (enabled) unawaited(_unlock(auto: true));
  }

  Future<void> _unlock({bool auto = false}) async {
    if (_authenticating) return;
    setState(() {
      _authenticating = true;
      _error = null;
    });
    var success = false;
    try {
      success = await ref.read(securityRepositoryProvider).authenticate();
    } on Object {
      success = false;
    }
    if (!mounted) return;
    setState(() {
      _authenticating = false;
      _unlocked = success;
      if (!success) {
        _error = auto
            ? 'Desbloquea KipuBudget para ver tus finanzas.'
            : 'No se pudo verificar tu identidad.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_unlocked) return widget.child;
    return _LockScreen(
      error: _error,
      authenticating: _authenticating,
      onUnlock: _unlock,
    );
  }
}

class _LockScreen extends StatelessWidget {
  const _LockScreen({
    required this.error,
    required this.authenticating,
    required this.onUnlock,
  });

  final String? error;
  final bool authenticating;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [scheme.primary, scheme.tertiary],
                  ),
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: 44,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'KipuBudget',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tus finanzas, solo para tus ojos.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              if (error != null) ...[
                Text(
                  error!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.error,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              FilledButton.icon(
                onPressed: authenticating ? null : onUnlock,
                icon: authenticating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.fingerprint_rounded),
                label: Text(authenticating ? 'Verificando…' : 'Desbloquear'),
              ),
              const SizedBox(height: 12),
              Text(
                'La base de datos vive solo en este dispositivo.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
