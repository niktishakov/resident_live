import "package:data/src/model/local/user/user_model.dart";

import "package:hive/hive.dart";
import "package:injectable/injectable.dart";
import "package:local_auth/local_auth.dart";

@module
abstract class HiveModule {
  @preResolve
  @singleton
  Future<Box<UserHiveModel>> get userBox => Hive.openBox<UserHiveModel>("user_box");

  @singleton
  LocalAuthentication get localAuthentication => LocalAuthentication();
}
