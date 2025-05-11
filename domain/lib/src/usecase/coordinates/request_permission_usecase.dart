import "package:domain/domain.dart";

import "package:injectable/injectable.dart";

@injectable
class RequestGeoPermissionUsecase {
  RequestGeoPermissionUsecase(this._repository);

  final ICoordinatesRepository _repository;

  Future<bool> call() {
    return _repository.requestPermission();
  }
}
