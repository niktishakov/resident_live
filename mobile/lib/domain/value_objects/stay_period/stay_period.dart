import "package:freezed_annotation/freezed_annotation.dart";

part "stay_period.g.dart";
part "stay_period.freezed.dart";

@freezed
class StayPeriod with _$StayPeriod {
  const factory StayPeriod({
    required DateTime startDate,
    required DateTime endDate,
    required String country,
  }) = _StayPeriod;
  const StayPeriod._();

  factory StayPeriod.fromJson(Map<String, dynamic> json) =>
      _$StayPeriodFromJson(json);

  int getDays() {
    return endDate.difference(startDate).inDays + 1;
  }

  @override
  int get hashCode => Object.hash(startDate, endDate, country);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return super == other;
  }
}
