import "dart:ui";

const String appName = "Resident Live";
const String appStoreLink = "https://apps.apple.com/your-app-link";
const String playStoreLink = "https://play.google.com/store/apps/details?id=your.app.id";
const String privacyPolicyUrl =
    "https://oil-dance-a77.notion.site/Resident-Live-s-Privacy-policy-1f33399c8482802b9ca3f02460bcbab6";
const String termsOfUseUrl =
    "https://oil-dance-a77.notion.site/Resident-live-s-Terms-and-Conditions-1f33399c848280a98f86e7ce12f3b8d9";

const kpmgUrl =
    "https://kpmg.com/xx/en/our-insights/gms-flash-alert/taxation-international-executives.html";
const deloitteUrl = "https://dits.deloitte.com/#TaxGuides";
const pwcUrl = "https://taxsummaries.pwc.com/";
const oecdUrl =
    "https://web-archive.oecd.org/tax/automatic-exchange/crs-implementation-and-assistance/tax-residency/index.htm";

const Map<String, Map<String, String>> languageNames = {
  "en_US": {"native": "English", "english": "English"},
  "ru_RU": {"native": "Русский", "english": "Russian"},
  "de_DE": {"native": "Deutsch", "english": "German"},
};

final kSupportedLocales = [
  const Locale("en", "US"),
  const Locale("ru", "RU"),
];
const kFallbackLocale = Locale("en", "US");

String getLanguageName(Locale locale, {bool native = true}) {
  final localeKey = "${locale.languageCode}_${locale.countryCode}";
  final nameType = native ? "native" : "english";
  return languageNames[localeKey]?[nameType] ?? locale.languageCode;
}
