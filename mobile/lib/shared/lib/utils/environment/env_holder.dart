import "package:resident_live/shared/lib/utils/environment/environment.dart";

class EnvHolder {
  EnvHolder(this._env);

  final Environment _env;

  Environment? _override;

  Environment get value => _override ?? _env;

  /// It overrides the environment for the current session.
  /// It's used to switch environment at runtime without changing
  /// the environment the app has been installed with.
  /// Useful so we never point to other environments by mistake.
  void overrideEnv(Environment override) {
    print("Environment updated to ${override.toString()}");
    _override = override;
  }
}
