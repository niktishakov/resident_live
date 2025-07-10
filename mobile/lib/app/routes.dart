import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/screens/add_trip/add_trip_screen.dart";
import "package:resident_live/screens/add_trip/cubit/add_trip_cubit.dart";
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
import "package:resident_live/screens/trip_details/trip_details_screen.dart";
import "package:resident_live/screens/trips/cubit/delete_trip_cubit.dart";
import "package:resident_live/screens/trips/cubit/trips_stream_cubit.dart";
import "package:resident_live/screens/trips/model/trip_model.dart";
import "package:resident_live/screens/trips/trips_screen.dart";
import "package:resident_live/screens/validate_trip/cubit/save_trip_cubit.dart";
import "package:resident_live/screens/validate_trip/validate_trip_screen.dart";
import "package:resident_live/shared/shared.dart";

final _homeKey = GlobalKey<NavigatorState>();
final _tripsKey = GlobalKey<NavigatorState>();
final _settingsKey = GlobalKey<NavigatorState>();

List<RouteBase> getRoutes(GlobalKey<NavigatorState> shellKey) {
  return [
    GoRoute(
      path: ScreenNames.splash,
      name: ScreenNames.splash,
      pageBuilder: (ctx, state) => kRootCupertinoPage(
        BlocProvider(create: (context) => getIt<GetUserCubit>(), child: const SplashScreen()),
        ScreenNames.splash,
      ),
    ),
    ShellRoute(
      navigatorKey: shellKey,
      pageBuilder: (ctx, state, child) => CupertinoPage(
        child: AiBottomBar(state: state, child: child),
        name: state.uri.toString(),
      ),
      routes: [
        ShellRoute(
          navigatorKey: _homeKey,
          pageBuilder: (ctx, state, child) => NoTransitionPage(child: child),
          routes: [
            GoRoute(
              path: ScreenNames.home,
              name: ScreenNames.home,
              pageBuilder: (context, state) => kNoTransitionPage(
                BlocProvider(create: (context) => getIt<GetUserCubit>(), child: const HomeScreen()),
                ScreenNames.home,
              ),
            ),
          ],
        ),
        ShellRoute(
          navigatorKey: _tripsKey,
          pageBuilder: (ctx, state, child) => NoTransitionPage(child: child),
          routes: [
            GoRoute(
              path: ScreenNames.trips,
              name: ScreenNames.trips,
              pageBuilder: (ctx, state) => kNoTransitionPage(
                MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context) => getIt<TripsStreamCubit>()),
                    BlocProvider(create: (context) => getIt<DeleteTripCubit>()),
                  ],
                  child: const TripsScreen(),
                ),
                ScreenNames.trips,
              ),
            ),
          ],
        ),
        ShellRoute(
          navigatorKey: _settingsKey,
          pageBuilder: (ctx, state, child) => NoTransitionPage(child: child),
          routes: [
            GoRoute(
              path: ScreenNames.settings,
              name: ScreenNames.settings,
              pageBuilder: (context, state) => kNoTransitionPage(
                BlocProvider(
                  create: (context) => getIt<GetUserCubit>(),
                  child: const SettingsScreen(),
                ),
                ScreenNames.settings,
              ),
            ),
          ],
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
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<GetStartedCubit>()),
              BlocProvider(create: (context) => getIt<GetUserCubit>()),
            ],
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

    GoRoute(
      path: ScreenNames.addTrip,
      name: ScreenNames.addTrip,
      pageBuilder: (context, state) => kRootCupertinoPage(
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  getIt<AddTripCubit>()..initializeWithTrip(state.extra as TripEntity?),
            ),
            BlocProvider(create: (context) => getIt<TripsStreamCubit>()),
          ],
          child: const AddTripScreen(),
        ),
        ScreenNames.addTrip,
      ),
    ),
    GoRoute(
      path: ScreenNames.validateTrip,
      name: ScreenNames.validateTrip,
      pageBuilder: (context, state) {
        final trip = state.extra! as TripModel;
        return kRootCupertinoPage(
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<SaveTripCubit>()),
              BlocProvider(create: (context) => getIt<GetUserCubit>()),
              BlocProvider(create: (context) => getIt<TripsStreamCubit>()),
            ],
            child: ValidateTripScreen(trip: trip),
          ),
          ScreenNames.validateTrip,
        );
      },
    ),
    GoRoute(
      path: ScreenNames.tripDetails,
      name: ScreenNames.tripDetails,
      pageBuilder: (context, state) {
        final trip = state.extra! as TripEntity;
        return kRootCupertinoPage(
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<DeleteTripCubit>()),
              BlocProvider(create: (context) => getIt<TripsStreamCubit>()),
              BlocProvider(create: (context) => getIt<GetUserCubit>()),
            ],
            child: TripDetailsScreen(trip: trip),
          ),
          ScreenNames.tripDetails,
        );
      },
    ),
  ];
}
