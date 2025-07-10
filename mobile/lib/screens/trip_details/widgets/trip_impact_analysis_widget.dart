import "dart:math" as math;

import "package:country_code_picker/country_code_picker.dart";
import "package:domain/domain.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:resident_live/screens/splash/cubit/get_user_cubit.dart";
import "package:resident_live/screens/trips/cubit/trips_stream_cubit.dart";
import "package:resident_live/screens/trips/model/trip_model.dart";
import "package:resident_live/screens/validate_trip/widget/stay_limit/stay_limit_data.dart";
import "package:resident_live/screens/validate_trip/widget/stay_limit/stay_limits_calculator.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";
import "package:resident_live/shared/shared.dart";

class TripImpactAnalysisWidget extends StatelessWidget {
  const TripImpactAnalysisWidget({required this.trip, super.key});

  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return BlocBuilder<GetUserCubit, ResourceState<UserEntity>>(
      builder: (context, userState) {
        return BlocBuilder<TripsStreamCubit, List<TripEntity>>(
          builder: (context, allTrips) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.bgModal,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Impact Analysis",
                    style: theme.body16.copyWith(
                      color: theme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  userState.maybeWhen(
                    data: (user) => _buildImpactAnalysis(context, user, allTrips, theme),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => _buildErrorState(theme),
                    orElse: () => _buildErrorState(theme),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildImpactAnalysis(
    BuildContext context,
    UserEntity user,
    List<TripEntity> allTrips,
    RlTheme theme,
  ) {
    // Convert TripEntity to TripModel for StayLimitsCalculator
    final tripModel = TripModel.fromEntity(trip);

    // Calculate current state (without this trip) - use empty trip to get baseline
    final emptyTrip = tripModel.copyWith(
      countryCode: "XX", // Non-existent country code
      fromDate: DateTime.now().subtract(const Duration(days: 1)),
      toDate: DateTime.now().subtract(const Duration(days: 1)),
    );

    final currentLimits = StayLimitsCalculator.calculateRealStayLimits(
      user,
      emptyTrip, // Use empty trip to get current state
      theme,
      allTrips.where((t) => t.id != trip.id).toList(), // Exclude current trip
    );

    // Calculate future state (with this trip)
    final futureLimits = StayLimitsCalculator.calculateRealStayLimits(
      user,
      tripModel,
      theme,
      allTrips.where((t) => t.id != trip.id).toList(), // Exclude current trip
    );

    // Debug information
    print("Current limits: ${currentLimits.length}");
    print("Future limits: ${futureLimits.length}");
    print("Trip country: ${trip.countryCode}");
    for (final limit in currentLimits) {
      print("Current: ${limit.countryCode} - ${limit.usedDays} days");
    }
    for (final limit in futureLimits) {
      print("Future: ${limit.countryCode} - ${limit.usedDays} days");
    }

    // Convert to impact data
    final impactData = _createImpactData(currentLimits, futureLimits, trip.countryCode);

    print("Impact data: ${impactData.length}");

    if (impactData.isEmpty) {
      // Show debug info if no data
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Debug Info:", style: theme.body14.copyWith(color: theme.textSecondary)),
          Text(
            "Current limits: ${currentLimits.length}",
            style: theme.body12.copyWith(color: theme.textSecondary),
          ),
          Text(
            "Future limits: ${futureLimits.length}",
            style: theme.body12.copyWith(color: theme.textSecondary),
          ),
          Text(
            "Trip country: ${trip.countryCode}",
            style: theme.body12.copyWith(color: theme.textSecondary),
          ),
          if (futureLimits.isNotEmpty)
            ...futureLimits.map(
              (limit) => Text(
                "${limit.countryCode}: ${limit.usedDays}/${limit.maxDays} days",
                style: theme.body12.copyWith(color: theme.textSecondary),
              ),
            ),
        ],
      );
    }

    return Column(
      children: impactData
          .mapIndexed(
            (index, data) => _buildStayLimitItem(
              context,
              data,
              theme,
            ).animate().fadeIn(duration: 300.ms, delay: (100.ms * index)),
          )
          .toList(),
    );
  }

  List<StayLimitImpactData> _createImpactData(
    List<StayLimitData> currentLimits,
    List<StayLimitData> futureLimits,
    String tripCountryCode,
  ) {
    final impactData = <StayLimitImpactData>[];

    // Create maps for quick lookup
    final currentLimitsMap = {for (final limit in currentLimits) limit.countryCode: limit};
    final futureLimitsMap = {for (final limit in futureLimits) limit.countryCode: limit};

    // Get all countries affected
    final allCountries = <String>{
      ...currentLimitsMap.keys,
      ...futureLimitsMap.keys,
      tripCountryCode, // Always include trip destination
    };

    // Process each country
    for (final countryCode in allCountries) {
      final currentLimit = currentLimitsMap[countryCode];
      final futureLimit = futureLimitsMap[countryCode];

      final currentDays = currentLimit?.usedDays ?? 0;
      var futureDays = futureLimit?.usedDays ?? 0;
      final maxDays = futureLimit?.maxDays ?? currentLimit?.maxDays ?? 183;

      // Special handling for trip destination country
      if (countryCode == tripCountryCode) {
        // If this is the trip destination and it's not in future limits,
        // add the trip days manually
        if (futureLimit == null) {
          futureDays = currentDays + trip.days;
        }
      }

      // Show if there's a change or it's the trip destination
      if (currentDays != futureDays ||
          countryCode == tripCountryCode ||
          currentDays > 0 ||
          futureDays > 0) {
        impactData.add(
          StayLimitImpactData(
            countryCode: countryCode,
            currentDays: currentDays,
            futureDays: futureDays,
            maxDays: maxDays,
            isCurrentTrip: countryCode == tripCountryCode,
            statusWillChange: (currentDays < 183) != (futureDays < 183),
            tripDays: futureDays - currentDays,
          ),
        );
      }
    }

    // Sort by importance: trip destination first, then by future days
    impactData.sort((a, b) {
      if (a.isCurrentTrip && !b.isCurrentTrip) return -1;
      if (!a.isCurrentTrip && b.isCurrentTrip) return 1;
      return b.futureDays.compareTo(a.futureDays);
    });

    return impactData;
  }

  Widget _buildStayLimitItem(BuildContext context, StayLimitImpactData data, RlTheme theme) {
    final countryName = CountryCode.fromCountryCode(
      data.countryCode,
    ).localize(context).toCountryStringOnly();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Country header with current trip indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    countryName,
                    style: theme.body16.copyWith(
                      color: theme.textPrimary,
                      fontWeight: data.isCurrentTrip ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  if (data.isCurrentTrip) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.bgAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "This Trip",
                        style: theme.body12.copyWith(
                          color: theme.bgAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                data.isCurrentTrip
                    ? "${data.currentDays} → ${data.futureDays} days"
                    : "${data.futureDays} ← ${data.currentDays} days",
                style: theme.body14.copyWith(color: theme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Animated progress bar
          _buildAnimatedProgressBar(context, data, theme),
          const SizedBox(height: 8),

          // Status and warning
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(),
              if (data.statusWillChange)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: data.futureDays <= 183
                        ? theme.bgWarning.withValues(alpha: 0.1)
                        : theme.bgSuccess.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    data.willBeResident ? "Will become Resident" : "Will lose Residency",
                    style: theme.body12.copyWith(
                      color: data.futureDays <= 183 ? theme.bgWarning : theme.bgSuccess,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedProgressBar(BuildContext context, StayLimitImpactData data, RlTheme theme) {
    return Container(
      height: 8,
      decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(4)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          children: [
            // Background
            Container(
              decoration: BoxDecoration(
                color: theme.bgSecondary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            // Current progress (lighter color)
            if (data.currentProgress > 0)
              FractionallySizedBox(
                widthFactor: data.currentProgress.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.textAccent.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ).animate(delay: 1.seconds).shimmer(duration: 1.seconds, angle: math.pi),

            // Future progress (darker color) - animated
            AnimatedContainer(
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              width: MediaQuery.of(context).size.width * data.futureProgress.clamp(0.0, 1.0),
              decoration: BoxDecoration(
                color: _getProgressColor(data, theme),
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            // Residency threshold line at 183 days
            if (data.maxDays > 0)
              Positioned(
                left: (183 / 365) * (MediaQuery.of(context).size.width - 32),
                child: Container(
                  width: 2,
                  height: 8,
                  color: theme.textSecondary.withValues(alpha: 0.5),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getProgressColor(StayLimitImpactData data, RlTheme theme) {
    if (data.futureDays <= 183 && data.currentDays > 183) {
      return theme.bgWarning; // Over residency threshold
    } else {
      return theme.bgAccent; // Safe zone
    }
  }

  Widget _buildErrorState(RlTheme theme) {
    return Text(
      "Unable to load impact analysis",
      style: theme.body14.copyWith(color: theme.textSecondary),
    );
  }
}

class StayLimitImpactData {
  const StayLimitImpactData({
    required this.countryCode,
    required this.currentDays,
    required this.futureDays,
    required this.maxDays,
    required this.isCurrentTrip,
    required this.statusWillChange,
    this.tripDays = 0,
  });

  final String countryCode;
  final int currentDays;
  final int futureDays;
  final int maxDays;
  final bool isCurrentTrip;
  final bool statusWillChange;
  final int tripDays;

  double get currentProgress => maxDays > 0 ? (currentDays / maxDays).clamp(0.0, 1.0) : 0.0;
  double get futureProgress => maxDays > 0 ? (futureDays / maxDays).clamp(0.0, 1.0) : 0.0;
  bool get isCurrentlyResident => currentDays >= 183;
  bool get willBeResident => futureDays >= 183;
  int get daysChange => futureDays - currentDays;

  String get statusText {
    if (isCurrentlyResident && willBeResident) {
      return "Resident";
    } else if (!isCurrentlyResident && !willBeResident) {
      final daysLeft = 183 - futureDays;
      return "$daysLeft days left to residency";
    } else if (!isCurrentlyResident && willBeResident) {
      return "Will become Resident";
    } else {
      final daysLeft = futureDays - 183;
      return "$daysLeft days over limit";
    }
  }
}
