import "package:injectable/injectable.dart";
import "package:shared_preferences/shared_preferences.dart";

abstract interface class ILanguageStorage {
  Future<void> saveLocale(String locale);
  String? getLocale();
  Future<void> clearAll();
}

@Injectable(as: ILanguageStorage)
class LanguageStorageImpl implements ILanguageStorage {
  LanguageStorageImpl(this._storage);
  final SharedPreferences _storage;

  static const String _key = "locale";

  @override
  Future<void> saveLocale(String locale) => _storage.setString(_key, locale);

  @override
  String? getLocale() => _storage.getString(_key);

  @override
  Future<void> clearAll() async {
    await _storage.clear();
  }
}
