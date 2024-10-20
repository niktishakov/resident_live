import 'package:flutter/material.dart';
import 'dart:math' as math;

class DiagonalProgressBar extends StatefulWidget {
  final double progress; // Value between 0.0 and 1.0
  final Color startColor;
  final Color endColor;
  final double lineWidth;
  final double lineSpacing;
  final Duration animationDuration;

  const DiagonalProgressBar({
    super.key,
    required this.progress,
    this.startColor = Colors.white,
    this.endColor = Colors.blue,
    this.lineWidth = 10,
    this.lineSpacing = 20,
    this.animationDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<DiagonalProgressBar> createState() => _DiagonalProgressBarState();
}

class _DiagonalProgressBarState extends State<DiagonalProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late Animation<double> _lineAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _lineAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(DiagonalProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      // Update progress animation
      _progressAnimation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));

      // Reset and restart line animation
      _lineAnimation = Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));

      _controller.forward(from: 0);
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
            lineAnimation: _lineAnimation.value,
          ),
        );
      },
    );
  }
}

class _DiagonalProgressPainter extends CustomPainter {
  final double progress;
  final Color startColor;
  final Color endColor;
  final double lineWidth;
  final double lineSpacing;
  final double lineAnimation;

  _DiagonalProgressPainter({
    required this.progress,
    required this.startColor,
    required this.endColor,
    required this.lineWidth,
    required this.lineSpacing,
    required this.lineAnimation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round;

    final progressWidth = size.width * progress;
    final angle = -math.pi / 4; // 45-degree angle
    final lineLength = size.height * 1.5;
    final totalLines = (size.width / lineSpacing).ceil() + 2;

    for (var i = 0; i < totalLines; i++) {
      final x = i * lineSpacing - lineSpacing;
      if (x > progressWidth) continue;

      final lineProgress = x / size.width;
      paint.color =
          Color.lerp(startColor, endColor, lineProgress) ?? startColor;

      // Calculate line start and end points
      final startY = size.height + (lineLength * lineAnimation);
      final endY = startY - lineLength;

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
        oldDelegate.lineAnimation != lineAnimation ||
        oldDelegate.startColor != startColor ||
        oldDelegate.endColor != endColor;
  }
}
