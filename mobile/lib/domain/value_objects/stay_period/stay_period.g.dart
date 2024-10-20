// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stay_period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StayPeriodImpl _$$StayPeriodImplFromJson(Map<String, dynamic> json) =>
    _$StayPeriodImpl(
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      country: json['country'] as String,
    );

Map<String, dynamic> _$$StayPeriodImplToJson(_$StayPeriodImpl instance) =>
    <String, dynamic>{
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'country': instance.country,
    };
