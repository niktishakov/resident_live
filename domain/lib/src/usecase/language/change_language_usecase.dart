import "package:domain/src/repository/language_repository.dart";

import "package:injectable/injectable.dart";

@injectable
class ChangeLanguageUsecase {
  ChangeLanguageUsecase(this._repository);
  final ILanguageRepository _repository;

  Future<void> call(String locale) {
    return _repository.changeLanguage(locale);
  }
}
