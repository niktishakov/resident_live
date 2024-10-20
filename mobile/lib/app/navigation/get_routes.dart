import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../screens/screens.dart';
import '../../shared/router/page_types.dart';
import 'screen_names.dart';

List<RouteBase> getRoutes(GlobalKey<NavigatorState> shellKey) {
  return [
    GoRoute(
      path: ScreenNames.splash,
      name: ScreenNames.splash,
      pageBuilder: (ctx, state) {
        return kRootCupertinoPage(
          SplashScreen(),
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
          pageBuilder: (context, state) => kNoTransitionPage(
            const HomeScreen(),
            ScreenNames.home,
          ),
        ),
        GoRoute(
          parentNavigatorKey: shellKey,
          path: ScreenNames.settings,
          name: ScreenNames.settings,
          pageBuilder: (context, state) => kNoTransitionPage(
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
        return kRootCupertinoPage(
          const OnboardingScreen(),
          ScreenNames.onboarding,
        );
      },
    ),
    GoRoute(
      path: ScreenNames.getStarted,
      name: ScreenNames.getStarted,
      pageBuilder: (ctx, state) {
        return kRootCupertinoPage(
          const GetStartedScreen(),
          ScreenNames.getStarted,
        );
      },
    ),
    GoRoute(
      path: ScreenNames.addCountry,
      name: ScreenNames.addCountry,
      pageBuilder: (ctx, state) {
        return kRootCupertinoPage(
          AddCountryResidencyScreen(),
          ScreenNames.addCountry,
        );
      },
    ),
    GoRoute(
      path: ScreenNames.residenceDetails,
      name: ScreenNames.residenceDetails,
      pageBuilder: (ctx, state) {
        final extra = state.extra as String;

        return kRootCupertinoPage(
          ResidenceDetailsScreen(name: extra),
          ScreenNames.residenceDetails,
        );
      },
    ),
  ];
}
