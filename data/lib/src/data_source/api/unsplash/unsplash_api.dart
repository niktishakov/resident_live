import "package:data/src/model/api/unsplash/photo_response.dart";
import "package:data/src/module/unsplash_dio_module.dart";
import "package:injectable/injectable.dart";

abstract class UnsplashApi {
  Future<PhotoResponse> getPhotoByQuery(String query);
}

@Injectable(as: UnsplashApi)
class UnsplashApiImpl implements UnsplashApi {
  UnsplashApiImpl(this.dio);
  final UnsplashDio dio;

  @override
  Future<PhotoResponse> getPhotoByQuery(String query) async {
    final response = await dio.get("/search/photos", queryParameters: {"query": query});
    return PhotoResponse.fromJson(response.data);
  }
}
