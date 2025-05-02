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
  String? get focusedCountryId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CountriesStateCopyWith<CountriesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CountriesStateCopyWith<$Res> {
  factory $CountriesStateCopyWith(
          CountriesState value, $Res Function(CountriesState) then) =
      _$CountriesStateCopyWithImpl<$Res, CountriesState>;
  @useResult
  $Res call({Map<String, CountryEntity> countries, String? focusedCountryId});
}

/// @nodoc
class _$CountriesStateCopyWithImpl<$Res, $Val extends CountriesState>
    implements $CountriesStateCopyWith<$Res> {
  _$CountriesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? countries = null,
    Object? focusedCountryId = freezed,
  }) {
    return _then(_value.copyWith(
      countries: null == countries
          ? _value.countries
          : countries // ignore: cast_nullable_to_non_nullable
              as Map<String, CountryEntity>,
      focusedCountryId: freezed == focusedCountryId
          ? _value.focusedCountryId
          : focusedCountryId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
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
  $Res call({Map<String, CountryEntity> countries, String? focusedCountryId});
}

/// @nodoc
class __$$CountriesStateImplCopyWithImpl<$Res>
    extends _$CountriesStateCopyWithImpl<$Res, _$CountriesStateImpl>
    implements _$$CountriesStateImplCopyWith<$Res> {
  __$$CountriesStateImplCopyWithImpl(
      _$CountriesStateImpl _value, $Res Function(_$CountriesStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? countries = null,
    Object? focusedCountryId = freezed,
  }) {
    return _then(_$CountriesStateImpl(
      countries: null == countries
          ? _value._countries
          : countries // ignore: cast_nullable_to_non_nullable
              as Map<String, CountryEntity>,
      focusedCountryId: freezed == focusedCountryId
          ? _value.focusedCountryId
          : focusedCountryId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CountriesStateImpl extends _CountriesState {
  const _$CountriesStateImpl(
      {required final Map<String, CountryEntity> countries,
      this.focusedCountryId})
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
  final String? focusedCountryId;

  @override
  String toString() {
    return 'CountriesState(countries: $countries, focusedCountryId: $focusedCountryId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CountriesStateImpl &&
            const DeepCollectionEquality()
                .equals(other._countries, _countries) &&
            (identical(other.focusedCountryId, focusedCountryId) ||
                other.focusedCountryId == focusedCountryId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_countries), focusedCountryId);

  @JsonKey(ignore: true)
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
      final String? focusedCountryId}) = _$CountriesStateImpl;
  const _CountriesState._() : super._();

  factory _CountriesState.fromJson(Map<String, dynamic> json) =
      _$CountriesStateImpl.fromJson;

  @override
  Map<String, CountryEntity> get countries;
  @override
  String? get focusedCountryId;
  @override
  @JsonKey(ignore: true)
  _$$CountriesStateImplCopyWith<_$CountriesStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
