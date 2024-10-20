import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

PageRouteBuilder kDefaultFadeRouteBuilder({required Widget page}) {
  return PageRouteBuilder(
    transitionDuration: 300.ms,
    reverseTransitionDuration: 250.ms,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    pageBuilder: (context, _, __) => page,
  );
}
