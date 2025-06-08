import "package:data/src/shared/environment/env_handler.dart";
import "package:dio/dio.dart";
import "package:injectable/injectable.dart";

typedef UnsplashDio = Dio;

@module
abstract class UnsplashDioModule {
  @lazySingleton
  UnsplashDio dio() {
    final dio = Dio();
    dio.options.baseUrl = EnvHandler.unsplashBaseUrl;
    dio.options.headers["Authorization"] = "Client-ID ${EnvHandler.unsplashAccessKey}";
    return dio;
  }
}
