import "package:data/src/data_source/storage/language_storage.dart";
import "package:domain/domain.dart";
import "package:injectable/injectable.dart";

@Injectable(as: ILanguageRepository)
class LanguageRepository implements ILanguageRepository {
  LanguageRepository(this._languageStorage);
  final ILanguageStorage _languageStorage;

  @override
  Future<void> changeLanguage(String locale) {
    return _languageStorage.saveLocale(locale);
  }
}
