import 'package:data/data.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserStorage {
  UserStorage(this._storage);
  final Box<UserHiveModel> _storage;

  Future<UserHiveModel> createUser(UserHiveModel user) async {
    await _storage.put(user.id, user);
    return user;
  }

  UserHiveModel? getUser(String id) {
    return _storage.get(id);
  }

  Future<void> updateUser(UserHiveModel user) {
    return _storage.put(user.id, user);
  }

  Future<void> deleteUser(String id) {
    return _storage.delete(id);
  }
}
