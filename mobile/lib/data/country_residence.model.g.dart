// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_residence.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CountryResidenceModelImpl _$$CountryResidenceModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CountryResidenceModelImpl(
      isoCountryCode: json['isoCountryCode'] as String,
      countryName: json['countryName'] as String,
      daysSpent: (json['daysSpent'] as num).toInt(),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      isResident: json['isResident'] as bool,
    );

Map<String, dynamic> _$$CountryResidenceModelImplToJson(
        _$CountryResidenceModelImpl instance) =>
    <String, dynamic>{
      'isoCountryCode': instance.isoCountryCode,
      'countryName': instance.countryName,
      'daysSpent': instance.daysSpent,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'isResident': instance.isResident,
    };
