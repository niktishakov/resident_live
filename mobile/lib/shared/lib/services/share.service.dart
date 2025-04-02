import "dart:io";

import "package:flutter/foundation.dart";
import "package:resident_live/domain/entities/entities.dart";
import "package:resident_live/shared/lib/extensions/datetime_extension.dart";
import "package:share_plus/share_plus.dart";

class ShareService {
  const ShareService._();

  static Future<void> init() async {
    _instance = const ShareService._();
  }

  static late ShareService _instance;

  static ShareService get instance {
    return _instance;
  }

  Future<bool> shareFile(File file) async {
    try {
      await Share.shareXFiles([XFile(file.path)]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> shareImage(
    XFile img, {
    String? subject,
    String? text,
  }) async {
    try {
      await Share.shareXFiles(
        [img],
        subject: subject,
        text: text,
      );

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> shareText(String text, {String? subject}) async {
    try {
      await Share.share(text, subject: subject);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> shareResidence(CountryEntity residence, {String? subject}) {
    final shareContent = _buildResidenceShareContent(residence);
    return shareText(shareContent);
  }

  String _buildResidenceShareContent(CountryEntity residence) {
    return residence.isResident
        ? """
${residence.name}'s Summary:
Has A Residency 🚀
- ${residence.extraDays} Extra Days Available For Travelling
- Your Resident Status will be save until ${residence.statusToggleAt.toMMMDDYYYY()}
Resident Live: App Link
"""
        : """
${residence.name}'s Summary:
Non-Resident
- You’ll reach a resident status at ${residence.statusToggleAt.toMMMDDYYYY()}
- ${residence.statusToggleIn} days left
Resident Live: App Link
""";
  }

  Future<bool> shareImageFromData(Uint8List img, {String? name}) async {
    final file = XFile.fromData(img, name: name, mimeType: "image/png");
    return shareImage(file);
  }
}
