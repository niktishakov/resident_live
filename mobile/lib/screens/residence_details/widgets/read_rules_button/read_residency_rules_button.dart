import "package:flutter/material.dart";
import "package:resident_live/localization/generated/l10n/l10n.dart";
import "package:resident_live/screens/residence_details/widgets/read_rules_button/residency_rules_modal.dart";
import "package:resident_live/shared/shared.dart";
import "package:resident_live/shared/widget/transparent_button.dart";

class ReadResidencyRulesButton extends StatelessWidget {
  const ReadResidencyRulesButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: TransparentButton(
        leading: const AppAssetImage(
          AppAssets.bookPages,
          width: 24,
        ),
        onPressed: () => showResidencyRulesModal(context),
        child: Text(
          S.of(context).detailsReadRules,
          style: theme.body14.copyWith(
            fontWeight: FontWeight.w300,
            color: theme.textPrimary,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }
}
