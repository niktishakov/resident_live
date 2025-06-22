import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/screens/add_trip/add_trip_screen.dart";
import "package:resident_live/screens/add_trip/cubit/add_trip_cubit.dart";
import "package:resident_live/screens/add_trip/validate_trip_screen.dart";
import "package:resident_live/screens/all_countries/all_countries_screen.dart";
import "package:resident_live/screens/bottom_bar/bottom_bar.dart";
import "package:resident_live/screens/home/home_screen.dart";
import "package:resident_live/screens/language/language_screen.dart";
import "package:resident_live/screens/manage_countries/manage_countries_screen.dart";
import "package:resident_live/screens/map/map_screen.dart";
import "package:resident_live/screens/onboarding/onboarding_screen.dart";
import "package:resident_live/screens/onboarding/pages/get_started/cubit/get_started_cubit.dart";
import "package:resident_live/screens/onboarding/pages/get_started/get_started_screen.dart";
import "package:resident_live/screens/residence_details/residence_details_screen.dart";
import "package:resident_live/screens/residence_details/residence_details_screen2.dart";
import "package:resident_live/screens/settings/settings_screen.dart";
import "package:resident_live/screens/splash/cubit/get_user_cubit.dart";
import "package:resident_live/screens/splash/splash_screen.dart";
import "package:resident_live/screens/trips/cubit/trips_cubit.dart";
import "package:resident_live/screens/trips/trips_screen.dart";
import "package:resident_live/shared/shared.dart";

List<RouteBase> getRoutes(GlobalKey<NavigatorState> shellKey) {
  return [
    GoRoute(
      path: ScreenNames.splash,
      name: ScreenNames.splash,
      pageBuilder: (ctx, state) {
        return kRootCupertinoPage(
          BlocProvider(create: (context) => getIt<GetUserCubit>(), child: const SplashScreen()),
          ScreenNames.splash,
        );
      },
    ),
    ShellRoute(
      navigatorKey: shellKey,
      pageBuilder: (ctx, state, child) {
        return CupertinoPage(
          child: AiBottomBar(state: state, child: child),
          name: state.uri.toString(),
        );
      },
      routes: [
        GoRoute(
          parentNavigatorKey: shellKey,
          path: ScreenNames.home,
          name: ScreenNames.home,
          pageBuilder: (context, state) => kNoTransitionPage(
            BlocProvider(create: (context) => getIt<GetUserCubit>(), child: const HomeScreen()),
            ScreenNames.home,
          ),
        ),
        GoRoute(
          path: ScreenNames.trips,
          name: ScreenNames.trips,
          pageBuilder: (ctx, state) {
            return kNoTransitionPage(
              BlocProvider(create: (context) => getIt<TripsCubit>(), child: const TripsScreen()),
              ScreenNames.trips,
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: shellKey,
          path: ScreenNames.settings,
          name: ScreenNames.settings,
          pageBuilder: (context, state) => kNoTransitionPage(
            BlocProvider(create: (context) => getIt<GetUserCubit>(), child: const SettingsScreen()),
            ScreenNames.settings,
          ),
        ),
      ],
    ),
    GoRoute(
      path: ScreenNames.onboarding,
      name: ScreenNames.onboarding,
      pageBuilder: (ctx, state) {
        return kRootCupertinoPage(const OnboardingScreen(), ScreenNames.onboarding);
      },
    ),
    GoRoute(
      path: ScreenNames.getStarted,
      name: ScreenNames.getStarted,
      pageBuilder: (ctx, state) {
        return kRootCupertinoPage(
          BlocProvider(
            create: (context) => GetStartedCubit(
              getIt<RequestGeoPermissionUsecase>(),
              getIt<GetCoordinatesUsecase>(),
              getIt<GetPlacemarkUsecase>(),
              getIt<SyncCountriesFromGeoUseCase>(),
            ),
            child: const GetStartedScreen(),
          ),
          ScreenNames.getStarted,
        );
      },
    ),
    GoRoute(
      path: ScreenNames.manageCountries,
      name: ScreenNames.manageCountries,
      pageBuilder: (ctx, state) {
        return kRootCupertinoPage(const ManageCountriesScreen(), ScreenNames.manageCountries);
      },
    ),
    GoRoute(
      path: ScreenNames.residenceDetails,
      name: ScreenNames.residenceDetails,
      pageBuilder: (ctx, state) {
        final extra = state.extra! as String;

        return kRootCupertinoPage(
          ResidenceDetailsScreen(countryCode: extra),
          ScreenNames.residenceDetails,
        );
      },
    ),
    GoRoute(
      path: ScreenNames.residenceDetails2,
      name: ScreenNames.residenceDetails2,
      pageBuilder: (ctx, state) {
        final extra = state.extra! as String;

        return kRootCupertinoPage(
          ResidenceDetailsScreen2(countryCode: extra),
          ScreenNames.residenceDetails2,
        );
      },
    ),
    GoRoute(
      path: ScreenNames.allTrackingCountries,
      name: ScreenNames.allTrackingCountries,
      pageBuilder: (ctx, state) {
        return kRootCupertinoPage(const AllCountriesScreen(), ScreenNames.allTrackingCountries);
      },
    ),
    GoRoute(
      path: ScreenNames.language,
      name: ScreenNames.language,
      pageBuilder: (ctx, state) {
        return kRootCupertinoPage(const LanguageScreen(), ScreenNames.language);
      },
    ),

    GoRoute(
      path: ScreenNames.map,
      name: ScreenNames.map,
      pageBuilder: (ctx, state) {
        return kRootCupertinoPage(
          MapScreen(stayPeriods: state.extra! as List<StayPeriodValueObject>),
          ScreenNames.map,
        );
      },
    ),

    ShellRoute(
      pageBuilder: (ctx, state, child) {
        return CupertinoPage(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<AddTripCubit>()),
              BlocProvider(create: (context) => getIt<GetUserCubit>()),
            ],
            child: child,
          ),
          name: state.uri.toString(),
        );
      },
      routes: [
        GoRoute(
          path: ScreenNames.addTrip,
          name: ScreenNames.addTrip,
          pageBuilder: (context, state) =>
              kRootCupertinoPage(const AddTripScreen(), ScreenNames.addTrip),
        ),

        GoRoute(
          path: ScreenNames.validateTrip,
          name: ScreenNames.validateTrip,
          pageBuilder: (context, state) =>
              kRootCupertinoPage(const ValidateTripScreen(), ScreenNames.validateTrip),
        ),
      ],
    ),
  ];
}
