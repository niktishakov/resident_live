import "dart:convert";

import "package:flutter/services.dart";

import "package:resident_live/shared/lib/utils/environment/env_holder.dart";

/// Create the file secrets.json in the root directory of this app.
/// Replace the mocked values with the actual values.
/// Ask a colleague for the up-to-date ones.
///
/// {
///   "apiUrl": {
///     "prod": "secret-prod-url",
///     "dev": "secret-dev-url"
///   },
///   "sentryDsn": "secret-dsn",
///   "ampliudeApiKey": "secret-key",
/// }
class Secrets {
  Secrets._(this._config);

  static Future<Secrets> create(EnvHolder envHolder) async {
    final configAsString = await rootBundle.loadString("secrets.json");
    final config = json.decode(configAsString) as Map<String, dynamic>;

    return Secrets._(
      Map<String, dynamic>.unmodifiable(config),
    );
  }

  final Map<String, dynamic> _config;

  String get mixpanelToken => _config["mixpanel_token"] as String;
}
