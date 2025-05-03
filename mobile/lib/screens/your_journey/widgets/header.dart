import "package:flutter/cupertino.dart";
import "package:gap/gap.dart";
import "package:resident_live/localization/generated/l10n/l10n.dart";
import "package:resident_live/shared/shared.dart";

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
                    text: "${S.of(context).calendarYourJourney}\n",
                  ),
                  TextSpan(
                    text: S.of(context).calendarLast12Months,
                    style: theme.body22M.copyWith(color: theme.textAccent),
                  ),
                ],
              ),
            ),
          ),
        ),
        RlCloseButton(
          color: context.theme.colorScheme.secondary.withValues(alpha: 0.85),
        ),
        const Gap(16),
      ],
    );
  }
}
