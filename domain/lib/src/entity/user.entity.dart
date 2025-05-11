import "package:domain/domain.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "user.entity.g.dart";
part "user.entity.freezed.dart";

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required DateTime createdAt,
    required List<StayPeriodValueObject> stayPeriods,
    required bool isBiometricsEnabled,
    @Default("") String focusedCountryCode,
  }) = _UserEntity;

  const UserEntity._();

  factory UserEntity.fromJson(Map<String, dynamic> json) => _$UserEntityFromJson(json);

  Map<String, List<StayPeriodValueObject>> get countries => stayPeriods.fold<Map<String, List<StayPeriodValueObject>>>(
        {},
        (acc, period) {
          acc.putIfAbsent(period.countryCode, () => []);
          acc[period.countryCode]!.add(period);
          return acc;
        },
      );

  List<String> get countryCodes => countries.keys.toList();

  int daysSpentIn(String countryCode) {
    final twelveMonthsAgo = DateTime.now().subtract(const Duration(days: 365));
    final periods = countries[countryCode] ?? [];

    return periods.fold(0, (sum, period) {
      // Skip periods that end before our 12-month window
      if (period.endDate.isBefore(twelveMonthsAgo)) {
        return sum;
      }

      // Adjust start date if it falls before our 12-month window
      final effectiveStart = period.startDate.isBefore(twelveMonthsAgo) ? twelveMonthsAgo : period.startDate;

      return sum + period.endDate.difference(effectiveStart).inDays;
    });
  }

  bool isResidentIn(String countryCode) {
    return daysSpentIn(countryCode) >= 183;
  }

  int statusToggleIn(String countryCode) {
    return (183 - daysSpentIn(countryCode)).abs();
  }

  DateTime statusToggleAt(String countryCode) {
    return DateTime.now().add(Duration(days: statusToggleIn(countryCode)));
  }

  int extraDays(String countryCode) {
    return isResidentIn(countryCode) ? statusToggleIn(countryCode) : 0;
  }

  bool isHere(String countryCode) {
    return stayPeriods.last.countryCode == countryCode;
  }
}
