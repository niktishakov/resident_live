// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stay_period.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StayPeriod _$StayPeriodFromJson(Map<String, dynamic> json) {
  return _StayPeriod.fromJson(json);
}

/// @nodoc
mixin _$StayPeriod {
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;

  /// Serializes this StayPeriod to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StayPeriod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StayPeriodCopyWith<StayPeriod> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StayPeriodCopyWith<$Res> {
  factory $StayPeriodCopyWith(
          StayPeriod value, $Res Function(StayPeriod) then) =
      _$StayPeriodCopyWithImpl<$Res, StayPeriod>;
  @useResult
  $Res call({DateTime startDate, DateTime endDate, String country});
}

/// @nodoc
class _$StayPeriodCopyWithImpl<$Res, $Val extends StayPeriod>
    implements $StayPeriodCopyWith<$Res> {
  _$StayPeriodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StayPeriod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? country = null,
  }) {
    return _then(_value.copyWith(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StayPeriodImplCopyWith<$Res>
    implements $StayPeriodCopyWith<$Res> {
  factory _$$StayPeriodImplCopyWith(
          _$StayPeriodImpl value, $Res Function(_$StayPeriodImpl) then) =
      __$$StayPeriodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime startDate, DateTime endDate, String country});
}

/// @nodoc
class __$$StayPeriodImplCopyWithImpl<$Res>
    extends _$StayPeriodCopyWithImpl<$Res, _$StayPeriodImpl>
    implements _$$StayPeriodImplCopyWith<$Res> {
  __$$StayPeriodImplCopyWithImpl(
      _$StayPeriodImpl _value, $Res Function(_$StayPeriodImpl) _then)
      : super(_value, _then);

  /// Create a copy of StayPeriod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? country = null,
  }) {
    return _then(_$StayPeriodImpl(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StayPeriodImpl extends _StayPeriod {
  const _$StayPeriodImpl(
      {required this.startDate, required this.endDate, required this.country})
      : super._();

  factory _$StayPeriodImpl.fromJson(Map<String, dynamic> json) =>
      _$$StayPeriodImplFromJson(json);

  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final String country;

  @override
  String toString() {
    return 'StayPeriod(startDate: $startDate, endDate: $endDate, country: $country)';
  }

  /// Create a copy of StayPeriod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StayPeriodImplCopyWith<_$StayPeriodImpl> get copyWith =>
      __$$StayPeriodImplCopyWithImpl<_$StayPeriodImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StayPeriodImplToJson(
      this,
    );
  }
}

abstract class _StayPeriod extends StayPeriod {
  const factory _StayPeriod(
      {required final DateTime startDate,
      required final DateTime endDate,
      required final String country}) = _$StayPeriodImpl;
  const _StayPeriod._() : super._();

  factory _StayPeriod.fromJson(Map<String, dynamic> json) =
      _$StayPeriodImpl.fromJson;

  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  String get country;

  /// Create a copy of StayPeriod
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StayPeriodImplCopyWith<_$StayPeriodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
