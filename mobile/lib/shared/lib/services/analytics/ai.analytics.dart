import "dart:io";

import "package:flutter/foundation.dart";
import "package:resident_live/shared/lib/services/analytics/analytics_parameters.dart";
import "package:resident_live/shared/lib/services/analytics/events/analytics_event.dart";
import "package:resident_live/shared/shared.dart";

class AiAnalytics {
  AiAnalytics._(
    this._mixpanel,
    this._getCustomParams,
  );
  final MixpanelService? _mixpanel;
  final Map<String, dynamic> Function() _getCustomParams;

  final AiLogger _logger = AiLogger("AiAnalytics");
  final Map<String, dynamic> _defaults = <String, dynamic>{};

  static AiAnalytics? _instance;
  static AiAnalytics get instance {
    assert(_instance != null,
        "Remember to initialise Appsflyer by calling its init method",);
    return _instance!;
  }

  static void init({
    required Environment environment, MixpanelService? mixpanel,
    Map<String, dynamic> Function()? getCustomParams,
  }) {
    if (_instance == null) {
      _instance = AiAnalytics._(mixpanel, getCustomParams ?? (() => {}));
      _instance!._defaults.addAll(<String, dynamic>{
        AnalyticsParameters.appEnviroment: environment.asString,
        // 'checked' mode indicates that performance is not representative of what will happen in release mode.
        AnalyticsParameters.mode: kReleaseMode ? "release" : "checked",
      });
    }
  }

  Future<void> logEvent(AnalyticsEvent? event) async {
    if (event == null) return;
    if (Platform.isAndroid) return;

    try {
      final parameters = <String, dynamic>{
        ..._defaults,
        ..._getCustomParams(),
        if (event.hasParams) ...event.getParams(),
      };

      _mixpanel?.logEvent(event.getName(), parameters);

      _logger.info("Event: ${event.getName()}, Params: $parameters");
    } catch (e, stackTrace) {
      _logger.error(e, stackTrace);
    }
  }

  void setCurrentScreen(
    String screenName, {
    Object? args,
    Map<String, dynamic>? parameters,
  }) {
    assert(screenName.isNotEmpty);

    if (Platform.isAndroid) return;

    final hasArgs =
        args != null && args is Map<String, dynamic> && args.isNotEmpty;
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
