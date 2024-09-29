import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/presentation/screens/add_residency/add_residency_screen.dart';
import 'package:resident_live/presentation/screens/home/home_screen.dart';
import 'package:resident_live/presentation/screens/onboarding/allow_location_screen.dart';
import 'package:resident_live/presentation/screens/residence_details/residence_details_screen.dart';
import 'package:resident_live/presentation/utils/core_route_observer.dart';

import '../screens/bottom_bar/bottom_bar.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/splash/splash_screen.dart';
import 'screen_names.dart';

class RouterService {
  static RouterService? _instance;
  static RouterService get instance {
    assert(_instance != null,
        'Remember to initialise RouterService by calling its init method');
    return _instance!;
  }

  late final GoRouter _goRouter;
  GoRouter get config => _goRouter;

  RouterService._(GlobalKey<NavigatorState> screenNavigatorKey,
      GlobalKey<NavigatorState> shellKey) {
    _goRouter = _buildGoRouter(screenNavigatorKey, shellKey);
  }

  static Future<void> init(
    GlobalKey<NavigatorState> screenNavigatorKey,
    GlobalKey<NavigatorState> shellKey,
  ) async {
    assert(_instance == null);
    _instance = RouterService._(screenNavigatorKey, shellKey);
  }

  static GoRouter _buildGoRouter(
    GlobalKey<NavigatorState> screenNavigatorKey,
    GlobalKey<NavigatorState> shellKey,
  ) {
    return GoRouter(
      initialLocation: ScreenNames.splash,
      navigatorKey: screenNavigatorKey,
      observers: [
        CoreRouteObserver(),
      ],
      routes: [
        GoRoute(
          path: ScreenNames.splash,
          name: ScreenNames.splash,
          pageBuilder: (ctx, state) {
            return _rootCupertinoPage(
              const SplashScreen(),
              ScreenNames.splash,
            );
          },
        ),
        ShellRoute(
          navigatorKey: shellKey,
          pageBuilder: (ctx, state, child) {
            return CupertinoPage(
              child: AiBottomBar(
                state: state,
                child: child,
              ),
              name: state.uri.toString(),
            );
          },
          routes: [
            GoRoute(
              parentNavigatorKey: shellKey,
              path: ScreenNames.home,
              name: ScreenNames.home,
              pageBuilder: (context, state) => _noTransitionPage(
                const HomeScreen(),
                ScreenNames.home,
              ),
            ),
            GoRoute(
              parentNavigatorKey: shellKey,
              path: ScreenNames.settings,
              name: ScreenNames.settings,
              pageBuilder: (context, state) => _noTransitionPage(
                const SettingsScreen(),
                ScreenNames.settings,
              ),
            ),
          ],
        ),
        GoRoute(
          path: ScreenNames.onboarding,
          name: ScreenNames.onboarding,
          pageBuilder: (ctx, state) {
            return _rootCupertinoPage(
              const OnboardingScreen(),
              ScreenNames.onboarding,
            );
          },
        ),
        GoRoute(
          path: ScreenNames.allowLocation,
          name: ScreenNames.allowLocation,
          pageBuilder: (ctx, state) {
            return _rootCupertinoPage(
              const AllowLocationScreen(),
              ScreenNames.allowLocation,
            );
          },
        ),
        GoRoute(
          path: ScreenNames.addResidency,
          name: ScreenNames.addResidency,
          pageBuilder: (ctx, state) {
            return _rootCupertinoPage(
              AddCountryResidencyScreen(),
              ScreenNames.addResidency,
            );
          },
        ),

        // GoRoute(
        //   path: ScreenNames.residenceDetails,
        //   name: ScreenNames.residenceDetails,
        //   pageBuilder: (ctx, state) {
        //     final extra = state.extra as String;

        //     return _rootCupertinoPage(
        //       ResidenceDetailsScreen(countryName: extra),
        //       ScreenNames.residenceDetails,
        //     );
        //   },
        // ),
      ],
    );
  }
}

Page _rootCupertinoPage(Widget child, String? name) {
  return CupertinoPage(child: child, name: name, key: ValueKey(name));
}

Page _noTransitionPage(Widget child, String? name) {
  return NoTransitionPage(
    key: ValueKey(name),
    name: name,
    child: child,
  );
}
