import "package:domain/domain.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:country_code_picker/country_code_picker.dart";
import "package:resident_live/screens/splash/cubit/get_user_cubit.dart";
import "package:resident_live/screens/trips/cubit/trips_stream_cubit.dart";
import "package:resident_live/screens/trips/model/trip_model.dart";
import "package:resident_live/screens/validate_trip/widget/stay_limit/stay_limits_calculator.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";
import "package:resident_live/shared/shared.dart";

class TripRiskAnalysisWidget extends StatelessWidget {
  const TripRiskAnalysisWidget({required this.trip, super.key});

  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return BlocBuilder<GetUserCubit, ResourceState<UserEntity>>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: theme.bgModal, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Country Status Analysis",
                style: theme.body16.copyWith(color: theme.textPrimary, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              state.maybeWhen(
                data: (user) => BlocBuilder<TripsStreamCubit, List<TripEntity>>(
                  builder: (context, allTrips) {
                    return _buildCountryAnalysis(context, user, allTrips, theme);
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => _buildErrorState(theme),
                orElse: () => _buildErrorState(theme),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCountryAnalysis(
    BuildContext context,
    UserEntity user,
    List<TripEntity> allTrips,
    RlTheme theme,
  ) {
    final tripModel = TripModel(
      countryCode: trip.countryCode,
      fromDate: trip.fromDate,
      toDate: trip.toDate,
      backgroundUrl: trip.backgroundUrl,
    );

    final stayLimits = StayLimitsCalculator.calculateRealStayLimits(
      user,
      tripModel,
      theme,
      allTrips,
    );

    if (stayLimits.isEmpty) {
      return Text(
        "No country data available",
        style: theme.body14.copyWith(color: theme.textSecondary),
      );
    }

    return Column(
      children: stayLimits.map((limit) => _buildCountryItem(context, limit, theme)).toList(),
    );
  }

  Widget _buildCountryItem(BuildContext context, dynamic limit, RlTheme theme) {
    final countryName = CountryCode.fromCountryCode(
      limit.countryCode,
    ).localize(context).toCountryStringOnly();
    final isCurrentTrip = limit.countryCode == trip.countryCode;
    final isResident = limit.usedDays >= 183;
    final daysToResidency = isResident ? limit.usedDays - 183 : 183 - limit.usedDays;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      countryName,
                      style: theme.body14.copyWith(
                        color: theme.textPrimary,
                        fontWeight: isCurrentTrip ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    if (isCurrentTrip) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.bgAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "Current Trip",
                          style: theme.body12.copyWith(
                            color: theme.bgAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  "${limit.usedDays} days spent",
                  style: theme.body12.copyWith(color: theme.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isResident
                      ? Colors.red.withValues(alpha: 0.1)
                      : Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isResident ? "Resident" : "Non-Resident",
                  style: theme.body12.copyWith(
                    color: isResident ? Colors.red : Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isResident ? "$daysToResidency days over" : "$daysToResidency days left",
                style: theme.body12.copyWith(color: theme.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(RlTheme theme) {
    return Text(
      "Unable to load country analysis",
      style: theme.body14.copyWith(color: theme.textSecondary),
    );
  }
}
