import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';
import '../widgets/mesh_gradient.dart';

/// Landing page: what QueueLock is, staff entry point. Customers arrive
/// via QR links straight at `/q/:slug`, so there is no join form here.
/// The hero sits on a slow animated mesh in brand greens.
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('QueueLock')),
      body: Stack(
        children: [
          Positioned.fill(
            child: MeshGradient(
              base: dark ? AppTheme.darkBackground : AppTheme.cream,
              blobs: dark
                  ? [
                      AppTheme.maroon.withValues(alpha: 0.55),
                      AppTheme.matcha.withValues(alpha: 0.28),
                      AppTheme.rose.withValues(alpha: 0.18),
                    ]
                  : [
                      AppTheme.maroon.withValues(alpha: 0.20),
                      AppTheme.matcha.withValues(alpha: 0.38),
                      AppTheme.rose.withValues(alpha: 0.22),
                    ],
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  ...AnimateList(
                    interval: 100.ms,
                    effects: [
                      FadeEffect(
                        duration: 350.ms,
                        curve: Curves.easeOutCubic,
                      ),
                      const SlideEffect(
                        begin: Offset(0, 0.12),
                        duration: Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                      ),
                    ],
                    children: [
                      Text(
                        'Skip the physical line.',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'QueueLock is a data-minimised virtual queue for clinics, '
                        'salons and small shops. Customers scan a QR code, join with '
                        'just a nickname, and see a live position. Staff call '
                        'customers from several counters without ever calling the '
                        'same person twice.',
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                  _StaffButton(),
                  const SizedBox(height: 12),
                  const Text(
                    'Joining a queue? Open the QR link from the venue '
                    '(it looks like /q/some-queue). No app install, no account.',
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Anyone can audit a queue: open /audit/<queue-link-name> to '
                    'verify its public tamper-evident log.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StaffButton extends StatelessWidget {
  const _StaffButton();

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () => context.go('/staff'),
      child: const Text('Staff sign-in / create a queue'),
    );
  }
}
