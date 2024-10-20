// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CountryEntityImpl _$$CountryEntityImplFromJson(Map<String, dynamic> json) =>
    _$CountryEntityImpl(
      isoCode: json['isoCode'] as String,
      name: json['name'] as String,
      periods: (json['periods'] as List<dynamic>)
          .map((e) => StayPeriod.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CountryEntityImplToJson(_$CountryEntityImpl instance) =>
    <String, dynamic>{
      'isoCode': instance.isoCode,
      'name': instance.name,
      'periods': instance.periods,
    };
