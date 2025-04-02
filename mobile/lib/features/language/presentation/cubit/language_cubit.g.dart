// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LanguageStateImpl _$$LanguageStateImplFromJson(Map<String, dynamic> json) =>
    _$LanguageStateImpl(
      localeKey: json['localeKey'] as String,
      status: $enumDecodeNullable(_$LanguageStatusEnumMap, json['status']) ??
          LanguageStatus.initial,
      errorMessage: json['errorMessage'] as String? ?? "",
    );

Map<String, dynamic> _$$LanguageStateImplToJson(_$LanguageStateImpl instance) =>
    <String, dynamic>{
      'localeKey': instance.localeKey,
      'status': _$LanguageStatusEnumMap[instance.status]!,
      'errorMessage': instance.errorMessage,
    };

const _$LanguageStatusEnumMap = {
  LanguageStatus.initial: 'initial',
  LanguageStatus.loading: 'loading',
  LanguageStatus.success: 'success',
  LanguageStatus.error: 'error',
};
