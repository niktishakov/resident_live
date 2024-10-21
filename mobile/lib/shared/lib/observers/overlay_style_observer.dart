import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/navigation/screen_names.dart';
import 'overlay_styles.dart';

class OverlayStyleObserver extends RouteObserver<PageRoute<dynamic>> {
  final Map<String, SystemUiOverlayStyle> _screenOverlayStyles = {
    ScreenNames.splash: kLightOverlayStyle,
    ScreenNames.home: kLightOverlayStyle,
    ScreenNames.settings: kLightOverlayStyle,
    ScreenNames.language: kLightOverlayStyle,
    ScreenNames.onboarding: kLightOverlayStyle,
  };

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _updateOverlayStyle(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _updateOverlayStyle(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _updateOverlayStyle(newRoute);
  }

  void _updateOverlayStyle(Route<dynamic>? route) {
    if (route is PageRoute) {
      final routeName = route.settings.name;

      if (routeName != null && _screenOverlayStyles.containsKey(routeName)) {
        SystemChrome.setSystemUIOverlayStyle(_screenOverlayStyles[routeName]!);
      } else {
        // Default to light style if not specified
        SystemChrome.setSystemUIOverlayStyle(kLightOverlayStyle);
      }
    }
  }
}
