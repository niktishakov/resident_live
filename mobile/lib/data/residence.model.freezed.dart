// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'residence.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ResidenceModel _$ResidenceModelFromJson(Map<String, dynamic> json) {
  return _ResidenceModel.fromJson(json);
}

/// @nodoc
mixin _$ResidenceModel {
  String get isoCountryCode => throw _privateConstructorUsedError;
  String get countryName => throw _privateConstructorUsedError;
  int get daysSpent => throw _privateConstructorUsedError;
  List<ActivitySegment> get periods => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResidenceModelCopyWith<ResidenceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResidenceModelCopyWith<$Res> {
  factory $ResidenceModelCopyWith(
          ResidenceModel value, $Res Function(ResidenceModel) then) =
      _$ResidenceModelCopyWithImpl<$Res, ResidenceModel>;
  @useResult
  $Res call(
      {String isoCountryCode,
      String countryName,
      int daysSpent,
      List<ActivitySegment> periods});
}

/// @nodoc
class _$ResidenceModelCopyWithImpl<$Res, $Val extends ResidenceModel>
    implements $ResidenceModelCopyWith<$Res> {
  _$ResidenceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isoCountryCode = null,
    Object? countryName = null,
    Object? daysSpent = null,
    Object? periods = null,
  }) {
    return _then(_value.copyWith(
      isoCountryCode: null == isoCountryCode
          ? _value.isoCountryCode
          : isoCountryCode // ignore: cast_nullable_to_non_nullable
              as String,
      countryName: null == countryName
          ? _value.countryName
          : countryName // ignore: cast_nullable_to_non_nullable
              as String,
      daysSpent: null == daysSpent
          ? _value.daysSpent
          : daysSpent // ignore: cast_nullable_to_non_nullable
              as int,
      periods: null == periods
          ? _value.periods
          : periods // ignore: cast_nullable_to_non_nullable
              as List<ActivitySegment>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResidenceModelImplCopyWith<$Res>
    implements $ResidenceModelCopyWith<$Res> {
  factory _$$ResidenceModelImplCopyWith(_$ResidenceModelImpl value,
          $Res Function(_$ResidenceModelImpl) then) =
      __$$ResidenceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String isoCountryCode,
      String countryName,
      int daysSpent,
      List<ActivitySegment> periods});
}

/// @nodoc
class __$$ResidenceModelImplCopyWithImpl<$Res>
    extends _$ResidenceModelCopyWithImpl<$Res, _$ResidenceModelImpl>
    implements _$$ResidenceModelImplCopyWith<$Res> {
  __$$ResidenceModelImplCopyWithImpl(
      _$ResidenceModelImpl _value, $Res Function(_$ResidenceModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isoCountryCode = null,
    Object? countryName = null,
    Object? daysSpent = null,
    Object? periods = null,
  }) {
    return _then(_$ResidenceModelImpl(
      isoCountryCode: null == isoCountryCode
          ? _value.isoCountryCode
          : isoCountryCode // ignore: cast_nullable_to_non_nullable
              as String,
      countryName: null == countryName
          ? _value.countryName
          : countryName // ignore: cast_nullable_to_non_nullable
              as String,
      daysSpent: null == daysSpent
          ? _value.daysSpent
          : daysSpent // ignore: cast_nullable_to_non_nullable
              as int,
      periods: null == periods
          ? _value._periods
          : periods // ignore: cast_nullable_to_non_nullable
              as List<ActivitySegment>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResidenceModelImpl extends _ResidenceModel {
  const _$ResidenceModelImpl(
      {required this.isoCountryCode,
      required this.countryName,
      required this.daysSpent,
      required final List<ActivitySegment> periods})
      : _periods = periods,
        super._();

  factory _$ResidenceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResidenceModelImplFromJson(json);

  @override
  final String isoCountryCode;
  @override
  final String countryName;
  @override
  final int daysSpent;
  final List<ActivitySegment> _periods;
  @override
  List<ActivitySegment> get periods {
    if (_periods is EqualUnmodifiableListView) return _periods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_periods);
  }

  @override
  String toString() {
    return 'ResidenceModel(isoCountryCode: $isoCountryCode, countryName: $countryName, daysSpent: $daysSpent, periods: $periods)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResidenceModelImpl &&
            (identical(other.isoCountryCode, isoCountryCode) ||
                other.isoCountryCode == isoCountryCode) &&
            (identical(other.countryName, countryName) ||
                other.countryName == countryName) &&
            (identical(other.daysSpent, daysSpent) ||
                other.daysSpent == daysSpent) &&
            const DeepCollectionEquality().equals(other._periods, _periods));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, isoCountryCode, countryName,
      daysSpent, const DeepCollectionEquality().hash(_periods));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResidenceModelImplCopyWith<_$ResidenceModelImpl> get copyWith =>
      __$$ResidenceModelImplCopyWithImpl<_$ResidenceModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResidenceModelImplToJson(
      this,
    );
  }
}

abstract class _ResidenceModel extends ResidenceModel {
  const factory _ResidenceModel(
      {required final String isoCountryCode,
      required final String countryName,
      required final int daysSpent,
      required final List<ActivitySegment> periods}) = _$ResidenceModelImpl;
  const _ResidenceModel._() : super._();

  factory _ResidenceModel.fromJson(Map<String, dynamic> json) =
      _$ResidenceModelImpl.fromJson;

  @override
  String get isoCountryCode;
  @override
  String get countryName;
  @override
  int get daysSpent;
  @override
  List<ActivitySegment> get periods;
  @override
  @JsonKey(ignore: true)
  _$$ResidenceModelImplCopyWith<_$ResidenceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
