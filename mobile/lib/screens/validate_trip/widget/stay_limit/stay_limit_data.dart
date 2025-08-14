import "package:flutter/material.dart";

class StayLimitData {
  const StayLimitData({
    required this.countryCode,
    required this.usedDays,
    required this.maxDays,
    required this.color,
    this.tripDays = 0,
    this.destinationCountryCode,
  });

  final String countryCode;
  final int usedDays;
  final int maxDays;
  final Color color;
  final int tripDays;
  final String? destinationCountryCode;

  int get futureDays => destinationCountryCode != countryCode
      ? (usedDays - tripDays).clamp(0, usedDays)
      : usedDays + tripDays;
  double get currentProgress => maxDays > 0 ? usedDays / maxDays : 0.0;
  double get futureProgress => maxDays > 0 ? futureDays / maxDays : 0.0;
  bool get isWarning => usedDays > 183 && futureDays <= 183;
  bool get hasTrip => tripDays > 0 && destinationCountryCode == countryCode;
}
