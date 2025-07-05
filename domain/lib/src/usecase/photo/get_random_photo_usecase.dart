import "package:domain/domain.dart";
import "package:injectable/injectable.dart";

@injectable
class GetRandomPhotoUsecase {
  GetRandomPhotoUsecase(this.repository);

  final PhotoRepository repository;

  Future<PhotoUrlsEntity> call({String? query}) {
    return repository.getRandomPhoto(query: query);
  }
}
