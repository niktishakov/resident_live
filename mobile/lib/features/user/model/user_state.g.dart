// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserStateImpl _$$UserStateImplFromJson(Map<String, dynamic> json) =>
    _$UserStateImpl(
      users: (json['users'] as List<dynamic>)
          .map((e) => UserEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      focusedUser:
          UserEntity.fromJson(json['focusedUser'] as Map<String, dynamic>),
      isLoading: json['isLoading'] as bool? ?? false,
      silent: json['silent'] as bool? ?? false,
      error: json['error'] as String? ?? '',
    );

Map<String, dynamic> _$$UserStateImplToJson(_$UserStateImpl instance) =>
    <String, dynamic>{
      'users': instance.users,
      'focusedUser': instance.focusedUser,
      'isLoading': instance.isLoading,
      'silent': instance.silent,
      'error': instance.error,
    };
