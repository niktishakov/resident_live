import "package:domain/domain.dart";
import "package:resident_live/screens/trips/model/trip_model.dart";
import "package:resident_live/screens/validate_trip/widget/stay_limit/country_helper.dart";
import "package:resident_live/screens/validate_trip/widget/stay_limit/stay_limit_data.dart";
import "package:resident_live/shared/shared.dart";

class StayLimitsCalculator {
  static List<StayLimitData> calculateRealStayLimits(
    UserEntity user,
    TripModel trip,
    RlTheme theme,
    List<TripEntity> allTrips,
  ) {
    final countries = user.countries;
    final limits = <StayLimitData>[];
    final focusedCountryCode = user.focusedCountryCode;
    final today = DateTime.now();

    // Calculate projected stay periods including:
    // 1. Historical data (last 12 months)
    // 2. Current location until trip start
    // 3. Scheduled trips between today and analyzed trip
    // 4. The analyzed trip itself

    // Get all countries that will be affected
    final affectedCountries = <String>{};
    affectedCountries.addAll(countries.keys);
    affectedCountries.add(user.currentCountryCode());
    // affectedCountries.add(trip.countryCode); // TODO: maybe add trip to the list in the future
    for (final scheduledTrip in allTrips) {
      if (scheduledTrip.fromDate.isAfter(today) && scheduledTrip.fromDate.isBefore(trip.fromDate)) {
        affectedCountries.add(scheduledTrip.countryCode);
      }
    }

    // Calculate projected days for each affected country
    for (final countryCode in affectedCountries) {
      final projectedDays = _calculateProjectedDaysForCountry(
        countryCode,
        user,
        trip,
        allTrips,
        today,
      );

      final maxDays = CountryHelper.getCountryMaxDays(countryCode);

      // Only show countries where user has spent time or will spend time
      if (projectedDays > 0) {
        limits.add(
          StayLimitData(
            countryCode: countryCode,
            usedDays: projectedDays,
            maxDays: maxDays,
            color: projectedDays > maxDays * 0.8 ? theme.bgDanger : theme.textAccent,
            tripDays: trip.days,
            destinationCountryCode: trip.countryCode,
          ),
        );
      }
    }

    // Sort with focused country first, then by most projected days
    limits.sort((a, b) {
      final aCountryCode = CountryHelper.getCountryCodeByName(a.countryCode);
      final bCountryCode = CountryHelper.getCountryCodeByName(b.countryCode);

      if (aCountryCode == focusedCountryCode && bCountryCode != focusedCountryCode) {
        return -1; // a comes first
      } else if (bCountryCode == focusedCountryCode && aCountryCode != focusedCountryCode) {
        return 1; // b comes first
      } else {
        // Both are focused or neither is focused, sort by projected days
        return b.usedDays.compareTo(a.usedDays);
      }
    });

    return limits;
  }

  static int _calculateProjectedDaysForCountry(
    String countryCode,
    UserEntity user,
    TripModel trip,
    List<TripEntity> allTrips,
    DateTime today,
  ) {
    // Calculate days within a 12-month rolling window from today
    final twelveMonthsFromToday = today.add(const Duration(days: 365));
    final calculationEndDate = trip.toDate.isAfter(twelveMonthsFromToday)
        ? twelveMonthsFromToday
        : trip.toDate;

    // Start with historical data from last 12 months
    // This should already be capped at 365 days from user.daysSpentIn()
    var totalDays = user.daysSpentIn(countryCode);

    // Calculate how many historical days will "roll out" during the period
    today.subtract(const Duration(days: 365));
    final periodStart = trip.fromDate.isAfter(today) ? today : trip.fromDate;
    final periodEnd = calculationEndDate;

    // For each day in the period, historical data will shift
    final periodDays = periodEnd.difference(periodStart).inDays;

    // Estimate how many historical days will roll out
    // This is a simplified calculation - in reality we'd need exact historical data
    final historicalDaysToRemove = (periodDays * totalDays / 365).round();
    totalDays = (totalDays - historicalDaysToRemove).clamp(0, 365);

    // Add days from current location until trip start
    final currentCountry = user.currentCountryCode();
    if (currentCountry == countryCode && trip.fromDate.isAfter(today)) {
      final daysUntilTrip = trip.fromDate.difference(today).inDays;
      totalDays += daysUntilTrip;
    }

    // Add days from scheduled trips between today and analyzed trip
    for (final scheduledTrip in allTrips) {
      if (scheduledTrip.countryCode == countryCode &&
          scheduledTrip.fromDate.isAfter(today) &&
          scheduledTrip.fromDate.isBefore(trip.fromDate)) {
        final effectiveEndDate = scheduledTrip.toDate.isAfter(calculationEndDate)
            ? calculationEndDate
            : scheduledTrip.toDate;

        final tripDays = effectiveEndDate.difference(scheduledTrip.fromDate).inDays + 1;
        if (tripDays > 0) {
          totalDays += tripDays;
        }
      }
    }

    // Add days from the analyzed trip itself
    if (trip.countryCode == countryCode) {
      final effectiveEndDate = trip.toDate.isAfter(calculationEndDate)
          ? calculationEndDate
          : trip.toDate;

      if (effectiveEndDate.isAfter(trip.fromDate)) {
        final tripDays = effectiveEndDate.difference(trip.fromDate).inDays + 1;
        if (tripDays > 0) {
          totalDays += tripDays;
        }
      }
    }

    // Ensure we never exceed 365 days (12 months)
    return totalDays.clamp(0, 365);
  }
}
