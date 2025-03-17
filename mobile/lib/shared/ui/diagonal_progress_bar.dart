import 'package:flutter/material.dart';
import 'dart:math' as math;

class DiagonalProgressBar extends StatefulWidget {

  const DiagonalProgressBar({
    super.key,
    required this.progress,
    this.startColor = Colors.white,
    this.endColor = Colors.blue,
    this.lineWidth = 2,
    this.lineSpacing = 6,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.isAnimationEnabled = true,
  });
  final double progress; // Value between 0.0 and 1.0
  final Color startColor;
  final Color endColor;
  final double lineWidth;
  final double lineSpacing;
  final Duration animationDuration;
  final bool isAnimationEnabled;

  @override
  State<DiagonalProgressBar> createState() => _DiagonalProgressBarState();
}

class _DiagonalProgressBarState extends State<DiagonalProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _progressAnimation = Tween<double>(
      begin: widget.isAnimationEnabled ? 0 : widget.progress,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ),);

    if (widget.isAnimationEnabled) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(DiagonalProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: widget.isAnimationEnabled ? oldWidget.progress : widget.progress,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),);

      if (widget.isAnimationEnabled) {
        _controller.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _DiagonalProgressPainter(
            progress: _progressAnimation.value,
            startColor: widget.startColor,
            endColor: widget.endColor,
            lineWidth: widget.lineWidth,
            lineSpacing: widget.lineSpacing,
          ),
        );
      },
    );
  }
}

class _DiagonalProgressPainter extends CustomPainter {

  _DiagonalProgressPainter({
    required this.progress,
    required this.startColor,
    required this.endColor,
    required this.lineWidth,
    required this.lineSpacing,
  });
  final double progress;
  final Color startColor;
  final Color endColor;
  final double lineWidth;
  final double lineSpacing;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round;

    final progressWidth = size.width * progress;
    const angle = -math.pi / 4; // 45-degree angle
    final lineLength = size.height * 1.5;
    final totalLines = (size.width / lineSpacing).ceil() + 30;

    for (var i = 0; i < totalLines; i++) {
      final x = i * lineSpacing - lineSpacing * 10;
      if (x > progressWidth) continue;

      final startY = size.height;
      final endY = startY - lineLength;

      final gradient = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [startColor, endColor],
        stops: [0.0, 0.61],
      );

      paint.shader =
          gradient.createShader(Rect.fromLTWH(x, endY, lineWidth, lineLength));

      canvas.save();
      canvas.clipRect(Rect.fromLTWH(0, 0, progressWidth, size.height));

      canvas.drawLine(
        Offset(x, startY),
        Offset(x + lineLength * math.cos(angle), endY),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _DiagonalProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.startColor != startColor ||
        oldDelegate.endColor != endColor;
  }
}
