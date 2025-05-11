import "package:freezed_annotation/freezed_annotation.dart";

part "stay_period.g.dart";
part "stay_period.freezed.dart";

@freezed
class StayPeriodValueObject with _$StayPeriodValueObject {
  const factory StayPeriodValueObject({
    required DateTime startDate,
    required DateTime endDate,
    required String countryCode,
  }) = _StayPeriodValueObject;
  const StayPeriodValueObject._();

  factory StayPeriodValueObject.fromJson(Map<String, dynamic> json) => _$StayPeriodValueObjectFromJson(json);

  int get days => endDate.difference(startDate).inDays;
}
