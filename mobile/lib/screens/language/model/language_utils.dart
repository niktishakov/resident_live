import 'dart:ui';

import 'constants.dart';

String getLanguageName(Locale locale, {bool native = true}) {
  final localeKey = '${locale.languageCode}_${locale.countryCode}';
  final nameType = native ? 'native' : 'english';
  return languageNames[localeKey]?[nameType] ?? locale.languageCode;
}
