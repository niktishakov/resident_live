import "package:flutter/material.dart";

import "package:resident_live/shared/lib/ai.logger.dart";

class CoreRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  List<Route<dynamic>> routeStack = [];

  static final _logger = AiLogger("CoreRouteObserver");

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    routeStack.add(route);
    _logger.info(routeToString());
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    routeStack.remove(route);
    _logger.info(routeToString());
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    routeStack.remove(route);
    _logger.info(routeToString());
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    routeStack.remove(oldRoute);
    routeStack.add(newRoute!);
    _logger.info(routeToString());
  }



  String routeToString() {
    return routeStack.map((item) => item.settings.name).toList().toString();
  }
}
