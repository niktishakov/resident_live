import "package:flutter/material.dart";

class StayLimitData {
  const StayLimitData({
    required this.countryCode,
    required this.usedDays,
    required this.maxDays,
    required this.color,
    this.tripDays = 0,
  });

  static const int _maxDays = 183; //

  final String countryCode;
  final int usedDays;
  final int maxDays;
  final Color color;
  final int tripDays;

  int get futureDays => (usedDays - tripDays).clamp(0, _maxDays);
  double get currentProgress => maxDays > 0 ? usedDays / _maxDays : 0.0;
  double get futureProgress => maxDays > 0 ? futureDays / _maxDays : 0.0;
  bool get isWarning => futureProgress > 0.8;
  bool get hasTrip => tripDays > 0;
}
