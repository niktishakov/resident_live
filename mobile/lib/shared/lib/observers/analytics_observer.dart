import "package:data/data.dart";
import "package:flutter/cupertino.dart";
import "package:get_it/get_it.dart";
import "package:resident_live/shared/router/screen_names.dart";

/// Adapted from firebase_analytics package v.6.0.2

/// A [NavigatorObserver] that notifies [AiAnalytics] when the currently active [PageRoute] changes.
///
/// When a route is pushed or popped, [nameExtractor] is used to extract a name
/// from [RouteSettings] of the now active route.
class AiAnalyticsObserver extends NavigatorObserver {
  AiAnalyticsObserver(this._aiAnalytics);
  final AiAnalytics _aiAnalytics;
  final _logger = GetIt.I<LoggerService>();

  final _excludedRoutes = [
    ScreenNames.bottomBarShell,
  ];

  void _sendScreenView(PageRoute<dynamic> route) {
    final screenName = route.settings.name;
    final args = route.settings.arguments;

    _logger.debug("_sendScreenView: $screenName");

    // prevent sending a not relevant router events
    if (_excludedRoutes.contains(screenName)) return;

    if (screenName != null) {
      _aiAnalytics.setCurrentScreen(screenName, args: args);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
  }
}
