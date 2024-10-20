import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain.dart';

part 'country.entity.g.dart';
part 'country.entity.freezed.dart';

@freezed
class CountryEntity with _$CountryEntity {
  const factory CountryEntity({
    required String isoCode,
    required String name,
    required List<StayPeriod> periods,
  }) = _CountryEntity;
  const CountryEntity._();

  factory CountryEntity.initial(String isoCode, String name) => _CountryEntity(
        isoCode: isoCode,
        name: name,
        periods: [],
      );

  factory CountryEntity.fromJson(Map<String, dynamic> json) =>
      _$CountryEntityFromJson(json);

  int get daysSpent {
    return periods.fold(0, (sum, period) {
      return sum + period.endDate.difference(period.startDate).inDays;
    });
  }

  bool get isResident => daysSpent >= 183;
  int get statusToggleIn => (183 - daysSpent).abs();
  DateTime get statusToggleAt =>
      DateTime.now().add(Duration(days: statusToggleIn));
  int get extraDays => isResident ? statusToggleIn : 0;
}
