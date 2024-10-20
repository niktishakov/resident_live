import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

Page kRootCupertinoPage(Widget child, String? name) {
  return CupertinoPage(child: child, name: name, key: ValueKey(name));
}

Page kNoTransitionPage(Widget child, String? name) {
  return NoTransitionPage(
    key: ValueKey(name),
    name: name,
    child: child,
  );
}

Page kFadedTransitionPage(Widget child, String? name) {
  return CustomTransitionPage(
    key: ValueKey(name),
    name: name,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(
      opacity: animation,
      child: child,
    ),
    child: child,
  );
}

Page kSlideTransitionPage(Widget screen, String name) {
  return CustomTransitionPage(
    key: ValueKey(name),
    name: name,
    child: screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
        )),
        child: child,
      );
    },
  );
}

Page kShellTabPage(Widget child, String name) {
  return CupertinoPage(
    key: ValueKey(name),
    name: name,
    child: child,
  );
}
