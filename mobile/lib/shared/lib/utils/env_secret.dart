import 'environment/export.dart';

/// Used for secrets that have different values depending on the environment
class EnvSecret {
  EnvSecret(this._envHolder, this._config);

  final EnvHolder _envHolder;
  final Map<String, dynamic> _config;

  String get value {
    if (_envHolder.value.isProd) {
      return _config['prod'] as String;
    }
    return _config['dev'] as String;
  }
}
