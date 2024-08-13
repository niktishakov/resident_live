// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'country_residence.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CountryResidenceModel _$CountryResidenceModelFromJson(
    Map<String, dynamic> json) {
  return _CountryResidenceModel.fromJson(json);
}

/// @nodoc
mixin _$CountryResidenceModel {
  String get isoCountryCode => throw _privateConstructorUsedError;
  String get countryName => throw _privateConstructorUsedError;
  int get daysSpent => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  bool get isResident => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CountryResidenceModelCopyWith<CountryResidenceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CountryResidenceModelCopyWith<$Res> {
  factory $CountryResidenceModelCopyWith(CountryResidenceModel value,
          $Res Function(CountryResidenceModel) then) =
      _$CountryResidenceModelCopyWithImpl<$Res, CountryResidenceModel>;
  @useResult
  $Res call(
      {String isoCountryCode,
      String countryName,
      int daysSpent,
      DateTime startDate,
      DateTime? endDate,
      bool isResident});
}

/// @nodoc
class _$CountryResidenceModelCopyWithImpl<$Res,
        $Val extends CountryResidenceModel>
    implements $CountryResidenceModelCopyWith<$Res> {
  _$CountryResidenceModelCopyWithImpl(this._value, this._then);

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
    Object? startDate = null,
    Object? endDate = freezed,
    Object? isResident = null,
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
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isResident: null == isResident
          ? _value.isResident
          : isResident // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CountryResidenceModelImplCopyWith<$Res>
    implements $CountryResidenceModelCopyWith<$Res> {
  factory _$$CountryResidenceModelImplCopyWith(
          _$CountryResidenceModelImpl value,
          $Res Function(_$CountryResidenceModelImpl) then) =
      __$$CountryResidenceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String isoCountryCode,
      String countryName,
      int daysSpent,
      DateTime startDate,
      DateTime? endDate,
      bool isResident});
}

/// @nodoc
class __$$CountryResidenceModelImplCopyWithImpl<$Res>
    extends _$CountryResidenceModelCopyWithImpl<$Res,
        _$CountryResidenceModelImpl>
    implements _$$CountryResidenceModelImplCopyWith<$Res> {
  __$$CountryResidenceModelImplCopyWithImpl(_$CountryResidenceModelImpl _value,
      $Res Function(_$CountryResidenceModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isoCountryCode = null,
    Object? countryName = null,
    Object? daysSpent = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? isResident = null,
  }) {
    return _then(_$CountryResidenceModelImpl(
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
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isResident: null == isResident
          ? _value.isResident
          : isResident // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CountryResidenceModelImpl implements _CountryResidenceModel {
  const _$CountryResidenceModelImpl(
      {required this.isoCountryCode,
      required this.countryName,
      required this.daysSpent,
      required this.startDate,
      this.endDate,
      required this.isResident});

  factory _$CountryResidenceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CountryResidenceModelImplFromJson(json);

  @override
  final String isoCountryCode;
  @override
  final String countryName;
  @override
  final int daysSpent;
  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;
  @override
  final bool isResident;

  @override
  String toString() {
    return 'CountryResidenceModel(isoCountryCode: $isoCountryCode, countryName: $countryName, daysSpent: $daysSpent, startDate: $startDate, endDate: $endDate, isResident: $isResident)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CountryResidenceModelImpl &&
            (identical(other.isoCountryCode, isoCountryCode) ||
                other.isoCountryCode == isoCountryCode) &&
            (identical(other.countryName, countryName) ||
                other.countryName == countryName) &&
            (identical(other.daysSpent, daysSpent) ||
                other.daysSpent == daysSpent) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isResident, isResident) ||
                other.isResident == isResident));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, isoCountryCode, countryName,
      daysSpent, startDate, endDate, isResident);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CountryResidenceModelImplCopyWith<_$CountryResidenceModelImpl>
      get copyWith => __$$CountryResidenceModelImplCopyWithImpl<
          _$CountryResidenceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CountryResidenceModelImplToJson(
      this,
    );
  }
}

abstract class _CountryResidenceModel implements CountryResidenceModel {
  const factory _CountryResidenceModel(
      {required final String isoCountryCode,
      required final String countryName,
      required final int daysSpent,
      required final DateTime startDate,
      final DateTime? endDate,
      required final bool isResident}) = _$CountryResidenceModelImpl;

  factory _CountryResidenceModel.fromJson(Map<String, dynamic> json) =
      _$CountryResidenceModelImpl.fromJson;

  @override
  String get isoCountryCode;
  @override
  String get countryName;
  @override
  int get daysSpent;
  @override
  DateTime get startDate;
  @override
  DateTime? get endDate;
  @override
  bool get isResident;
  @override
  @JsonKey(ignore: true)
  _$$CountryResidenceModelImplCopyWith<_$CountryResidenceModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
