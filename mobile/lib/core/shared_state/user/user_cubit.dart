import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:resident_live/data/data.dart';

import 'user_state.dart';

class UserCubit extends HydratedCubit<UserState> {
  UserCubit() : super(UserState.initial());

  void addUser(UserModel user) {
    emit(state.copyWith(users: [...state.users, user]));
  }

  void removeUser(String userId) {
    final users = [...state.users];
    users.removeWhere((user) => user.id == userId);

    emit(state.copyWith(users: users));
  }

  void updateUser(UserModel updatedUser) {
    final users = [...state.users];
    final index = users.indexWhere((user) => user.id == updatedUser.id);
    users[index] = updatedUser;
    emit(state.copyWith(users: users));
  }

  void focusUser(String userId) {
    final user = state.users.firstWhere((user) => user.id == userId);
    emit(state.copyWith(focusedUser: user));
  }

  @override
  UserState? fromJson(Map<String, dynamic> json) => UserState.fromJson(json);
  @override
  Map<String, dynamic>? toJson(UserState state) => state.toJson();
}
