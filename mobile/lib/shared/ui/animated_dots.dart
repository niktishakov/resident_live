import "dart:async";

import "package:flutter/material.dart";

class AnimatedDots extends StatefulWidget {
  const AnimatedDots({
    required this.value,
    required this.maxValue,
    super.key,
    this.radius = 8.0,
    this.padding = 4.0,
    this.activeColor = Colors.black,
    this.inactiveColor = Colors.grey,
  });

  final int value;
  final int maxValue;
  final double radius;
  final double padding;
  final Color activeColor;
  final Color inactiveColor;

  @override
  AnimatedDotsState createState() => AnimatedDotsState();
}

class AnimatedDotsState extends State<AnimatedDots> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _opacityController;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: 1.0, // Start visible
    );

    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel(); // Cancel any existing timer
    _hideTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        _opacityController.reverse();
      }
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedDots oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.forward(from: 0);
      _opacityController.forward();
      _startHideTimer();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _opacityController.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityController,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.maxValue, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.padding),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CircleAvatar(
                  radius: widget.radius,
                  backgroundColor: widget.value == index ? widget.activeColor : widget.inactiveColor,
                  child: const SizedBox.shrink(),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
