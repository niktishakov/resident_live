import "dart:async";
import "dart:io" show Platform;

import "package:device_info_plus/device_info_plus.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:injectable/injectable.dart";

@singleton
class DeviceInfoService {
  DeviceInfoService._(
    this.iosInfo,
    this.androidInfo,
    this.packageInfo,
  ) : assert((iosInfo != null && androidInfo == null) || (iosInfo == null && androidInfo != null));

  final IosDeviceInfo? iosInfo;
  final AndroidDeviceInfo? androidInfo;
  final PackageInfo packageInfo;

  @factoryMethod
  static Future<DeviceInfoService> create() async {
    final packageInfo = await PackageInfo.fromPlatform();

    final deviceInfo = DeviceInfoPlugin();
    final iosInfo = Platform.isIOS ? await deviceInfo.iosInfo : null;
    final androidInfo = Platform.isAndroid ? await deviceInfo.androidInfo : null;

    final service = DeviceInfoService._(iosInfo, androidInfo, packageInfo);
    await service.init();
    return service;
  }

  String get appName => packageInfo.appName;
  String get packageName => packageInfo.packageName;
  String get appVersion => packageInfo.version;
  String get buildNumber => packageInfo.buildNumber;

  String get platform {
    if (Platform.isIOS) {
      return "iOS";
    } else if (Platform.isAndroid) {
      return "Android";
    }
    throw Exception("Invalid platform: ${Platform.operatingSystem}");
  }

  String get deviceId {
    String? id = Platform.isIOS
        ? iosInfo?.identifierForVendor
        : Platform.isAndroid
            ? androidInfo?.id
            : null;

    return id ?? "user_${DateTime.now().toString()}";
  }

  DeviceType get deviceType {
    if (Platform.isIOS) {
      return iosInfo?.model.toLowerCase() == "ipad" ? DeviceType.tablet : DeviceType.phone;
    }
    return DeviceType.phone;
  }

  Future<void> init() async {
    // Implementation of init method
  }
}

enum DeviceType { phone, tablet }

extension DeviceTypeExtension on DeviceType {
  T map<T extends Object>({required T Function() phone, required T Function() tablet}) {
    if (this == DeviceType.phone) {
      return phone.call();
    }

    if (this == DeviceType.tablet) {
      return tablet.call();
    }

    throw Exception("Invalid DeviceType $this");
  }
}
