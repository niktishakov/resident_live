import "package:domain/domain.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/screens/map/cubit/country_bg_cubit.dart";
import "package:resident_live/screens/splash/cubit/get_user_cubit.dart";
import "package:resident_live/screens/trip_details/widgets/trip_actions_widget.dart";
import "package:resident_live/screens/trip_details/widgets/trip_header_sliver_delegate.dart";
import "package:resident_live/screens/trip_details/widgets/trip_risk_analysis_widget.dart";
import "package:resident_live/screens/trip_details/widgets/trip_stats_widget.dart";
import "package:resident_live/shared/shared.dart";

class TripDetailsScreen extends StatelessWidget {
  const TripDetailsScreen({required this.trip, super.key});

  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<CountryBackgroundCubit>()..loadCountryBackground(trip.countryCode),
        ),
        BlocProvider(create: (_) => getIt<GetUserCubit>()..loadResource()),
      ],
      child: Material(
        child: Scaffold(
          backgroundColor: theme.bgPrimary,
          body: CustomScrollView(
            slivers: [
              // Hero animated header image as SliverPersistentHeader
              SliverPersistentHeader(
                delegate: TripHeaderSliverDelegate(trip: trip),
                pinned: false,
                floating: false,
              ),
              // Trip details content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Trip stats
                      TripStatsWidget(trip: trip),
                      const SizedBox(height: 24),
                      // Country status analysis section
                      TripRiskAnalysisWidget(trip: trip),
                      const SizedBox(height: 24),
                      // Actions section
                      TripActionsWidget(trip: trip),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
