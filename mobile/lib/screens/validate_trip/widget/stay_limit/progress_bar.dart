import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:resident_live/screens/validate_trip/widget/stay_limit/stay_limit_data.dart";
import "package:resident_live/shared/shared.dart";

class ProgressBar extends StatefulWidget {
  const ProgressBar({required this.limit, super.key});

  final StayLimitData limit;

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);

    _animation = Tween<double>(
      begin: widget.limit.currentProgress,
      end: widget.limit.futureProgress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Stack(
          children: [
            // Background border
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: theme.borderAccent, width: 1),
              ),
            ),

            // Current usage (было)
            FractionallySizedBox(
                  widthFactor: widget.limit.currentProgress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.textAccent.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                )
                .animate(delay: 1.seconds, onComplete: (controller) => controller.repeat())
                .shimmer(duration: 1.seconds, angle: math.pi),

            // Future usage after trip (станет) - animated
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return FractionallySizedBox(
                  widthFactor: _animation.value.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.bgAccent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
