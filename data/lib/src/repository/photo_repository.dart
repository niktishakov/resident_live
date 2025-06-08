import "package:data/src/data_source/api/unsplash/unsplash_api.dart";
import "package:domain/domain.dart";
import "package:injectable/injectable.dart";

@Injectable(as: PhotoRepository)
class PhotoRepositoryImpl implements PhotoRepository {
  PhotoRepositoryImpl(this._unsplashApi);
  final UnsplashApi _unsplashApi;

  @override
  Future<PhotoUrlsEntity> getPhotoByQuery(String query) async {
    final photoModel = await _unsplashApi.getPhotoByQuery(query);
    final photoResult = photoModel.results.first;

    return PhotoUrlsEntity(
      raw: photoResult.urls.raw,
      full: photoResult.urls.full,
      regular: photoResult.urls.regular,
      small: photoResult.urls.small,
      thumb: photoResult.urls.thumb,
    );
  }
}
