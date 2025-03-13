import 'package:get_it/get_it.dart';
import 'package:resident_live/shared/shared.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static Future<void> init() async {
    getIt.registerSingleton<GeolocationService>(GeolocationService());
  }
}
