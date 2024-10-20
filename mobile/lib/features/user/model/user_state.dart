import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'user_state.freezed.dart';
part 'user_state.g.dart';

@freezed
class UserState with _$UserState {
  const factory UserState({
    required List<UserEntity> users,
    required UserEntity focusedUser,
    @Default(false) bool isLoading,
    @Default(false) bool silent,
    @Default('') String error,
  }) = _UserState;

  factory UserState.initial() => UserState(
        isLoading: false,
        users: [UserEntity.mock()],
        focusedUser: UserEntity.mock(),
        error: '',
      );

  const UserState._();
  bool get isSuccess => error.isEmpty && isLoading == false;

  UserState success(List<UserEntity> users) =>
      copyWith(users: users, isLoading: false, silent: false, error: '');

  UserState loading({bool silent = false}) =>
      copyWith(isLoading: !silent, silent: silent, error: '');

  UserState failure(String error) =>
      copyWith(error: error, isLoading: false, silent: false);

  UserState reset() => copyWith(users: [], focusedUser: UserEntity.mock());

  factory UserState.fromJson(Map<String, dynamic> json) =>
      _$UserStateFromJson(json);
}
