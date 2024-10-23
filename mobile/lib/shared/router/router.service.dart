import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class RouterService {
  RouterService._(
    GlobalKey<NavigatorState> navigatorKey,
    List<RouteBase> routes,
    String initialLocation,
    List<RouteObserver> observers,
  ) {
    _goRouter =
        _buildGoRouter(navigatorKey, routes, initialLocation, observers);
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
    List<RouteObserver> observers = const [],
  }) async {
    assert(_instance == null);
    _instance =
        RouterService._(navigatorKey, routes, initialLocation, observers);
  }

  static GoRouter _buildGoRouter(
    GlobalKey<NavigatorState> navigatorKey,
    List<RouteBase> routes,
    String initialLocation,
    List<RouteObserver> observers,
  ) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: initialLocation,
      routes: routes,
      observers: observers,
    );
  }
}
