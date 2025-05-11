import "package:domain/domain.dart";

import "package:injectable/injectable.dart";

@injectable
class GetCoordinatesUsecase {
  GetCoordinatesUsecase(this._repository);
  final ICoordinatesRepository _repository;

  Future<CoordinatesValueObject> call() {
    return _repository.getCoordinates();
  }
}
