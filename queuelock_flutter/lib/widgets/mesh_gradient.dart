import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Slow, subtle animated mesh gradient in the spirit of ShaderGradient
/// (soft 3-color mesh + light grain), painted natively in Flutter.
///
/// [speed] is a multiplier on the base ~32 s loop: 1.0 is the calm
/// default, 2.0 twice as fast, 0.5 half. Blobs drift on Lissajous paths;
/// grain is a static pre-rendered noise tile so it costs nothing per frame.
/// Honors reduced motion by freezing on a pleasing static frame.
class MeshGradient extends StatefulWidget {
  final Color base;
  final List<Color> blobs;
  final double speed;
  final double grainOpacity;
  const MeshGradient({
    super.key,
    required this.base,
    required this.blobs,
    this.speed = 1.0,
    this.grainOpacity = 0.05,
  });

  @override
  State<MeshGradient> createState() => _MeshGradientState();
}

class _MeshGradientState extends State<MeshGradient>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Future<ui.Image>? _grain;

  static const _loop = Duration(seconds: 32);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _loop)
      ..repeat();
    _applySpeed();
    _grain = _makeGrain();
  }

  @override
  void didUpdateWidget(MeshGradient old) {
    super.didUpdateWidget(old);
    if (old.speed != widget.speed) _applySpeed();
  }

  void _applySpeed() {
    final speed = widget.speed <= 0 ? 1.0 : widget.speed;
    _controller.duration = Duration(
      microseconds: (_loop.inMicroseconds / speed).round(),
    );
    if (!_controller.isAnimating) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return FutureBuilder<ui.Image>(
        future: _grain,
        builder: (context, snapshot) => CustomPaint(
          painter: _MeshPainter(
            t: 0.3,
            base: widget.base,
            blobs: widget.blobs,
            grain: snapshot.data,
            grainOpacity: widget.grainOpacity,
          ),
          child: const SizedBox.expand(),
        ),
      );
    }
    return FutureBuilder<ui.Image>(
      future: _grain,
      builder: (context, snapshot) => AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _MeshPainter(
            t: _controller.value,
            base: widget.base,
            blobs: widget.blobs,
            grain: snapshot.data,
            grainOpacity: widget.grainOpacity,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }

  /// One static 180x180 noise tile, drawn scaled-up for soft grain.
  static Future<ui.Image> _makeGrain() async {
    const size = 180;
    final random = math.Random(7);
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
    );
    final paint = Paint();
    for (var i = 0; i < 1500; i++) {
      paint.color = random.nextBool()
          ? const Color(0x1A000000)
          : const Color(0x14FFFFFF);
      canvas.drawRect(
        Rect.fromLTWH(
          random.nextDouble() * size,
          random.nextDouble() * size,
          1.4,
          1.4,
        ),
        paint,
      );
    }
    final picture = recorder.endRecording();
    return picture.toImage(size, size);
  }
}

class _MeshPainter extends CustomPainter {
  final double t;
  final Color base;
  final List<Color> blobs;
  final ui.Image? grain;
  final double grainOpacity;

  const _MeshPainter({
    required this.t,
    required this.base,
    required this.blobs,
    required this.grain,
    required this.grainOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = base,
    );
    final maxDim = math.max(size.width, size.height);
    const phases = [
      (0.0, 0.0),
      (0.33, 0.5),
      (0.66, 0.25),
      (0.15, 0.8),
    ];
    for (var i = 0; i < blobs.length; i++) {
      final phase = phases[i % phases.length];
      final cx =
          (0.5 + 0.32 * math.sin(2 * math.pi * (t + phase.$1))) * size.width;
      final cy =
          (0.5 +
              0.28 * math.cos(2 * math.pi * (1.3 * t + phase.$2))) *
          size.height;
      final radius =
          maxDim *
          (0.52 + 0.06 * math.sin(2 * math.pi * (t * 0.7 + phase.$2)));
      canvas.drawCircle(
        Offset(cx, cy),
        radius,
        Paint()
          ..shader = ui.Gradient.radial(
            Offset(cx, cy),
            radius,
            [blobs[i], blobs[i].withValues(alpha: 0)],
          ),
      );
    }
    final grainImage = grain;
    if (grainImage != null && grainOpacity > 0) {
      canvas.drawImageRect(
        grainImage,
        Rect.fromLTWH(
          0,
          0,
          grainImage.width.toDouble(),
          grainImage.height.toDouble(),
        ),
        Offset.zero & size,
        Paint()
          ..color = Colors.white.withValues(alpha: grainOpacity)
          ..blendMode = BlendMode.overlay,
      );
    }
  }

  @override
  bool shouldRepaint(_MeshPainter old) {
    return old.t != t ||
        old.base != base ||
        old.grain != grain ||
        old.grainOpacity != grainOpacity;
  }
}
