// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'countries_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CountriesStateImpl _$$CountriesStateImplFromJson(Map<String, dynamic> json) =>
    _$CountriesStateImpl(
      countries: (json['countries'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, CountryEntity.fromJson(e as Map<String, dynamic>)),
      ),
      focusedCountryId: json['focusedCountryId'] as String?,
    );

Map<String, dynamic> _$$CountriesStateImplToJson(
        _$CountriesStateImpl instance) =>
    <String, dynamic>{
      'countries': instance.countries,
      'focusedCountryId': instance.focusedCountryId,
    };
