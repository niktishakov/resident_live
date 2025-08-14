import "dart:ui";

import "package:flutter/material.dart";
import "package:resident_live/screens/home/widgets/greeting_view.dart";
import "package:resident_live/shared/shared.dart";

class HomeSliverHeader extends SliverPersistentHeaderDelegate {
  HomeSliverHeader({required this.expandedHeight});
  final double expandedHeight;

  @override
  double get minExtent => expandedHeight;

  @override
  double get maxExtent => expandedHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = context.rlTheme;
    final proportion = (expandedHeight - shrinkOffset) / expandedHeight;
    final blurOpacity = (1 - proportion) * 20;
    final dividerOpacity = ((1 - proportion) * 4).clamp(0.0, 0.8);
    final colorOpacity = ((1 - proportion) * 4).clamp(0.0, 0.5);
    final dividerColor = theme.dividerPrimary;

    return RepaintBoundary(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurOpacity, sigmaY: blurOpacity),
          child: ColoredBox(
            color: theme.bgPrimary.withValues(alpha: colorOpacity),
            child: Stack(
              children: [
                const Positioned(left: 24, bottom: 12.0, child: GreetingView()),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: dividerColor.withValues(alpha: dividerOpacity),
                    height: 1.0,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant HomeSliverHeader oldDelegate) {
    return oldDelegate.expandedHeight != expandedHeight; // Ребилдим только при изменении высоты
  }
}
