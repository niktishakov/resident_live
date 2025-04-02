import "dart:async";
import "dart:io" show Platform;
import "dart:ui";

import "package:device_info_plus/device_info_plus.dart";
import "package:flutter/material.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:resident_live/shared/shared.dart";

class DeviceInfoService {
  DeviceInfoService._(
    this.iosInfo,
    this.androidInfo,
    this.packageInfo,
  ) : assert((iosInfo != null && androidInfo == null) ||
            (iosInfo == null && androidInfo != null),);

  final IosDeviceInfo? iosInfo;
  final AndroidDeviceInfo? androidInfo;
  final PackageInfo packageInfo;
  final _logger = AiLogger("DeviceInfoService");

  static Future<DeviceInfoService> create() async {
    final packageInfo = await PackageInfo.fromPlatform();

    final deviceInfo = DeviceInfoPlugin();
    final iosInfo = Platform.isIOS ? await deviceInfo.iosInfo : null;
    final androidInfo =
        Platform.isAndroid ? await deviceInfo.androidInfo : null;

    return DeviceInfoService._(
      iosInfo,
      androidInfo,
      packageInfo,
    );
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
    throw "Invalid platform: ${Platform.operatingSystem}";
  }

  String get deviceId {
    if (Platform.isAndroid) {
      return androidInfo!.id;
    } else if (Platform.isIOS) {
      return iosInfo!.identifierForVendor ?? "";
    }
    throw "Invalid platform: ${Platform.operatingSystem}";
  }

  DeviceType get deviceType {
    if (Platform.isIOS) {
      return iosInfo?.model.toLowerCase() == "ipad"
          ? DeviceType.tablet
          : DeviceType.phone;
    } else {
      // Solution taken from: https://stackoverflow.com/questions/49484549/can-we-check-the-device-to-be-smartphone-or-tablet-in-flutter
      final data = MediaQueryData.fromView(FlutterView as FlutterView);
      return data.size.shortestSide > 550
          ? DeviceType.tablet
          : DeviceType.phone;
    }
  }
}

enum DeviceType { phone, tablet }

extension DeviceTypeExtension on DeviceType {
  T map<T extends Object>({
    required T Function() phone,
    required T Function() tablet,
  }) {
    if (this == DeviceType.phone) {
      return phone.call();
    }

    if (this == DeviceType.tablet) {
      return tablet.call();
    }

    throw "Invalid DeviceType $this";
  }
}
