enum Environment { prod, dev }

extension EnvironmentExtention on Environment {
  String get asString {
    switch (this) {
      case Environment.prod:
        return "PROD";
      case Environment.dev:
        return "DEV";
    }
  }

  bool get isProd => this == Environment.prod;

  bool get isDev => this == Environment.dev;
}
