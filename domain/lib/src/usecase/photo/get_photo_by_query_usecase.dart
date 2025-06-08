import "package:domain/domain.dart";
import "package:injectable/injectable.dart";

@injectable
class GetPhotoByQueryUsecase {
  GetPhotoByQueryUsecase(this.repository);

  final PhotoRepository repository;

  Future<PhotoUrlsEntity> call(String query) {
    return repository.getPhotoByQuery(query);
  }
}
