// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'country.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CountryEntity _$CountryEntityFromJson(Map<String, dynamic> json) {
  return _CountryEntity.fromJson(json);
}

/// @nodoc
mixin _$CountryEntity {
  String get isoCode => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<StayPeriod> get periods => throw _privateConstructorUsedError;

  /// Serializes this CountryEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CountryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CountryEntityCopyWith<CountryEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CountryEntityCopyWith<$Res> {
  factory $CountryEntityCopyWith(
          CountryEntity value, $Res Function(CountryEntity) then) =
      _$CountryEntityCopyWithImpl<$Res, CountryEntity>;
  @useResult
  $Res call({String isoCode, String name, List<StayPeriod> periods});
}

/// @nodoc
class _$CountryEntityCopyWithImpl<$Res, $Val extends CountryEntity>
    implements $CountryEntityCopyWith<$Res> {
  _$CountryEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CountryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isoCode = null,
    Object? name = null,
    Object? periods = null,
  }) {
    return _then(_value.copyWith(
      isoCode: null == isoCode
          ? _value.isoCode
          : isoCode // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      periods: null == periods
          ? _value.periods
          : periods // ignore: cast_nullable_to_non_nullable
              as List<StayPeriod>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CountryEntityImplCopyWith<$Res>
    implements $CountryEntityCopyWith<$Res> {
  factory _$$CountryEntityImplCopyWith(
          _$CountryEntityImpl value, $Res Function(_$CountryEntityImpl) then) =
      __$$CountryEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String isoCode, String name, List<StayPeriod> periods});
}

/// @nodoc
class __$$CountryEntityImplCopyWithImpl<$Res>
    extends _$CountryEntityCopyWithImpl<$Res, _$CountryEntityImpl>
    implements _$$CountryEntityImplCopyWith<$Res> {
  __$$CountryEntityImplCopyWithImpl(
      _$CountryEntityImpl _value, $Res Function(_$CountryEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of CountryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isoCode = null,
    Object? name = null,
    Object? periods = null,
  }) {
    return _then(_$CountryEntityImpl(
      isoCode: null == isoCode
          ? _value.isoCode
          : isoCode // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      periods: null == periods
          ? _value._periods
          : periods // ignore: cast_nullable_to_non_nullable
              as List<StayPeriod>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CountryEntityImpl extends _CountryEntity {
  const _$CountryEntityImpl(
      {required this.isoCode,
      required this.name,
      required final List<StayPeriod> periods})
      : _periods = periods,
        super._();

  factory _$CountryEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$CountryEntityImplFromJson(json);

  @override
  final String isoCode;
  @override
  final String name;
  final List<StayPeriod> _periods;
  @override
  List<StayPeriod> get periods {
    if (_periods is EqualUnmodifiableListView) return _periods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_periods);
  }

  @override
  String toString() {
    return 'CountryEntity(isoCode: $isoCode, name: $name, periods: $periods)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CountryEntityImpl &&
            (identical(other.isoCode, isoCode) || other.isoCode == isoCode) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._periods, _periods));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isoCode, name,
      const DeepCollectionEquality().hash(_periods));

  /// Create a copy of CountryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CountryEntityImplCopyWith<_$CountryEntityImpl> get copyWith =>
      __$$CountryEntityImplCopyWithImpl<_$CountryEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CountryEntityImplToJson(
      this,
    );
  }
}

abstract class _CountryEntity extends CountryEntity {
  const factory _CountryEntity(
      {required final String isoCode,
      required final String name,
      required final List<StayPeriod> periods}) = _$CountryEntityImpl;
  const _CountryEntity._() : super._();

  factory _CountryEntity.fromJson(Map<String, dynamic> json) =
      _$CountryEntityImpl.fromJson;

  @override
  String get isoCode;
  @override
  String get name;
  @override
  List<StayPeriod> get periods;

  /// Create a copy of CountryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CountryEntityImplCopyWith<_$CountryEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
