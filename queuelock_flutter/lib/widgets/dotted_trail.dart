import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DottedTrail extends StatefulWidget {
  static const background = Color(0xFF000000);
  static const trail = Color(0xFF6A89A7);

  final Widget child;

  const DottedTrail({super.key, required this.child});

  @override
  State<DottedTrail> createState() => _DottedTrailState();
}

class _DottedTrailState extends State<DottedTrail>
    with SingleTickerProviderStateMixin {
  static const _nodes = 18;
  static const _followEase = 0.22;
  static const _trailEase = 0.45;
  static const _idleDelayMs = 100;
  static const _idleFadeMs = 1100;

  Ticker? _ticker;
  int _lastTickMs = 0;
  Offset? _pointer;
  Offset _eased = Offset.zero;
  List<Offset> _trail = const [];
  bool _seeded = false;
  bool _inside = false;
  bool _focused = false;
  double _presence = 0;
  int _lastMoveMs = 0;

  bool get _static => MediaQuery.of(context).disableAnimations;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addListener(_onFocusChange);
    _onFocusChange();
  }

  void _onFocusChange() {
    final context = FocusManager.instance.primaryFocus?.context;
    final typing =
        context != null &&
        context.findAncestorWidgetOfExactType<EditableText>() != null;
    if (typing == _focused) return;
    setState(() => _focused = typing);
    if (!typing && _inside) _ensureTicker();
  }

  void _ensureTicker() {
    if (_static || (_ticker?.isActive ?? false)) return;
    _ticker ??= createTicker(_tick);
    _lastTickMs = DateTime.now().millisecondsSinceEpoch;
    _ticker!.start();
  }

  void _tick(Duration _) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final dt = ((now - _lastTickMs) / 16.6667).clamp(0.0, 4.0);
    _lastTickMs = now;
    if (!mounted) return;
    setState(() {
      final fk = (_followEase * dt).clamp(0.0, 1.0);
      final tk = (_trailEase * dt).clamp(0.0, 1.0);
      if (_pointer != null) {
        _eased += (_pointer! - _eased) * fk;
      }
      if (_trail.isEmpty) {
        _trail = List.filled(_nodes, _eased);
      } else {
        _trail[0] = _eased;
        for (var i = 1; i < _nodes; i++) {
          _trail[i] += (_trail[i - 1] - _trail[i]) * tk;
        }
      }
      final target = (_inside && !_focused) ? 1.0 : 0.0;
      _presence += (target - _presence) * (0.08 * dt).clamp(0.0, 1.0);
      if (_inside && !_focused && _lastMoveMs > 0) {
        final still = now - _lastMoveMs - _idleDelayMs;
        if (still > 0) {
          final x = (still / _idleFadeMs).clamp(0.0, 1.0);
          final fade = x * x * x * (x * (x * 6 - 15) + 10);
          _presence = math.min(_presence, 1 - fade);
        }
      }
      if ((!_inside || _focused) && _presence < 0.01) {
        _presence = 0;
        _ticker?.stop();
      }
    });
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_onFocusChange);
    _ticker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        final now = DateTime.now().millisecondsSinceEpoch;
        setState(() {
          if (_pointer != event.localPosition) _lastMoveMs = now;
          _pointer = event.localPosition;
          _inside = true;
          if (!_seeded) {
            _eased = _pointer!;
            _trail = List.filled(_nodes, _eased);
            _seeded = true;
          }
        });
        _ensureTicker();
      },
      onExit: (_) => setState(() => _inside = false),
      child: CustomPaint(
        painter: _TrailPainter(trail: _trail, presence: _presence),
        child: Theme(
          data: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: DottedTrail.trail,
              brightness: Brightness.dark,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class _TrailPainter extends CustomPainter {
  static const _spacing = 34.0;
  static const _dotRadius = 1.2;
  static const _glowRadius = 300.0;
  static const _headRadius = 80.0;

  final List<Offset> trail;
  final double presence;

  _TrailPainter({required this.trail, required this.presence});

  static double _smoothstep(double a, double b, double x) {
    final t = ((x - a) / (b - a)).clamp(0.0, 1.0);
    return t * t * (3 - 2 * t);
  }

  static double _segDist(Offset p, Offset a, Offset b) {
    final ab = b - a;
    final len2 = ab.distanceSquared;
    final t = len2 > 0.0001
        ? ((p - a).dx * ab.dx + (p - a).dy * ab.dy) / len2
        : 0.0;
    final c = t.clamp(0.0, 1.0);
    return (p - (a + ab * c)).distance;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0) return;
    final bg = DottedTrail.background;
    final ink = DottedTrail.trail;

    canvas.drawRect(Offset.zero & size, Paint()..color = bg);

    final head = trail.isEmpty ? null : trail[0];

    if (presence > 0.01 && trail.isNotEmpty) {
      Path tube(double widthScale) {
        final path = Path();
        final n = trail.length;
        double radius(int i) {
          final headFrac = n <= 1 ? 0.0 : i / (n - 1);
          return _headRadius *
              (0.32 + 0.68 * math.pow(1 - headFrac, 1.1)) *
              widthScale;
        }

        Offset normal(int i) {
          final a = trail[math.max(0, i - 1)];
          final b = trail[math.min(n - 1, i + 1)];
          final d = b - a;
          final len = d.distance;
          if (len < 0.001) return const Offset(0, -1);
          return Offset(-d.dy / len, d.dx / len);
        }

        for (var i = 0; i < n; i++) {
          final p = trail[i] + normal(i) * radius(i);
          if (i == 0) {
            path.moveTo(p.dx, p.dy);
          } else {
            path.lineTo(p.dx, p.dy);
          }
        }
        for (var i = n - 1; i >= 0; i--) {
          final p = trail[i] - normal(i) * radius(i);
          path.lineTo(p.dx, p.dy);
        }
        path.close();
        return path;
      }

      canvas.drawPath(
        tube(1.0),
        Paint()
          ..color = ink.withValues(
            alpha: (0.55 * presence).clamp(0.0, 1.0),
          )
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28),
      );
      canvas.drawPath(
        tube(0.45),
        Paint()
          ..color = const Color(0xFFFFFFFF).withValues(
            alpha: (0.75 * presence).clamp(0.0, 1.0),
          )
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
      );
      if (head != null) {
        canvas.drawCircle(
          head,
          _glowRadius,
          Paint()
            ..shader =
                RadialGradient(
                  colors: [
                    ink.withValues(alpha: 0.55 * presence),
                    ink.withValues(alpha: 0.0),
                  ],
                ).createShader(
                  Rect.fromCircle(center: head, radius: _glowRadius),
                ),
        );
        canvas.drawCircle(
          head,
          _headRadius,
          Paint()
            ..shader =
                RadialGradient(
                  colors: [
                    const Color(
                      0xFFFFFFFF,
                    ).withValues(alpha: 0.95 * presence),
                    ink.withValues(alpha: 0.55 * presence),
                    ink.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ).createShader(
                  Rect.fromCircle(center: head, radius: _headRadius),
                ),
        );
      }
    }

    final dim = ink.withValues(alpha: 0.16);
    const hole = DottedTrail.background;
    const rim = Color(0xFFFFFFFF);
    for (var y = _spacing / 2; y < h; y += _spacing) {
      for (var x = _spacing / 2; x < w; x += _spacing) {
        final p = Offset(x, y);
        var body = 0.0;
        if (presence > 0.01 && head != null) {
          for (var i = 0; i < trail.length - 1; i++) {
            final d = _segDist(p, trail[i], trail[i + 1]);
            final thickness =
                _headRadius * (0.32 + 0.68 * math.pow(1 - i / 17, 1.1));
            body = math.max(
              body,
              1 - _smoothstep(thickness, thickness + _headRadius * 0.9, d),
            );
            if (body >= 1) break;
          }
          body *= presence;
        }
        final ring =
            (1 - ((body - 0.35) / 0.35).abs().clamp(0.0, 1.0)) * presence;
        final dotColor = Color.lerp(
          Color.lerp(dim, rim, ring * 0.9)!,
          hole,
          body.clamp(0.0, 1.0),
        )!;
        final r = _dotRadius * (1 + math.max(ring, body) * 1.8);
        canvas.drawCircle(p, r, Paint()..color = dotColor);
      }
    }
  }

  @override
  bool shouldRepaint(_TrailPainter old) =>
      old.trail != trail || old.presence != presence;
}
