import "package:data/src/model/api/unsplash/photo_response.dart";
import "package:data/src/module/unsplash_dio_module.dart";
import "package:injectable/injectable.dart";

abstract class UnsplashApi {
  Future<PhotoResponse> getPhotoByQuery(String query);
  Future<PhotoResult> getRandomPhoto({String? query});
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

  @override
  Future<PhotoResult> getRandomPhoto({String? query}) async {
    final queryParams = <String, dynamic>{};
    if (query != null) {
      queryParams["query"] = query;
    }

    final response = await dio.get("/photos/random", queryParameters: queryParams);
    return PhotoResult.fromJson(response.data);
  }
}
