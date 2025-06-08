import "package:domain/domain.dart";

abstract class PhotoRepository {
  Future<PhotoUrlsEntity> getPhotoByQuery(String query);
}
