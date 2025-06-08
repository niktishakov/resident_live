abstract class EnvHandler {
  static const env = String.fromEnvironment("ENV", defaultValue: "dev");
  static const sentryDSN = String.fromEnvironment(
    "SENTRY_DSN",
    defaultValue:
        "https://44eefb75cebad54719389b880baaa3be@o1116615.ingest.us.sentry.io/4509258978557952",
  );
  static const mixpanelToken = String.fromEnvironment(
    "MIXPANEL_TOKEN",
    defaultValue: "d56f70168f03d1c003c4c2c6923a68de",
  );

  static const unsplashAccessKey = String.fromEnvironment(
    "UNSPLASH_ACCESS_KEY",
    defaultValue: "1234567890",
  );
}
