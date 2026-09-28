import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Landing page: what QueueLock is, staff entry point. Customers arrive
/// via QR links straight at `/q/:slug`, so there is no join form here.
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QueueLock')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(24),
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
              FilledButton(
                onPressed: () => context.go('/staff'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                child: const Text('Staff sign-in / create a queue'),
              ),
              const SizedBox(height: 12),
              const Text(
                'Joining a queue? Open the QR link from the venue '
                '(it looks like /q/some-queue). No app install, no account.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
