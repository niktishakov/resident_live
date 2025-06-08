import "package:domain/domain.dart";
import "package:resident_live/gen/translations.g.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";

class ChangeLanguageCubit extends ResourceCubit<void, String> {
  ChangeLanguageCubit(ChangeLanguageUsecase usecase)
    : super(([languageCode]) async {
        final locale = AppLocale.values.firstWhere((locale) => locale.languageCode == languageCode);

        final currentLocale = LocaleSettings.currentLocale;
        if (currentLocale == locale) return;

        final result = await usecase.call(locale.languageCode);
        await LocaleSettings.setLocale(locale);

        return result;
      }, loadOnInit: false);
}
