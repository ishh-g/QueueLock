import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:queuelock_client/queuelock_client.dart';

import '../client.dart';

/// Live customer ticket page at `/t/:token`. Renders the server-computed
/// [TicketView] stream; reconnects resubscribe automatically.
class TicketScreen extends StatefulWidget {
  final String token;
  const TicketScreen({super.key, required this.token});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  late final Stream<TicketView> _stream;
  bool _leaving = false;

  @override
  void initState() {
    super.initState();
    _stream = client.queue.watch(widget.token);
  }

  Future<void> _leave(String slug) async {
    setState(() => _leaving = true);
    try {
      await client.queue.leave(widget.token);
      if (!mounted) return;
      context.go('/q/$slug');
    } on QueueError catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
      setState(() => _leaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your ticket')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: StreamBuilder<TicketView>(
            stream: _stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Could not load your ticket.'),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () => context.go('/t/${widget.token}'),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              final view = snapshot.data!;
              final reconnecting =
                  snapshot.connectionState == ConnectionState.waiting;
              return _TicketBody(
                view: view,
                reconnecting: reconnecting,
                leaving: _leaving,
                onLeave: () => _leave(view.queueSlug),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TicketBody extends StatelessWidget {
  final TicketView view;
  final bool reconnecting;
  final bool leaving;
  final VoidCallback onLeave;
  const _TicketBody({
    required this.view,
    required this.reconnecting,
    required this.leaving,
    required this.onLeave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        if (reconnecting)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text('Reconnecting…'),
              ],
            ),
          ),
        Text(view.queueName, style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        Center(
          child: Text(
            '${view.number}',
            style: theme.textTheme.displayLarge?.copyWith(fontSize: 96),
          ),
        ),
        Center(child: Text(_statusLabel(view))),
        const SizedBox(height: 16),
        if (view.status == TicketStatus.called && view.counterName != null)
          _CalledBanner(
            counterName: view.counterName!,
            arriveInSec: view.arriveInSec,
          ),
        if (view.status == TicketStatus.waiting) ...[
          Center(
            child: Text(
              view.position == 0
                  ? 'You are next.'
                  : '${view.position} ahead of you.',
              style: theme.textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              view.etaSeconds == null
                  ? 'Estimate improves as we serve people.'
                  : 'About ${view.etaSeconds! ~/ 60} min.',
            ),
          ),
        ],
        if (view.status == TicketStatus.serving)
          const Center(child: Text('You are being served.')),
        if (view.status == TicketStatus.done)
          const Center(child: Text('Done. Thank you!')),
        if (view.status == TicketStatus.skipped)
          const Center(child: Text('You missed your turn twice.')),
        if (view.status == TicketStatus.cancelled)
          const Center(child: Text('You left the queue.')),
        const SizedBox(height: 24),
        _ReceiptPanel(view: view),
        const SizedBox(height: 24),
        if (view.status == TicketStatus.waiting ||
            view.status == TicketStatus.called)
          OutlinedButton(
            onPressed: leaving ? null : onLeave,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            child: const Text('Leave queue'),
          ),
      ],
    );
  }

  String _statusLabel(TicketView view) {
    return switch (view.status) {
      TicketStatus.waiting => 'Waiting',
      TicketStatus.called => 'Called',
      TicketStatus.serving => 'Serving',
      TicketStatus.done => 'Done',
      TicketStatus.skipped => 'Skipped',
      TicketStatus.cancelled => 'Cancelled',
    };
  }
}

class _CalledBanner extends StatefulWidget {
  final String counterName;
  final int? arriveInSec;
  const _CalledBanner({required this.counterName, required this.arriveInSec});

  @override
  State<_CalledBanner> createState() => _CalledBannerState();
}

class _CalledBannerState extends State<_CalledBanner> {
  late final DateTime _shownAt;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _shownAt = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final remaining = widget.arriveInSec == null
        ? null
        : widget.arriveInSec! -
              DateTime.now().difference(_shownAt).inSeconds;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: colors.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        children: [
          Text(
            'Go to Counter ${widget.counterName}',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: colors.onPrimaryContainer),
          ),
          const SizedBox(height: 8),
          Text(
            remaining == null
                ? 'Please head over now.'
                : remaining > 0
                ? 'About ${_format(remaining)} left to arrive.'
                : 'Please head to the counter now.',
            style: TextStyle(color: colors.onPrimaryContainer),
          ),
        ],
      ),
    );
  }

  String _format(int totalSec) {
    final m = totalSec ~/ 60;
    final s = totalSec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

class _ReceiptPanel extends StatelessWidget {
  final TicketView view;
  const _ReceiptPanel({required this.view});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Fairness receipt', style: theme.textTheme.labelLarge),
          const SizedBox(height: 4),
          SelectableText(
            view.receiptSeq == null
                ? 'Not available.'
                : 'seq ${view.receiptSeq}\nhash ${view.receiptHash}',
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              fontFamilyFallback: const ['Courier'],
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Keep this: it proves your join is in the public tamper-evident log.',
          ),
        ],
      ),
    );
  }
}
