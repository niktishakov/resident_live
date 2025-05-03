import "package:data/src/service/logger.service.dart";
import "package:get_it/get_it.dart";
import "package:mixpanel_flutter/mixpanel_flutter.dart";

class MixpanelService {
  MixpanelService(String projectToken) {
    _init(projectToken);
  }

  late Mixpanel _mixpanel;
  bool isReady = false;
  final _logger = GetIt.I<LoggerService>();

  Future<void> _init(String projectToken) async {
    try {
      _mixpanel = await Mixpanel.init(projectToken, optOutTrackingDefault: false, trackAutomaticEvents: true);
      isReady = true;
    } catch (e) {
      _logger.error("Error initializing Mixpanel: $e");
    }
  }

  void logEvent(String eventName, [Map<String, dynamic>? props]) {
    if (!isReady) {
      _logger.error("Mixpanel is not ready");
      return;
    }
    _mixpanel.track(eventName, properties: props);
  }

  void setCurrentScreen(String screenName, [Map<String, dynamic>? props]) {
    if (!isReady) {
      _logger.error("Mixpanel is not ready");
      return;
    }
    _mixpanel.track(screenName, properties: props);
  }
}
