// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'residence.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ResidenceModelImpl _$$ResidenceModelImplFromJson(Map<String, dynamic> json) =>
    _$ResidenceModelImpl(
      isoCountryCode: json['isoCountryCode'] as String,
      countryName: json['countryName'] as String,
      daysSpent: (json['daysSpent'] as num).toInt(),
      periods: (json['periods'] as List<dynamic>)
          .map((e) => ActivitySegment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ResidenceModelImplToJson(
        _$ResidenceModelImpl instance) =>
    <String, dynamic>{
      'isoCountryCode': instance.isoCountryCode,
      'countryName': instance.countryName,
      'daysSpent': instance.daysSpent,
      'periods': instance.periods,
    };
