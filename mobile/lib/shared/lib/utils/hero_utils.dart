import "package:flutter/material.dart";
import "package:resident_live/shared/lib/constants.dart";

Widget kFlightShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      return Stack(
        alignment: Alignment.center,
        children: [
          FadeTransition(
            opacity: animation,
            child: flightDirection == HeroFlightDirection.push ? fromHeroContext.widget : toHeroContext.widget,
          ),
          FadeTransition(
            opacity: animation,
            child: flightDirection == HeroFlightDirection.push ? toHeroContext.widget : fromHeroContext.widget,
          ),
        ],
      );
    },
  );
}

/// Use this to animate to the second hero widget
Widget toFirstHeroFlightShuttleBuilder({
  required BuildContext flightContext,
  required Animation<double> animation,
  required HeroFlightDirection flightDirection,
  required BuildContext fromHeroContext,
  required BuildContext toHeroContext,
  double? beginBorderRadius,
  double? endBorderRadius,
}) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      // Define separate animations for fading in and fading out
      final fadeOutTween = Tween<double>(begin: 1.0, end: 0.0).animate(animation);
      final fadeInTween = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
      final borderRadiusTween = Tween<double>(
        begin: beginBorderRadius ?? kBorderRadius,
        end: endBorderRadius ?? kLargeBorderRadius,
      ).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      );

      // Stack both widgets to animate them in parallel
      return Stack(
        children: [
          // The widget that's being transitioned from
          FadeTransition(
            opacity: fadeOutTween,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadiusTween.value),
              clipBehavior: Clip.hardEdge,
              child: toHeroContext.widget,
            ),
          ),
          // The widget that's being transitioned to
          FadeTransition(
            opacity: fadeInTween,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadiusTween.value),
              clipBehavior: Clip.hardEdge,
              child: fromHeroContext.widget,
            ),
          ),
        ],
      );
    },
  );
}

/// Use this to animate back to the first hero widget
Widget toSecondHeroFlightShuttleBuilder({
  required BuildContext flightContext,
  required Animation<double> animation,
  required HeroFlightDirection flightDirection,
  required BuildContext fromHeroContext,
  required BuildContext toHeroContext,
  double? beginBorderRadius,
  double? endBorderRadius,
}) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      // Define separate animations for fading in and fading out
      final borderRadiusTween = Tween<double>(
        begin: beginBorderRadius ?? kBorderRadius,
        end: endBorderRadius ?? kLargeBorderRadius,
      ).animate(
        CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
      );

      // Stack both widgets to animate them in parallel
      return Stack(
        children: [
          // The widget that's being transitioned from
          FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 0.0).animate(animation),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadiusTween.value),
              clipBehavior: Clip.hardEdge,
              child: fromHeroContext.widget,
            ),
          ),
          // The widget that's being transitioned to
          FadeTransition(
            opacity: Tween<double>(begin: 1.0, end: 1.0).animate(animation),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadiusTween.value),
              clipBehavior: Clip.hardEdge,
              child: toHeroContext.widget,
            ),
          ),
        ],
      );
    },
  );
}
