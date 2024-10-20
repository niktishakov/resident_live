import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/shared/lib/utils/core_route_observer.dart';

class RouterService {
  RouterService._(
    GlobalKey<NavigatorState> navigatorKey,
    List<RouteBase> routes,
    String initialLocation,
  ) {
    _goRouter = _buildGoRouter(navigatorKey, routes, initialLocation);
  }

  static RouterService? _instance;
  static RouterService get instance {
    assert(_instance != null,
        'Remember to initialise RouterService by calling its init method');
    return _instance!;
  }

  late final GoRouter _goRouter;
  GoRouter get router => _goRouter;

  static Future<void> init({
    required GlobalKey<NavigatorState> navigatorKey,
    required List<RouteBase> routes,
    required String initialLocation,
  }) async {
    assert(_instance == null);
    _instance = RouterService._(navigatorKey, routes, initialLocation);
  }

  static GoRouter _buildGoRouter(
    GlobalKey<NavigatorState> navigatorKey,
    List<RouteBase> routes,
    String initialLocation,
  ) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: initialLocation,
      routes: routes,
      observers: [CoreRouteObserver()],
    );
  }
}
