import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resident_live/features/language/model/language_cubit.dart';
import 'package:resident_live/generated/codegen_loader.g.dart';
import 'package:resident_live/shared/ui/rl.sliver_header.dart';

import 'model/constants.dart';
import 'model/language_utils.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, currentLocale) {
          final languageCubit = context.read<LanguageCubit>();
          final supportedLocales = languageCubit.supportedLocales;

          return CustomScrollView(
            slivers: [
              AiSliverHeader(
                titleText: LocaleKeys.language_title.tr(),
                // Add any other properties your RlSliverHeader might need
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final locale = supportedLocales[index];
                    final isSelected = locale == currentLocale;

                    return ListTile(
                      title: Text(getLanguageName(locale, native: false)),
                      subtitle: Text(getLanguageName(locale, native: true)),
                      trailing: isSelected
                          ? Icon(Icons.check,
                              color: Theme.of(context).primaryColor)
                          : null,
                      onTap: () {
                        // print(
                        //     "locale.languageCode: ${locale.languageCode}, locale.countryCode: ${locale.countryCode}");
                        languageCubit.setLanguage(
                            locale.languageCode, locale.countryCode);
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
