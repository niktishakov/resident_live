// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bottom_bar_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BottomBarState _$BottomBarStateFromJson(Map<String, dynamic> json) {
  return _BottomBarState.fromJson(json);
}

/// @nodoc
mixin _$BottomBarState {
  bool get showBadge => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BottomBarStateCopyWith<BottomBarState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BottomBarStateCopyWith<$Res> {
  factory $BottomBarStateCopyWith(
          BottomBarState value, $Res Function(BottomBarState) then) =
      _$BottomBarStateCopyWithImpl<$Res, BottomBarState>;
  @useResult
  $Res call({bool showBadge});
}

/// @nodoc
class _$BottomBarStateCopyWithImpl<$Res, $Val extends BottomBarState>
    implements $BottomBarStateCopyWith<$Res> {
  _$BottomBarStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showBadge = null,
  }) {
    return _then(_value.copyWith(
      showBadge: null == showBadge
          ? _value.showBadge
          : showBadge // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BottomBarStateImplCopyWith<$Res>
    implements $BottomBarStateCopyWith<$Res> {
  factory _$$BottomBarStateImplCopyWith(_$BottomBarStateImpl value,
          $Res Function(_$BottomBarStateImpl) then) =
      __$$BottomBarStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool showBadge});
}

/// @nodoc
class __$$BottomBarStateImplCopyWithImpl<$Res>
    extends _$BottomBarStateCopyWithImpl<$Res, _$BottomBarStateImpl>
    implements _$$BottomBarStateImplCopyWith<$Res> {
  __$$BottomBarStateImplCopyWithImpl(
      _$BottomBarStateImpl _value, $Res Function(_$BottomBarStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showBadge = null,
  }) {
    return _then(_$BottomBarStateImpl(
      showBadge: null == showBadge
          ? _value.showBadge
          : showBadge // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BottomBarStateImpl implements _BottomBarState {
  const _$BottomBarStateImpl({required this.showBadge});

  factory _$BottomBarStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$BottomBarStateImplFromJson(json);

  @override
  final bool showBadge;

  @override
  String toString() {
    return 'BottomBarState(showBadge: $showBadge)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BottomBarStateImpl &&
            (identical(other.showBadge, showBadge) ||
                other.showBadge == showBadge));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, showBadge);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BottomBarStateImplCopyWith<_$BottomBarStateImpl> get copyWith =>
      __$$BottomBarStateImplCopyWithImpl<_$BottomBarStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BottomBarStateImplToJson(
      this,
    );
  }
}

abstract class _BottomBarState implements BottomBarState {
  const factory _BottomBarState({required final bool showBadge}) =
      _$BottomBarStateImpl;

  factory _BottomBarState.fromJson(Map<String, dynamic> json) =
      _$BottomBarStateImpl.fromJson;

  @override
  bool get showBadge;
  @override
  @JsonKey(ignore: true)
  _$$BottomBarStateImplCopyWith<_$BottomBarStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
