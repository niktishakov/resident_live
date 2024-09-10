// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_segment.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ActivitySegment _$ActivitySegmentFromJson(Map<String, dynamic> json) {
  return _ActivitySegment.fromJson(json);
}

/// @nodoc
mixin _$ActivitySegment {
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivitySegmentCopyWith<ActivitySegment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivitySegmentCopyWith<$Res> {
  factory $ActivitySegmentCopyWith(
          ActivitySegment value, $Res Function(ActivitySegment) then) =
      _$ActivitySegmentCopyWithImpl<$Res, ActivitySegment>;
  @useResult
  $Res call({DateTime startDate, DateTime endDate, String country});
}

/// @nodoc
class _$ActivitySegmentCopyWithImpl<$Res, $Val extends ActivitySegment>
    implements $ActivitySegmentCopyWith<$Res> {
  _$ActivitySegmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
abstract class _$$ActivitySegmentImplCopyWith<$Res>
    implements $ActivitySegmentCopyWith<$Res> {
  factory _$$ActivitySegmentImplCopyWith(_$ActivitySegmentImpl value,
          $Res Function(_$ActivitySegmentImpl) then) =
      __$$ActivitySegmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime startDate, DateTime endDate, String country});
}

/// @nodoc
class __$$ActivitySegmentImplCopyWithImpl<$Res>
    extends _$ActivitySegmentCopyWithImpl<$Res, _$ActivitySegmentImpl>
    implements _$$ActivitySegmentImplCopyWith<$Res> {
  __$$ActivitySegmentImplCopyWithImpl(
      _$ActivitySegmentImpl _value, $Res Function(_$ActivitySegmentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? country = null,
  }) {
    return _then(_$ActivitySegmentImpl(
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
class _$ActivitySegmentImpl extends _ActivitySegment {
  const _$ActivitySegmentImpl(
      {required this.startDate, required this.endDate, required this.country})
      : super._();

  factory _$ActivitySegmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivitySegmentImplFromJson(json);

  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final String country;

  @override
  String toString() {
    return 'ActivitySegment(startDate: $startDate, endDate: $endDate, country: $country)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivitySegmentImplCopyWith<_$ActivitySegmentImpl> get copyWith =>
      __$$ActivitySegmentImplCopyWithImpl<_$ActivitySegmentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivitySegmentImplToJson(
      this,
    );
  }
}

abstract class _ActivitySegment extends ActivitySegment {
  const factory _ActivitySegment(
      {required final DateTime startDate,
      required final DateTime endDate,
      required final String country}) = _$ActivitySegmentImpl;
  const _ActivitySegment._() : super._();

  factory _ActivitySegment.fromJson(Map<String, dynamic> json) =
      _$ActivitySegmentImpl.fromJson;

  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  String get country;
  @override
  @JsonKey(ignore: true)
  _$$ActivitySegmentImplCopyWith<_$ActivitySegmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
