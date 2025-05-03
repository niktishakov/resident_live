import "dart:io";

import "package:data/src/service/analytics/analytics_parameters.dart";
import "package:data/src/service/analytics/events/analytics_event.dart";
import "package:data/src/service/analytics/services/mixpanel.service.dart";
import "package:data/src/service/logger.service.dart";
import "package:get_it/get_it.dart";

class AiAnalytics {
  AiAnalytics._(this._mixpanel, this._getCustomParams);
  final MixpanelService? _mixpanel;
  final Map<String, dynamic> Function() _getCustomParams;

  final LoggerService _logger = GetIt.I<LoggerService>();
  final Map<String, dynamic> _defaults = <String, dynamic>{};

  static AiAnalytics? _instance;
  static AiAnalytics get instance {
    assert(_instance != null, "Remember to initialise Appsflyer by calling its init method");
    return _instance!;
  }

  static void init({MixpanelService? mixpanel, bool isRelease = false, String? environment, Map<String, dynamic> Function()? getCustomParams}) {
    if (_instance == null) {
      _instance = AiAnalytics._(mixpanel, getCustomParams ?? (() => {}));
      _instance!._defaults.addAll(<String, dynamic>{
        AnalyticsParameters.appEnviroment: environment,
        AnalyticsParameters.mode: isRelease ? "release" : "debug",
      });
    }
  }

  Future<void> logEvent(AnalyticsEvent? event) async {
    if (event == null) return;
    if (Platform.isAndroid) return;

    try {
      final parameters = <String, dynamic>{..._defaults, ..._getCustomParams(), if (event.hasParams) ...event.getParams()};

      _mixpanel?.logEvent(event.getName(), parameters);

      _logger.info("Event: ${event.getName()}, Params: $parameters");
    } catch (e, stackTrace) {
      _logger.error(e, stackTrace);
    }
  }

  void setCurrentScreen(String screenName, {Object? args, Map<String, dynamic>? parameters}) {
    assert(screenName.isNotEmpty);

    if (Platform.isAndroid) return;

    final hasArgs = args != null && args is Map<String, dynamic> && args.isNotEmpty;
    final params = <String, dynamic>{
      ..._defaults,
      ..._getCustomParams(),
      if (hasArgs) ...args,
      if (parameters != null && parameters.isNotEmpty) ...parameters,
    };

    _logger.info("Event: $screenName, Params: $params");

    _mixpanel?.setCurrentScreen(screenName, params);
  }
}
