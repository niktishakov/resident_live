// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthStateImpl _$$AuthStateImplFromJson(Map<String, dynamic> json) =>
    _$AuthStateImpl(
      isSupported: json['isSupported'] as bool? ?? false,
      isEnabled: json['isEnabled'] as bool? ?? false,
      biometricType:
          $enumDecodeNullable(_$BiometricTypeEnumMap, json['biometricType']) ??
              null,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$AuthStateImplToJson(_$AuthStateImpl instance) =>
    <String, dynamic>{
      'isSupported': instance.isSupported,
      'isEnabled': instance.isEnabled,
      'biometricType': _$BiometricTypeEnumMap[instance.biometricType],
      'error': instance.error,
    };

const _$BiometricTypeEnumMap = {
  BiometricType.face: 'face',
  BiometricType.fingerprint: 'fingerprint',
  BiometricType.iris: 'iris',
  BiometricType.strong: 'strong',
  BiometricType.weak: 'weak',
};
