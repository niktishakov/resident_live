abstract class EnvHandler {
  static const env = String.fromEnvironment("ENV");
  static const sentryDSN = String.fromEnvironment("SENTRY_DSN");
  static const mixpanelToken = String.fromEnvironment("MIXPANEL_TOKEN");
  static const unsplashAccessKey = String.fromEnvironment("UNSPLASH_ACCESS_KEY");
}
