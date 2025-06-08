import "dart:math" as math;

import "package:flutter/material.dart";
import "package:resident_live/shared/shared.dart";
import "package:shimmer/shimmer.dart";
import "package:skeletonizer/skeletonizer.dart";

class MapSkeleton extends StatelessWidget {
  const MapSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final random = math.Random(42); // Fixed seed for consistent positions

    return Shimmer.fromColors(
      baseColor: context.rlTheme.bgSecondary.withValues(alpha: 0.5),
      highlightColor: context.rlTheme.bgModal.withValues(alpha: 0.1),
      enabled: true,
      child: Stack(
        children: [
          // Звездочки вокруг глобуса
          ...List.generate(70, (index) {
            final distanceX = random.nextDouble() * context.mediaQuery.size.width;
            final distanceY = random.nextDouble() * 150;
            final size = 3.0 + random.nextInt(3);

            return Transform.translate(
              offset: Offset(distanceX, distanceY),
              child: Bone.square(size: size, borderRadius: BorderRadius.circular(size / 2)),
            );
          }),

          Center(
            child: Container(
              width: 100,
              height: 100,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.rlTheme.bgModal,
                border: Border.all(
                  color: context.rlTheme.bgSecondary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  ...List.generate(10, (index) {
                    final angle = (index * 45) * math.pi / 180; // Every 45 degrees
                    final distance = 20 + random.nextInt(80); // Distance from center
                    final size = 20.0 + random.nextInt(20); // Size 3-5

                    final x = math.cos(angle) * distance + size / 2;
                    final y = math.sin(angle) * distance;

                    return Center(
                      child: Transform.translate(
                        offset: Offset(x, y),
                        child: Bone.square(
                          size: size,
                          borderRadius: BorderRadius.circular(size / 2),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
