// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'countries_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CountriesState _$CountriesStateFromJson(Map<String, dynamic> json) {
  return _CountriesState.fromJson(json);
}

/// @nodoc
mixin _$CountriesState {
  Map<String, CountryEntity> get countries =>
      throw _privateConstructorUsedError;
  CountryEntity? get focusedCountry => throw _privateConstructorUsedError;

  /// Serializes this CountriesState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CountriesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CountriesStateCopyWith<CountriesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CountriesStateCopyWith<$Res> {
  factory $CountriesStateCopyWith(
          CountriesState value, $Res Function(CountriesState) then) =
      _$CountriesStateCopyWithImpl<$Res, CountriesState>;
  @useResult
  $Res call(
      {Map<String, CountryEntity> countries, CountryEntity? focusedCountry});

  $CountryEntityCopyWith<$Res>? get focusedCountry;
}

/// @nodoc
class _$CountriesStateCopyWithImpl<$Res, $Val extends CountriesState>
    implements $CountriesStateCopyWith<$Res> {
  _$CountriesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CountriesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? countries = null,
    Object? focusedCountry = freezed,
  }) {
    return _then(_value.copyWith(
      countries: null == countries
          ? _value.countries
          : countries // ignore: cast_nullable_to_non_nullable
              as Map<String, CountryEntity>,
      focusedCountry: freezed == focusedCountry
          ? _value.focusedCountry
          : focusedCountry // ignore: cast_nullable_to_non_nullable
              as CountryEntity?,
    ) as $Val);
  }

  /// Create a copy of CountriesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CountryEntityCopyWith<$Res>? get focusedCountry {
    if (_value.focusedCountry == null) {
      return null;
    }

    return $CountryEntityCopyWith<$Res>(_value.focusedCountry!, (value) {
      return _then(_value.copyWith(focusedCountry: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CountriesStateImplCopyWith<$Res>
    implements $CountriesStateCopyWith<$Res> {
  factory _$$CountriesStateImplCopyWith(_$CountriesStateImpl value,
          $Res Function(_$CountriesStateImpl) then) =
      __$$CountriesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, CountryEntity> countries, CountryEntity? focusedCountry});

  @override
  $CountryEntityCopyWith<$Res>? get focusedCountry;
}

/// @nodoc
class __$$CountriesStateImplCopyWithImpl<$Res>
    extends _$CountriesStateCopyWithImpl<$Res, _$CountriesStateImpl>
    implements _$$CountriesStateImplCopyWith<$Res> {
  __$$CountriesStateImplCopyWithImpl(
      _$CountriesStateImpl _value, $Res Function(_$CountriesStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CountriesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? countries = null,
    Object? focusedCountry = freezed,
  }) {
    return _then(_$CountriesStateImpl(
      countries: null == countries
          ? _value._countries
          : countries // ignore: cast_nullable_to_non_nullable
              as Map<String, CountryEntity>,
      focusedCountry: freezed == focusedCountry
          ? _value.focusedCountry
          : focusedCountry // ignore: cast_nullable_to_non_nullable
              as CountryEntity?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CountriesStateImpl extends _CountriesState {
  const _$CountriesStateImpl(
      {required final Map<String, CountryEntity> countries,
      this.focusedCountry})
      : _countries = countries,
        super._();

  factory _$CountriesStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$CountriesStateImplFromJson(json);

  final Map<String, CountryEntity> _countries;
  @override
  Map<String, CountryEntity> get countries {
    if (_countries is EqualUnmodifiableMapView) return _countries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_countries);
  }

  @override
  final CountryEntity? focusedCountry;

  @override
  String toString() {
    return 'CountriesState(countries: $countries, focusedCountry: $focusedCountry)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CountriesStateImpl &&
            const DeepCollectionEquality()
                .equals(other._countries, _countries) &&
            (identical(other.focusedCountry, focusedCountry) ||
                other.focusedCountry == focusedCountry));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_countries), focusedCountry);

  /// Create a copy of CountriesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CountriesStateImplCopyWith<_$CountriesStateImpl> get copyWith =>
      __$$CountriesStateImplCopyWithImpl<_$CountriesStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CountriesStateImplToJson(
      this,
    );
  }
}

abstract class _CountriesState extends CountriesState {
  const factory _CountriesState(
      {required final Map<String, CountryEntity> countries,
      final CountryEntity? focusedCountry}) = _$CountriesStateImpl;
  const _CountriesState._() : super._();

  factory _CountriesState.fromJson(Map<String, dynamic> json) =
      _$CountriesStateImpl.fromJson;

  @override
  Map<String, CountryEntity> get countries;
  @override
  CountryEntity? get focusedCountry;

  /// Create a copy of CountriesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CountriesStateImplCopyWith<_$CountriesStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
