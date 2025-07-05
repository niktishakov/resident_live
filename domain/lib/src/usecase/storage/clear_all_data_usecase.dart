import "package:domain/domain.dart";
import "package:injectable/injectable.dart";

@injectable
class ClearAllDataUsecase {
  ClearAllDataUsecase(this._userRepository, this._tripRepository, this._languageRepository);

  final IUserRepository _userRepository;
  final TripRepository _tripRepository;
  final ILanguageRepository _languageRepository;

  Future<void> call() async {
    await _userRepository.clearAllData();
    await _tripRepository.clearAllData();
    await _languageRepository.clearAllData();
  }
}
