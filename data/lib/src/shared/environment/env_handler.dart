abstract class EnvHandler {
  static const env = String.fromEnvironment("ENV");
  static const sentryDSN = String.fromEnvironment("SENTRY_DSN");
  static const mixpanelToken = String.fromEnvironment("MIXPANEL_TOKEN");
  static const unsplashBaseUrl = String.fromEnvironment("UNSPLASH_BASE_URL");
  static const unsplashAppId = String.fromEnvironment("UNSPLASH_APP_ID");
  static const unsplashAccessKey = String.fromEnvironment("UNSPLASH_ACCESS_KEY");
  static const unsplashSecretKey = String.fromEnvironment("UNSPLASH_SECRET_KEY");
}
