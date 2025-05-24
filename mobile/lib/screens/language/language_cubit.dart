import "package:data/data.dart";
import "package:flutter/material.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:hydrated_bloc/hydrated_bloc.dart";
import "package:resident_live/app/injection.dart";

part "language_cubit.freezed.dart";
part "language_cubit.g.dart";

// Преобразование строкового ключа в Locale
Locale keyToLocale(String localeKey) {
  final parts = localeKey.split("_");
  return parts.length > 1 ? Locale(parts[0], parts[1]) : Locale(parts[0]);
}

/// Статус операции изменения языка
enum LanguageStatus { initial, loading, success, error }

@freezed
class LanguageState with _$LanguageState {
  const factory LanguageState({
    required String localeKey,
    @Default(LanguageStatus.initial) LanguageStatus status,
    @Default("") String errorMessage,
  }) = _LanguageState;

  const LanguageState._();

  factory LanguageState.fromJson(Map<String, dynamic> json) => _$LanguageStateFromJson(json);

  Locale get locale => keyToLocale(localeKey);
}

class LanguageCubit extends HydratedCubit<LanguageState> {
  LanguageCubit({required this.supportedLocales, required this.fallbackLocale})
    : super(LanguageState(localeKey: _localeToKey(fallbackLocale)));

  final List<Locale> supportedLocales;
  final Locale fallbackLocale;

  static final _logger = getIt<LoggerService>();

  static String _localeToKey(Locale locale) {
    return locale.countryCode != null
        ? "${locale.languageCode}_${locale.countryCode}"
        : locale.languageCode;
  }

  Future<void> setLanguage(String languageCode, String? countryCode) async {
    try {
      emit(state.copyWith(status: LanguageStatus.loading, errorMessage: ""));

      final newLocale = Locale(languageCode, countryCode);
      final localeKey = _localeToKey(newLocale);
      _logger.info("Setting language to $localeKey");

      if (supportedLocales.contains(newLocale)) {
        emit(state.copyWith(localeKey: localeKey, status: LanguageStatus.success));
      } else {
        throw UnsupportedError("Locale $newLocale is not supported");
      }
    } catch (e) {
      _logger.error("Error setting language: $e");
      emit(state.copyWith(status: LanguageStatus.error, errorMessage: e.toString()));
    }
  }

  @override
  LanguageState? fromJson(Map<String, dynamic> json) {
    return LanguageState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(LanguageState state) {
    return state.toJson();
  }
}
