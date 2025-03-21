import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:resident_live/generated/codegen_loader.g.dart';
import 'package:resident_live/shared/shared.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text.rich(
              style: theme.body22M,
              TextSpan(
                children: [
                  TextSpan(
                    text: '${LocaleKeys.calendar_yourJourney.tr()}\n',
                  ),
                  TextSpan(
                    text: LocaleKeys.calendar_last12Months.tr(),
                    style: theme.body22M.copyWith(color: theme.textAccent),
                  ),
                ],
              ),
            ),
          ),
        ),
        RlCloseButton(
          color: context.theme.colorScheme.secondary.withOpacity(0.85),
        ),
        Gap(16),
      ],
    );
  }
}
