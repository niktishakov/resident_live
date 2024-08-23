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
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$$ResidenceModelImplToJson(
        _$ResidenceModelImpl instance) =>
    <String, dynamic>{
      'isoCountryCode': instance.isoCountryCode,
      'countryName': instance.countryName,
      'daysSpent': instance.daysSpent,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
    };
