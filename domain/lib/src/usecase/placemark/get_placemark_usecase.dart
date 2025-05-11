import "package:domain/domain.dart";
import "package:injectable/injectable.dart";

@injectable
class GetPlacemarkUsecase {
  GetPlacemarkUsecase(this._repository);
  final IPlacemarkRepository _repository;

  Future<PlacemarkValueObject?> call(CoordinatesValueObject coordinates) {
    return _repository.getPlacemark(coordinates);
  }
}
