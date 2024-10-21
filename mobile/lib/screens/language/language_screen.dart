import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resident_live/features/language/model/language_cubit.dart';
import 'package:resident_live/shared/ui/rl.sliver_header.dart';

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
                titleText: 'Select Language',
                // Add any other properties your RlSliverHeader might need
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final locale = supportedLocales[index];
                    final isSelected = locale == currentLocale;

                    return ListTile(
                      title: Text(_getLanguageName(locale)),
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

  String _getLanguageName(Locale locale) {
    switch (locale.toString()) {
      case 'en_US':
        return 'English';
      case 'es_ES':
        return 'Español';
      // Add more cases for other supported languages
      default:
        return locale.languageCode;
    }
  }
}
