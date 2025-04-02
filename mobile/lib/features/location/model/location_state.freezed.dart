// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LocationState _$LocationStateFromJson(Map<String, dynamic> json) {
  return _LocationState.fromJson(json);
}

/// @nodoc
mixin _$LocationState {
  @JsonKey(includeFromJson: false, includeToJson: false)
  Position? get position => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Placemark? get placemark => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isInitialized => throw _privateConstructorUsedError;
  String get error => throw _privateConstructorUsedError;

  /// Serializes this LocationState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationStateCopyWith<LocationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationStateCopyWith<$Res> {
  factory $LocationStateCopyWith(
          LocationState value, $Res Function(LocationState) then) =
      _$LocationStateCopyWithImpl<$Res, LocationState>;
  @useResult
  $Res call(
      {@JsonKey(includeFromJson: false, includeToJson: false)
      Position? position,
      @JsonKey(includeFromJson: false, includeToJson: false)
      Placemark? placemark,
      @JsonKey(includeFromJson: false, includeToJson: false) bool isInitialized,
      String error});
}

/// @nodoc
class _$LocationStateCopyWithImpl<$Res, $Val extends LocationState>
    implements $LocationStateCopyWith<$Res> {
  _$LocationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = freezed,
    Object? placemark = freezed,
    Object? isInitialized = null,
    Object? error = null,
  }) {
    return _then(_value.copyWith(
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Position?,
      placemark: freezed == placemark
          ? _value.placemark
          : placemark // ignore: cast_nullable_to_non_nullable
              as Placemark?,
      isInitialized: null == isInitialized
          ? _value.isInitialized
          : isInitialized // ignore: cast_nullable_to_non_nullable
              as bool,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationStateImplCopyWith<$Res>
    implements $LocationStateCopyWith<$Res> {
  factory _$$LocationStateImplCopyWith(
          _$LocationStateImpl value, $Res Function(_$LocationStateImpl) then) =
      __$$LocationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(includeFromJson: false, includeToJson: false)
      Position? position,
      @JsonKey(includeFromJson: false, includeToJson: false)
      Placemark? placemark,
      @JsonKey(includeFromJson: false, includeToJson: false) bool isInitialized,
      String error});
}

/// @nodoc
class __$$LocationStateImplCopyWithImpl<$Res>
    extends _$LocationStateCopyWithImpl<$Res, _$LocationStateImpl>
    implements _$$LocationStateImplCopyWith<$Res> {
  __$$LocationStateImplCopyWithImpl(
      _$LocationStateImpl _value, $Res Function(_$LocationStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = freezed,
    Object? placemark = freezed,
    Object? isInitialized = null,
    Object? error = null,
  }) {
    return _then(_$LocationStateImpl(
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Position?,
      placemark: freezed == placemark
          ? _value.placemark
          : placemark // ignore: cast_nullable_to_non_nullable
              as Placemark?,
      isInitialized: null == isInitialized
          ? _value.isInitialized
          : isInitialized // ignore: cast_nullable_to_non_nullable
              as bool,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationStateImpl extends _LocationState {
  const _$LocationStateImpl(
      {@JsonKey(includeFromJson: false, includeToJson: false) this.position,
      @JsonKey(includeFromJson: false, includeToJson: false) this.placemark,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.isInitialized = false,
      this.error = ''})
      : super._();

  factory _$LocationStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationStateImplFromJson(json);

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Position? position;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Placemark? placemark;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isInitialized;
  @override
  @JsonKey()
  final String error;

  @override
  String toString() {
    return 'LocationState(position: $position, placemark: $placemark, isInitialized: $isInitialized, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationStateImpl &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.placemark, placemark) ||
                other.placemark == placemark) &&
            (identical(other.isInitialized, isInitialized) ||
                other.isInitialized == isInitialized) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, position, placemark, isInitialized, error);

  /// Create a copy of LocationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationStateImplCopyWith<_$LocationStateImpl> get copyWith =>
      __$$LocationStateImplCopyWithImpl<_$LocationStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationStateImplToJson(
      this,
    );
  }
}

abstract class _LocationState extends LocationState {
  const factory _LocationState(
      {@JsonKey(includeFromJson: false, includeToJson: false)
      final Position? position,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final Placemark? placemark,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final bool isInitialized,
      final String error}) = _$LocationStateImpl;
  const _LocationState._() : super._();

  factory _LocationState.fromJson(Map<String, dynamic> json) =
      _$LocationStateImpl.fromJson;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  Position? get position;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  Placemark? get placemark;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isInitialized;
  @override
  String get error;

  /// Create a copy of LocationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationStateImplCopyWith<_$LocationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
