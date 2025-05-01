import "package:flutter_vibrate/flutter_vibrate.dart";

class VibrationService {
  VibrationService._({required this.canVibrate});

  final bool canVibrate;

  static Future<void> init() async {
    assert(_instance == null);

    final canVibrate = await Vibrate.canVibrate;

    _instance = VibrationService._(canVibrate: canVibrate);
  }

  static VibrationService? _instance;

  static VibrationService get instance {
    assert(_instance != null,
        "Remember to initialise VibrationService by calling its init method",);
    return _instance!;
  }

  void tap() {
    if (canVibrate) {
      Vibrate.feedback(FeedbackType.medium);
    }
  }

  void light() {
    if (canVibrate) {
      Vibrate.feedback(FeedbackType.light);
    }
  }

  void success({bool strong = false}) {
    if (canVibrate) {
      Vibrate.feedback(strong ? FeedbackType.success : FeedbackType.light);
    }
  }

  void warning() {
    if (canVibrate) {
      Vibrate.feedback(FeedbackType.warning);
    }
  }

  void error() {
    if (canVibrate) {
      Vibrate.feedback(FeedbackType.error);
    }
  }
}
