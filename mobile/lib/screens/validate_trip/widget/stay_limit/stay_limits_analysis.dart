import "package:domain/domain.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:resident_live/screens/splash/cubit/get_user_cubit.dart";
import "package:resident_live/screens/trips/cubit/trips_stream_cubit.dart";
import "package:resident_live/screens/trips/model/trip_model.dart";
import "package:resident_live/screens/validate_trip/widget/stay_limit/mock_stay_limits.dart";
import "package:resident_live/screens/validate_trip/widget/stay_limit/stay_limit_item.dart";
import "package:resident_live/screens/validate_trip/widget/stay_limit/stay_limits_calculator.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";
import "package:resident_live/shared/shared.dart";

class StayLimitsAnalysis extends StatelessWidget {
  const StayLimitsAnalysis({required this.trip, super.key});

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return BlocBuilder<GetUserCubit, ResourceState<UserEntity>>(
      builder: (context, userState) {
        return BlocBuilder<TripsStreamCubit, List<TripEntity>>(
          builder: (context, allTrips) {
            return userState.maybeWhen(
              data: (user) {
                final stayLimits = StayLimitsCalculator.calculateRealStayLimits(
                  user,
                  trip,
                  theme,
                  allTrips,
                );
                return Column(
                  children: stayLimits
                      .mapIndexed(
                        (index, limit) => StayLimitItem(
                          limit: limit,
                        ).animate().fadeIn(duration: 300.ms, delay: 300.ms + (100.ms * index)),
                      )
                      .toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) {
                // Fallback to mock data if there's an error
                final mockLimits = getMockStayLimits(theme);
                return Column(
                  children: mockLimits.map((limit) => StayLimitItem(limit: limit)).toList(),
                );
              },
              orElse: () {
                // Fallback to mock data if no user data
                final mockLimits = getMockStayLimits(theme);
                return Column(
                  children: mockLimits.map((limit) => StayLimitItem(limit: limit)).toList(),
                );
              },
            );
          },
        );
      },
    );
  }
}
