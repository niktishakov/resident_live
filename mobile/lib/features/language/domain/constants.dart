import "dart:ui";

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
