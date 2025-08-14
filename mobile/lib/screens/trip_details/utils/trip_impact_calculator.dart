import "package:domain/domain.dart";

class TripImpactData {
  const TripImpactData({
    required this.countryCode,
    required this.currentDays,
    required this.futureDays,
    required this.isCurrentTrip,
    required this.statusWillChange,
  });

  final String countryCode;
  final int currentDays; // Days before this trip (including all previous trips)
  final int futureDays; // Days after this trip
  final bool isCurrentTrip; // Is this the target trip country
  final bool statusWillChange; // Will residency status change

  bool get isCurrentlyResident => currentDays >= 183;
  bool get willBeResident => futureDays >= 183;
  int get daysChange => futureDays - currentDays;

  String get statusText {
    if (isCurrentlyResident && willBeResident) {
      return "Resident"; // Stays resident
    } else if (!isCurrentlyResident && !willBeResident) {
      return "Non-Resident"; // Stays non-resident
    } else if (!isCurrentlyResident && willBeResident) {
      return "Will become Resident"; // Becomes resident
    } else {
      return "Will lose Residency"; // Loses residency (unlikely but possible)
    }
  }

  String get daysText {
    final currentLeft = 183 - currentDays;
    final futureLeft = 183 - futureDays;

    if (isCurrentlyResident && willBeResident) {
      return "$currentDays → $futureDays days";
    } else if (!isCurrentlyResident && !willBeResident) {
      return "$currentLeft → $futureLeft days left";
    } else if (!isCurrentlyResident && willBeResident) {
      return "$currentLeft days left → Resident";
    } else {
      return "Resident → $futureLeft days left";
    }
  }
}

class TripImpactCalculator {
  static List<TripImpactData> calculateTripImpact(
    UserEntity user,
    List<TripEntity> allTrips,
    TripEntity targetTrip,
  ) {
    final results = <TripImpactData>[];

    // Get all countries user has been to
    final allCountries = <String>{};
    allCountries.addAll(user.countries.keys);
    allCountries.add(targetTrip.countryCode);

    // Sort all trips by date (including target trip)
    final sortedTrips = [...allTrips, targetTrip]..sort((a, b) => a.fromDate.compareTo(b.fromDate));

    // Find target trip index
    final targetTripIndex = sortedTrips.indexWhere(
      (trip) =>
          trip.id == targetTrip.id &&
          trip.fromDate == targetTrip.fromDate &&
          trip.toDate == targetTrip.toDate,
    );

    if (targetTripIndex == -1) return results;

    // Calculate impact for each country
    for (final countryCode in allCountries) {
      final currentDays = _calculateDaysUpToTrip(user, sortedTrips, targetTripIndex, countryCode);
      final futureDays = _calculateDaysAfterTrip(user, sortedTrips, targetTripIndex, countryCode);

      final isCurrentTrip = countryCode == targetTrip.countryCode;
      final statusWillChange = (currentDays < 183) != (futureDays < 183);

      // Only show countries where user has spent time or will spend time
      if (currentDays > 0 || futureDays > 0) {
        results.add(
          TripImpactData(
            countryCode: countryCode,
            currentDays: currentDays,
            futureDays: futureDays,
            isCurrentTrip: isCurrentTrip,
            statusWillChange: statusWillChange,
          ),
        );
      }
    }

    // Sort: current trip first, then by future days descending
    results.sort((a, b) {
      if (a.isCurrentTrip && !b.isCurrentTrip) return -1;
      if (!a.isCurrentTrip && b.isCurrentTrip) return 1;
      return b.futureDays.compareTo(a.futureDays);
    });

    return results;
  }

  static int _calculateDaysUpToTrip(
    UserEntity user,
    List<TripEntity> sortedTrips,
    int targetTripIndex,
    String countryCode,
  ) {
    // Start with current user days in country
    var totalDays = user.daysSpentIn(countryCode);

    // Add days from all trips BEFORE target trip
    for (var i = 0; i < targetTripIndex; i++) {
      final trip = sortedTrips[i];
      if (trip.countryCode == countryCode) {
        totalDays += trip.days;
      }
    }

    return totalDays;
  }

  static int _calculateDaysAfterTrip(
    UserEntity user,
    List<TripEntity> sortedTrips,
    int targetTripIndex,
    String countryCode,
  ) {
    // Start with days up to target trip
    var totalDays = _calculateDaysUpToTrip(user, sortedTrips, targetTripIndex, countryCode);

    // Add days from target trip
    final targetTrip = sortedTrips[targetTripIndex];
    if (targetTrip.countryCode == countryCode) {
      totalDays += targetTrip.days;
    }

    return totalDays;
  }
}
