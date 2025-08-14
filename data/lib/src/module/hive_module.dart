import "package:data/data.dart";

import "package:hive/hive.dart";
import "package:injectable/injectable.dart";
import "package:local_auth/local_auth.dart";

@module
abstract class HiveModule {
  @preResolve
  @singleton
  Future<Box<UserHiveModel>> get userBox => Hive.openBox<UserHiveModel>("user_box");

  @preResolve
  @singleton
  Future<Box<TripHiveModel>> get tripBox => Hive.openBox<TripHiveModel>("trip_box");

  @singleton
  LocalAuthentication get localAuthentication => LocalAuthentication();
}
