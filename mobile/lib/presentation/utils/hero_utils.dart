import 'package:flutter/material.dart';
import 'package:resident_live/core/constants.dart';

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
            child: flightDirection == HeroFlightDirection.push
                ? fromHeroContext.widget
                : toHeroContext.widget,
          ),
          FadeTransition(
            opacity: animation,
            child: flightDirection == HeroFlightDirection.push
                ? toHeroContext.widget
                : fromHeroContext.widget,
          ),
        ],
      );
    },
  );
}

Widget startFlightShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      // Define separate animations for fading in and fading out
      final fadeOutTween =
          Tween<double>(begin: 1.0, end: 0.0).animate(animation);
      final fadeInTween =
          Tween<double>(begin: 0.0, end: 1.0).animate(animation);
      final borderRadiusTween = Tween<double>(
        begin: kBorderRadius.topLeft.x,
        end: kLargeBorderRadius.bottomLeft.x,
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

Widget endFlightShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      // Define separate animations for fading in and fading out
      final fadeOutTween =
          Tween<double>(begin: 1.0, end: 1.0).animate(animation);
      final fadeInTween = Tween<double>(begin: 1.0, end: 0).animate(animation);
      final borderRadiusTween = Tween<double>(
        begin: kBorderRadius.topLeft.x,
        end: kLargeBorderRadius.bottomLeft.x,
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
