import "dart:io";
import "dart:typed_data";
import "package:data/src/constants.dart";
import "package:domain/domain.dart";
import "package:injectable/injectable.dart";
import "package:share_plus/share_plus.dart";

@injectable
class ShareService {
  ShareService();

  Future<ShareResult> shareFile(File file) async {
    try {
      return SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
    } catch (e) {
      return ShareResult.unavailable;
    }
  }

  Future<ShareResult> shareImage(XFile img, {String? subject, String? text}) async {
    try {
      return SharePlus.instance.share(ShareParams(files: [img], subject: subject, text: text));
    } catch (e) {
      return ShareResult.unavailable;
    }
  }

  Future<String?> shareText(String text, {String? subject}) async {
    try {
      await SharePlus.instance.share(ShareParams(text: text, subject: subject));
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
    return residence.isResident ? getShareResidence(residence) : getShareNonResidence(residence);
  }

  Future<ShareResult> shareImageFromData(Uint8List img, {String? name}) async {
    final file = XFile.fromData(img, name: name, mimeType: "image/png");
    return shareImage(file);
  }
}
