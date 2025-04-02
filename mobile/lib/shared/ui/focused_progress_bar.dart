import "package:flutter/material.dart";


class FocusedProgressBar extends StatefulWidget {
  const FocusedProgressBar({required this.value, super.key});
  final double value;

  @override
  _AnimatedProgressBarState createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<FocusedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: widget.value).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: CustomPaint(
        painter: ProgressBarPainter(_animation.value),
      ),
    );
  }
}

class ProgressBarPainter extends CustomPainter {

  ProgressBarPainter(this.progress);
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final segmentWidth = size.width / 10; // Assuming 10 segments
    for (var i = 0; i < 10; i++) {
      if (i < (progress * 10).round()) {
        canvas.drawRect(
          Rect.fromLTWH(i * segmentWidth, 0, segmentWidth, size.height),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
