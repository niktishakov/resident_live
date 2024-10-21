import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../api/language_repository.dart';

class LanguageCubit extends HydratedCubit<Locale> {
  LanguageCubit(this._repository) : super(_repository.currentLocale);
  final LanguageRepository _repository;

  List<Locale> get supportedLocales => _repository.supportedLocales;

  Future<void> setLanguage(String languageCode, String? countryCode) async {
    final newLocale = Locale(languageCode, countryCode);
    if (supportedLocales.contains(newLocale)) {
      await _repository.setLocale(newLocale);
      emit(newLocale);
    } else {
      throw UnsupportedError('Locale $newLocale is not supported');
    }
  }

  @override
  Locale? fromJson(Map<String, dynamic> json) {
    return Locale(json['languageCode'], json['countryCode']);
  }

  @override
  Map<String, dynamic>? toJson(Locale state) {
    return {
      'languageCode': state.languageCode,
      'countryCode': state.countryCode,
    };
  }
}
