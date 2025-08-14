import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:resident_live/gen/translations.g.dart";
import "package:resident_live/screens/language/change_language_cubit.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";
import "package:resident_live/shared/lib/service/toast.service.dart";
import "package:resident_live/shared/lib/utils/dependency_squirrel.dart";
import "package:resident_live/shared/widget/rl.sliver_header.dart";

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ChangeLanguageCubit, ResourceState<void>>(
        listener: (context, state) async {
          state.maybeMap(
            orElse: () {},
            data: (_) {
              ToastService.instance.showToast(context, message: context.t.languageUpdated);
            },
            error: (error) {
              ToastService.instance.showToast(
                context,
                message: error.errorMessage ?? "",
                status: ToastStatus.failure,
              );
            },
          );
        },
        builder: (context, state) {
          const supportedLocales = AppLocale.values;

          return CustomScrollView(
            slivers: [
              AiSliverHeader(titleText: context.t.languageTitle),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final locale = supportedLocales[index];
                  final isSelected = locale == LocaleSettings.currentLocale;

                  return ListTile(
                    title: Text(locale.languageCode),
                    subtitle: Text(locale.countryCode ?? ""),
                    trailing: isSelected
                        ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                        : null,
                    onTap: () {
                      find<ChangeLanguageCubit>(context).loadResource(locale.languageCode);
                    },
                  );
                }, childCount: supportedLocales.length),
              ),
            ],
          );
        },
      ),
    );
  }
}
