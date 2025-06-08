import "package:gaimon/gaimon.dart";

class VibrationService {
  VibrationService._({required this.canVibrate});

  final bool canVibrate;

  static Future<void> init() async {
    assert(_instance == null);

    final canVibrate = await Gaimon.canSupportsHaptic;

    _instance = VibrationService._(canVibrate: canVibrate);
  }

  static VibrationService? _instance;

  static VibrationService get instance {
    assert(_instance != null, "Remember to initialise VibrationService by calling its init method");
    return _instance!;
  }

  void tap() {
    if (canVibrate) {
      Gaimon.medium();
    }
  }

  void light() {
    if (canVibrate) {
      Gaimon.light();
    }
  }

  void success({bool strong = false}) {
    if (canVibrate) {
      Gaimon.success();
    }
  }

  void warning() {
    if (canVibrate) {
      Gaimon.warning();
    }
  }

  void error() {
    if (canVibrate) {
      Gaimon.error();
    }
  }
}
