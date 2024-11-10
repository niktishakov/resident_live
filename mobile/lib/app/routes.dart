import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/features/features.dart';
import 'package:resident_live/screens/all_countries/ui/all_countries_screen.dart';
import 'package:resident_live/screens/residence_details/residence_details_screen2.dart';
import 'package:resident_live/shared/shared.dart';

import '../screens/screens.dart';
import '../shared/router/router.dart';

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
          BlocProvider(
            create: (context) => GetStartedCubit(find<LocationCubit>(context)),
            child: const GetStartedScreen(),
          ),
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
    GoRoute(
      path: ScreenNames.residenceDetails2,
      name: ScreenNames.residenceDetails2,
      pageBuilder: (ctx, state) {
        final extra = state.extra as String;

        return kRootCupertinoPage(
          ResidenceDetailsScreen2(name: extra),
          ScreenNames.residenceDetails2,
        );
      },
    ),
    GoRoute(
      path: ScreenNames.allTrackingCountries,
      name: ScreenNames.allTrackingCountries,
      pageBuilder: (ctx, state) {
        return kRootCupertinoPage(
          AllCountriesScreen(),
          ScreenNames.allTrackingCountries,
        );
      },
    ),
    GoRoute(
      path: ScreenNames.language,
      name: ScreenNames.language,
      pageBuilder: (ctx, state) {
        return kRootCupertinoPage(
          const LanguageScreen(),
          ScreenNames.language,
        );
      },
    ),
    GoRoute(
      path: ScreenNames.webView,
      name: ScreenNames.webView,
      pageBuilder: (ctx, state) {
        return kSlideTransitionPage(
          WebViewScreen(
            url: state.extra as String,
            title: state.extra as String,
          ),
          ScreenNames.webView,
        );
      },
    ),
  ];
}
