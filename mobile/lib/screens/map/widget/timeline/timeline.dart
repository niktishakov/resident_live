import "package:data/data.dart";
import "package:domain/src/value_object/stay_period.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/shared/shared.dart";

class Timeline extends StatelessWidget {
  const Timeline({required this.stayPeriods, super.key, this.selectedPeriodIndex});

  final List<StayPeriodValueObject> stayPeriods;
  final int? selectedPeriodIndex;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    getIt<LoggerService>().debug("Timeline");

    return SizedBox(
      width: 60,
      child: Column(
        children: [
          Container(
                height: 60,
                width: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [theme.bgAccent.withValues(alpha: 0), theme.bgAccent],
                  ),
                ),
              )
              .animate(onComplete: (controller) => controller.repeat())
              .shimmer(angle: 90, duration: 500.ms, delay: (stayPeriods.length * 500 + 500).ms),

          for (var i = 0; i < stayPeriods.length; i++) ...[
            AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastEaseInToSlowEaseOut,
                  width: selectedPeriodIndex == i ? 18 : 12,
                  height: selectedPeriodIndex == i ? 18 : 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.bgAccent,
                    border: Border.all(color: theme.bgAccent, width: 2),
                  ),
                )
                .animate(onComplete: (controller) => controller.repeat())
                .shimmer(
                  angle: 90,
                  duration: 500.ms,
                  delay: ((stayPeriods.length - i) * 500 + 500).ms,
                ),
            if (i < stayPeriods.length - 1)
              Container(
                    height: 120 + 12,
                    width: 2,
                    decoration: BoxDecoration(color: theme.bgAccent),
                  )
                  .animate(onComplete: (controller) => controller.repeat())
                  .shimmer(
                    angle: 90,
                    duration: 500.ms,
                    delay: ((stayPeriods.length - i) * 500 + 500).ms,
                  ),
          ],
          Container(
                height: 60,
                width: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [theme.bgAccent, theme.bgAccent.withValues(alpha: 0)],
                  ),
                ),
              )
              .animate(onComplete: (controller) => controller.repeat())
              .shimmer(angle: 90, duration: 500.ms, delay: (stayPeriods.length * 500 + 500).ms),
        ],
      ),
    );
  }
}
