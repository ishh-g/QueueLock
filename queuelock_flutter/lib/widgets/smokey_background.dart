import 'dart:math' as math;

import 'package:flutter/material.dart';

class SmokeyBackground extends StatefulWidget {
  const SmokeyBackground({super.key});

  @override
  State<SmokeyBackground> createState() => _SmokeyBackgroundState();
}

class _SmokeyBackgroundState extends State<SmokeyBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ticker;
  final ValueNotifier<Offset?> _pointer = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _ticker = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _pointer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => _pointer.value = event.localPosition,
      onExit: (_) => _pointer.value = null,
      child: AnimatedBuilder(
        animation: _ticker,
        builder: (context, _) => CustomPaint(
          painter: _SmokePainter(
            time: _ticker.value * 14.0,
            pointer: _pointer.value,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _SmokePainter extends CustomPainter {
  static const _deep = Color(0xFF1D4ED8);
  static const _light = Color(0xFFBDDDFC);
  static const _top = Color(0xFF060B18);
  static const _bottom = Color(0xFF02040A);

  final double time;
  final Offset? pointer;

  _SmokePainter({required this.time, required this.pointer});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_top, _bottom],
        ).createShader(Offset.zero & size),
    );

    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0) return;

    var rippleX = 0.0;
    var rippleY = 0.0;
    if (pointer != null) {
      rippleX = (pointer!.dx / w) * 2 - 1;
      rippleY = (pointer!.dy / h) * 2 - 1;
    }

    final minSide = math.min(w, h);
    for (var i = 0; i < 3; i++) {
      final t = time * (0.22 + 0.07 * i) + i * 2.1;
      final cx = w * (0.5 + 0.38 * math.sin(t + rippleX * 0.9));
      final cy = h * (0.5 + 0.36 * math.cos(t * 0.8 + i + rippleY * 0.9));
      final radius = minSide * (0.42 + 0.08 * i);
      final center = Offset(cx, cy);
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              _deep.withValues(alpha: 0.55 - 0.08 * i),
              _deep.withValues(alpha: 0.0),
            ],
          ).createShader(Rect.fromCircle(center: center, radius: radius)),
      );
    }

    for (var i = 0; i < 3; i++) {
      final t = time * (0.5 + 0.12 * i) + i * 1.7;
      final baseY = h * (0.28 + 0.2 * i);
      final amp = 60.0 + 22.0 * i;
      final thick = 90.0 - 18.0 * i;
      final path = Path();
      for (var x = -40.0; x <= w + 40; x += 14) {
        final y =
            baseY +
            amp * math.sin(x * 0.006 + t + rippleX * math.pi) +
            (amp * 0.45) *
                math.cos(x * 0.011 - t * 0.75 + rippleY * math.pi + i);
        if (x == -40) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      for (var x = w + 40; x >= -40; x -= 14) {
        final y =
            baseY +
            amp * math.sin(x * 0.006 + t + rippleX * math.pi) +
            (amp * 0.45) *
                math.cos(x * 0.011 - t * 0.75 + rippleY * math.pi + i) +
            thick;
        path.lineTo(x, y);
      }
      path.close();
      canvas.drawPath(
        path,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _light.withValues(alpha: 0.30 - 0.06 * i),
              _light.withValues(alpha: 0.0),
            ],
          ).createShader(Rect.fromLTWH(0, baseY - amp, w, thick + amp * 2))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 42),
      );
    }

    for (var i = 0; i < 2; i++) {
      final t = time * (0.65 + 0.15 * i) + i * 2.6;
      final path = Path();
      for (var x = -20.0; x <= w + 20; x += 12) {
        final y =
            h * (0.35 + 0.22 * i) +
            70 * math.sin(x * 0.007 + t + rippleX * math.pi) +
            30 * math.cos(x * 0.012 - t * 0.8 + rippleY * math.pi);
        if (x == -20) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = _light.withValues(alpha: 0.55 - 0.15 * i)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5.0 - 2.0 * i
          ..strokeCap = StrokeCap.round,
      );
    }

    if (pointer != null) {
      for (var r = 6; r >= 1; r--) {
        canvas.drawCircle(
          pointer!,
          42.0 * r,
          Paint()..color = _light.withValues(alpha: 0.022),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_SmokePainter old) =>
      old.time != time || old.pointer != pointer;
}
