import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:resident_live/app/main.dart';

class LanguageRepository {

  LanguageRepository({
    required this.supportedLocales,
    required this.fallbackLocale,
  });
  final List<Locale> supportedLocales;
  final Locale fallbackLocale;

  Locale get currentLocale {
    final context = navigatorKey.currentContext;
    return context != null
        ? EasyLocalization.of(context)?.locale ?? fallbackLocale
        : fallbackLocale;
  }

  Future<void> setLocale(Locale locale) async {
    final context = navigatorKey.currentContext;
    if (context != null) {
      await EasyLocalization.of(context)?.setLocale(locale);
    }
  }
}
