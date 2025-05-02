import "package:domain/domain.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:resident_live/generated/l10n/l10n.dart";
import "package:resident_live/screens/language/language_cubit.dart";
import "package:resident_live/shared/lib/service/toast.service.dart";
import "package:resident_live/shared/shared.dart";
import "package:resident_live/shared/widget/rl.sliver_header.dart";

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LanguageCubit, LanguageState>(
        listener: (context, state) async {
          if (state.status == LanguageStatus.success) {
            ToastService.instance.showToast(context, message: S.of(context).languageUpdated);

            await Future.delayed(const Duration(milliseconds: 100));

            // Перезагружаем S.delegate чтобы обновить переводы
            await S.delegate.load(state.locale);
          } else if (state.status == LanguageStatus.error) {
            ToastService.instance.showToast(context, message: state.errorMessage);
          }
        },
        builder: (context, state) {
          final supportedLocales = find<LanguageCubit>(context).supportedLocales;

          return CustomScrollView(
            slivers: [
              AiSliverHeader(
                titleText: S.of(context).languageTitle,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final locale = supportedLocales[index];
                    final isSelected = locale == state.locale;

                    return ListTile(
                      title: Text(getLanguageName(locale, native: false)),
                      subtitle: Text(getLanguageName(locale, native: true)),
                      trailing: isSelected
                          ? Icon(
                              Icons.check,
                              color: Theme.of(context).primaryColor,
                            )
                          : null,
                      onTap: () {
                        find<LanguageCubit>(context).setLanguage(
                          locale.languageCode,
                          locale.countryCode,
                        );
                      },
                    );
                  },
                  childCount: supportedLocales.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
