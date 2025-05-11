import "package:domain/domain.dart";

class CountryStayInfo {
  CountryStayInfo({
    required this.totalDays,
    required this.segments,
  });
  final int totalDays;
  final List<StayPeriodValueObject> segments;
}
