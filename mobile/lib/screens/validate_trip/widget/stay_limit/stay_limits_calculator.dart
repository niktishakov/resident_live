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
  ) {
    final countries = user.countries;
    final limits = <StayLimitData>[];
    final focusedCountryCode = user.focusedCountryCode;

    // Calculate stay limits for each country user has been to
    for (final entry in countries.entries) {
      final countryCode = entry.key;
      final daysSpent = user.daysSpentIn(countryCode);
      final maxDays = CountryHelper.getCountryMaxDays(countryCode);

      // Only show countries where user has spent time or has upcoming trip
      if (daysSpent > 0 || countryCode == trip.countryCode) {
        limits.add(
          StayLimitData(
            countryCode: countryCode,
            usedDays: daysSpent,
            maxDays: maxDays,
            color: daysSpent > maxDays * 0.8 ? theme.bgDanger : theme.textAccent,
            tripDays: trip.days,
          ),
        );
      }
    }

    // Sort with focused country first, then by most used days
    limits.sort((a, b) {
      // Check if either country is the focused country
      final aCountryCode = CountryHelper.getCountryCodeByName(a.countryCode);
      final bCountryCode = CountryHelper.getCountryCodeByName(b.countryCode);

      if (aCountryCode == focusedCountryCode && bCountryCode != focusedCountryCode) {
        return -1; // a comes first
      } else if (bCountryCode == focusedCountryCode && aCountryCode != focusedCountryCode) {
        return 1; // b comes first
      } else {
        // Both are focused or neither is focused, sort by used days
        return b.usedDays.compareTo(a.usedDays);
      }
    });

    return limits;
  }
}
