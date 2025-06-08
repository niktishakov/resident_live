enum AnalyticsService { amplitude, appsflyer }

extension AnalyticsTypeExtension on AnalyticsService {
  bool get isAppsflyer => this == AnalyticsService.appsflyer;
}

abstract class AnalyticsEvent {
  AnalyticsEvent({
    required String name,
    Map<String, dynamic> params = const <String, dynamic>{},
  })  : assert(name.isNotEmpty),
        _name = name,
        _params = params;

  final String _name;
  final Map<String, dynamic> _params;

  bool get hasParams => _params.isNotEmpty;

  Map<String, dynamic> getParams(
      {AnalyticsService service = AnalyticsService.amplitude,}) {
    final parameters = <String, dynamic>{..._params};

    // if (service.isAppsflyer) {
    //   return parameters.map<String, dynamic>(
    //     (key, dynamic value) {
    //       final appsflyerKey = AppsflyerReplacementKeys.value[key] ?? key;
    //       return MapEntry<String, dynamic>(
    //         ReCase(appsflyerKey).titleCase,
    //         value,
    //       );
    //     },
    //   );
    // }

    return parameters;
  }

  String getName({AnalyticsService service = AnalyticsService.amplitude}) {
    return _name;
  }

  @override
  String toString() {
    final buffer = StringBuffer("\n");
    for (final service in AnalyticsService.values) {
      final name = getName(service: service);
      final params = getParams(service: service);
      buffer.writeln("$service event - $name: $params");
    }

    return buffer.toString();
  }
}
