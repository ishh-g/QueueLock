import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:queuelock_client/queuelock_client.dart';

import '../call_alert.dart';
import '../client.dart';
import '../theme.dart';
import '../widgets/status_chip.dart';

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
  TicketStatus? _lastStatus;

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
              if (view.status == TicketStatus.called &&
                  _lastStatus != TicketStatus.called) {
                alertOnCalled();
              }
              _lastStatus = view.status;
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
        const SizedBox(height: 8),
        Center(
          child: StatusChip(
            statusName: view.status.name,
            label: _statusLabel(view),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          // The number eases to its new value on every change.
          child: AnimatedSwitcher(
            duration: 350.ms,
            switchInCurve: Curves.easeOutBack,
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: Text(
              '${view.number}',
              key: ValueKey(view.number),
              style: theme.textTheme.displayLarge?.copyWith(fontSize: 96),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (view.status == TicketStatus.called && view.counterName != null)
          _CalledBanner(
            key: const ValueKey('called'),
            counterName: view.counterName!,
            arriveInSec: view.arriveInSec,
          ),
        if (view.status == TicketStatus.waiting) ...[
          _PositionDots(position: view.position),
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
          Center(
            child: Text(
              'Done. Thank you!',
              style: theme.textTheme.titleMedium,
            ).animate().scale(
              begin: const Offset(0.9, 0.9),
              duration: 400.ms,
              curve: Curves.easeOutBack,
            ),
          ),
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

/// Draining dots: filled dots are people ahead, capped at five.
class _PositionDots extends StatelessWidget {
  final int position;
  const _PositionDots({required this.position});

  @override
  Widget build(BuildContext context) {
    final filled = position.clamp(0, 5);
    return Column(
      children: [
        AnimatedSwitcher(
          duration: 300.ms,
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: Row(
            key: ValueKey(position),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 5; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Icon(
                    Icons.circle,
                    size: 12,
                    color: i < filled
                        ? AppTheme.waiting
                        : Theme.of(
                            context,
                          ).colorScheme.outlineVariant,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          position == 0
              ? 'You are next.'
              : position == 1
              ? '1 person ahead of you.'
              : '$position people ahead of you.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

class _CalledBanner extends StatefulWidget {
  final String counterName;
  final int? arriveInSec;
  const _CalledBanner({
    super.key,
    required this.counterName,
    required this.arriveInSec,
  });

  @override
  State<_CalledBanner> createState() => _CalledBannerState();
}

class _CalledBannerState extends State<_CalledBanner> {
  late final DateTime _shownAt;
  late final int _totalSec;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _shownAt = DateTime.now();
    _totalSec = widget.arriveInSec ?? 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get _remaining {
    if (widget.arriveInSec == null) return -1;
    return widget.arriveInSec! - DateTime.now().difference(_shownAt).inSeconds;
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? AppTheme.readyDark : AppTheme.ready;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final remaining = _remaining;
    final progress = remaining < 0
        ? 0.0
        : (remaining / math.max(_totalSec, 1)).clamp(0.0, 1.0);
    final banner = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppTheme.rose,
            blurRadius: 28,
            spreadRadius: -8,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Go to Counter ${widget.counterName}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 120,
            height: 120,
            child: CustomPaint(
              painter: _RingPainter(
                progress: progress,
                track: Colors.white.withValues(alpha: 0.3),
                bar: Colors.white,
              ),
              child: Center(
                child: Text(
                  remaining < 0 ? 'now' : _format(remaining),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            remaining < 0
                ? 'Please head to the counter now.'
                : 'Time left to arrive.',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
    if (reduceMotion) return banner;
    // Spring in once on mount; then breathe gently while visible.
    return banner
        .animate()
        .scale(
          begin: const Offset(0.85, 0.85),
          duration: 450.ms,
          curve: Curves.easeOutBack,
        )
        .fadeIn(duration: 300.ms)
        .animate(
          onComplete: (controller) => controller.repeat(reverse: true),
        )
        .scaleXY(end: 1.015, duration: 1400.ms, curve: Curves.easeInOut);
  }

  String _format(int totalSec) {
    final m = totalSec ~/ 60;
    final s = totalSec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color track;
  final Color bar;
  const _RingPainter({
    required this.progress,
    required this.track,
    required this.bar,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - 12) / 2;
    final trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    final barPaint = Paint()
      ..color = bar
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      barPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
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
