import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resident_live/shared/shared.dart';

// Horizontal line of progress from 0 to 100
class WebPageProgressIndicator extends StatefulWidget {
  const WebPageProgressIndicator({
    super.key,
    required this.progress,
    this.backgroundColor = Colors.transparent,
    this.valueColor,
  });

  final double progress;
  final Color backgroundColor;
  final Color? valueColor;

  @override
  State<WebPageProgressIndicator> createState() =>
      _WebPageProgressIndicatorState();
}

class _WebPageProgressIndicatorState extends State<WebPageProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween(begin: 0.0, end: widget.progress).animate(_controller);
    _controller.forward();
  }

  @override
  void didUpdateWidget(WebPageProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(_controller);
      _controller.forward(from: 0.0);

      // If progress reaches 1.0, hide after delay
      if (widget.progress >= 1.0) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _isVisible = false;
            });
          }
        });
      } else {
        setState(() {
          _isVisible = true;
        });
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
    final theme = context.rlTheme;
    final valueColor = widget.valueColor ?? theme.iconAccent;

    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return LinearProgressIndicator(
            value: _animation.value,
            backgroundColor: widget.backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(valueColor),
            minHeight: 2,
          );
        },
      ),
    );
  }
}
