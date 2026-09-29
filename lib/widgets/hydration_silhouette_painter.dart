import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Decorative vector painter rendering an artistic female body silhouette
/// with an animated rising water wave to visualize daily hydration level.
class HydrationSilhouetteWidget extends StatefulWidget {
  final double progress; // 0.0 to 1.0 (or greater)
  final double width;
  final double height;
  final bool isGoalReached;

  const HydrationSilhouetteWidget({
    super.key,
    required this.progress,
    this.width = 160,
    this.height = 220,
    this.isGoalReached = false,
  });

  @override
  State<HydrationSilhouetteWidget> createState() =>
      _HydrationSilhouetteWidgetState();
}

class _HydrationSilhouetteWidgetState extends State<HydrationSilhouetteWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: HydrationSilhouettePainter(
            progress: widget.progress.clamp(0.0, 1.0),
            wavePhase: _waveController.value * 2 * math.pi,
            isGoalReached: widget.isGoalReached,
          ),
        );
      },
    );
  }
}

class HydrationSilhouettePainter extends CustomPainter {
  final double progress;
  final double wavePhase;
  final bool isGoalReached;

  HydrationSilhouettePainter({
    required this.progress,
    required this.wavePhase,
    required this.isGoalReached,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Build the artistic stylized female silhouette path
    final silhouettePath = _createSilhouettePath(w, h);

    // 1. Draw subtle background glow / background fill of body container
    final bgPaint = Paint()
      ..color = const Color(0xFFE1F5FE).withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawPath(silhouettePath, bgPaint);

    // 2. Clip canvas to silhouette path so water stays strictly inside body
    canvas.save();
    canvas.clipPath(silhouettePath);

    // 3. Draw Water fill with animated dual sine waves
    if (progress > 0.005) {
      final waterHeight = h * progress;
      final baselineY = h - waterHeight;

      // Back wave (lighter translucent blue)
      final backWavePath = Path();
      backWavePath.moveTo(0, h);
      backWavePath.lineTo(0, baselineY);

      for (double x = 0; x <= w; x += 3) {
        final y = baselineY +
            math.sin((x / w * 2 * math.pi) + wavePhase + 1.2) * 5.0;
        backWavePath.lineTo(x, y);
      }
      backWavePath.lineTo(w, h);
      backWavePath.close();

      final backWavePaint = Paint()
        ..color = const Color(0xFF4FC3F7).withValues(alpha: 0.45)
        ..style = PaintingStyle.fill;
      canvas.drawPath(backWavePath, backWavePaint);

      // Front wave (vibrant blue gradient)
      final frontWavePath = Path();
      frontWavePath.moveTo(0, h);
      frontWavePath.lineTo(0, baselineY);

      for (double x = 0; x <= w; x += 3) {
        final y =
            baselineY + math.sin((x / w * 2 * math.pi) + wavePhase) * 6.5;
        frontWavePath.lineTo(x, y);
      }
      frontWavePath.lineTo(w, h);
      frontWavePath.close();

      final waveRect = Rect.fromLTWH(0, baselineY - 10, w, waterHeight + 10);
      final frontWavePaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF29B6F6),
            Color(0xFF0288D1),
          ],
        ).createShader(waveRect)
        ..style = PaintingStyle.fill;

      canvas.drawPath(frontWavePath, frontWavePaint);

      // Liquid shine highlights (slight specular reflection)
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;
      canvas.drawPath(frontWavePath, highlightPaint);
    }

    canvas.restore();

    // 4. Draw outer silhouette outline
    final outlinePaint = Paint()
      ..color = isGoalReached
          ? const Color(0xFF0288D1)
          : const Color(0xFF81D4FA)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(silhouettePath, outlinePaint);

    // 5. Celebration glow if goal reached
    if (isGoalReached) {
      final glowPaint = Paint()
        ..color = const Color(0xFF29B6F6).withValues(alpha: 0.3)
        ..strokeWidth = 5.0
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);
      canvas.drawPath(silhouettePath, glowPaint);
    }
  }

  /// Stylized smooth anatomical silhouette of a woman's torso, neck & head
  Path _createSilhouettePath(double w, double h) {
    final path = Path();
    final cx = w * 0.5;

    // Head top
    path.moveTo(cx, h * 0.03);

    // Head right curve
    path.cubicTo(
        cx + w * 0.16, h * 0.03, cx + w * 0.17, h * 0.13, cx + w * 0.12, h * 0.18);
    // Neck right
    path.cubicTo(
        cx + w * 0.09, h * 0.20, cx + w * 0.08, h * 0.24, cx + w * 0.18, h * 0.27);
    // Shoulder right
    path.cubicTo(
        cx + w * 0.32, h * 0.29, cx + w * 0.36, h * 0.35, cx + w * 0.34, h * 0.42);
    // Bust right
    path.cubicTo(
        cx + w * 0.36, h * 0.47, cx + w * 0.32, h * 0.54, cx + w * 0.24, h * 0.58);
    // Waist right
    path.cubicTo(
        cx + w * 0.18, h * 0.62, cx + w * 0.22, h * 0.70, cx + w * 0.33, h * 0.78);
    // Hip right
    path.cubicTo(
        cx + w * 0.38, h * 0.83, cx + w * 0.34, h * 0.92, cx + w * 0.24, h * 0.97);
    // Leg/Thigh base right
    path.cubicTo(
        cx + w * 0.15, h * 0.99, cx + w * 0.08, h * 0.99, cx, h * 0.985);

    // Leg/Thigh base left
    path.cubicTo(
        cx - w * 0.08, h * 0.99, cx - w * 0.15, h * 0.99, cx - w * 0.24, h * 0.97);
    // Hip left
    path.cubicTo(
        cx - w * 0.34, h * 0.92, cx - w * 0.38, h * 0.83, cx - w * 0.33, h * 0.78);
    // Waist left
    path.cubicTo(
        cx - w * 0.22, h * 0.70, cx - w * 0.18, h * 0.62, cx - w * 0.24, h * 0.58);
    // Bust left
    path.cubicTo(
        cx - w * 0.32, h * 0.54, cx - w * 0.36, h * 0.47, cx - w * 0.34, h * 0.42);
    // Shoulder left
    path.cubicTo(
        cx - w * 0.36, h * 0.35, cx - w * 0.32, h * 0.29, cx - w * 0.18, h * 0.27);
    // Neck left
    path.cubicTo(
        cx - w * 0.08, h * 0.24, cx - w * 0.09, h * 0.20, cx - w * 0.12, h * 0.18);
    // Head left
    path.cubicTo(
        cx - w * 0.17, h * 0.13, cx - w * 0.16, h * 0.03, cx, h * 0.03);

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant HydrationSilhouettePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.wavePhase != wavePhase ||
        oldDelegate.isGoalReached != isGoalReached;
  }
}
