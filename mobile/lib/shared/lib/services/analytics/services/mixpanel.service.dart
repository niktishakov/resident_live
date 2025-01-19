import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:resident_live/shared/shared.dart';

class MixpanelService {
  MixpanelService(String projectToken) {
    _init(projectToken);
  }

  late Mixpanel _mixpanel;
  bool isReady = false;
  final _logger = AiLogger('MixpanelService');

  Future<void> _init(String projectToken) async {
    try {
      _mixpanel = await Mixpanel.init(
        projectToken,
        optOutTrackingDefault: false,
        trackAutomaticEvents: true,
      );
      isReady = true;
    } catch (e) {
      _logger.error('Error initializing Mixpanel: $e');
    }
  }

  void logEvent(String eventName, [Map<String, dynamic>? props]) {
    if (!isReady) {
      _logger.error('Mixpanel is not ready');
      return;
    }
    _mixpanel.track(eventName, properties: props);
  }

  void setCurrentScreen(String screenName, [Map<String, dynamic>? props]) {
    if (!isReady) {
      _logger.error('Mixpanel is not ready');
      return;
    }
    _mixpanel.track(screenName, properties: props);
  }
}
