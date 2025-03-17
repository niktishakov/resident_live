import 'package:package_info_plus/package_info_plus.dart';

/// https://pub.dev/packages/package_info#known-issue
/// https://github.com/flutter/flutter/issues/20761#issuecomment-493434578
/// iOS requires the Xcode build folder to be rebuilt after changes to the version string in pubspec.yaml.
/// Clean the Xcode build folder with: XCode Menu -> Product -> (Holding Option Key) Clean build folder.
class PackageInfoService {
  PackageInfoService._(this._info);

  final PackageInfo _info;

  static Future<PackageInfoService> create() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return PackageInfoService._(packageInfo);
  }

  String get appName => _info.appName;

  String get packageName => _info.packageName;

  String get appVersion => _info.version;

  String get buildNumber => _info.buildNumber;
}
