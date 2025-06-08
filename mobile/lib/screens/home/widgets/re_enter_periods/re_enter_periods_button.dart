import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/gen/translations.g.dart";

import "package:resident_live/shared/shared.dart";

class ReEnterPeriodsButton extends StatelessWidget {
  const ReEnterPeriodsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    final t = context.t;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: PrimaryButton(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        vibrate: true,
        gradient: vGradient,
        onPressed: () {
          context.push(ScreenNames.manageCountries);
        },
        label: t.home.reEnterStayPeriods,
        leading: AppAssetImage(
          AppAssets.sliderHorizontal2Gobackward,
          color: theme.textPrimary.withValues(alpha: 0.5),
          height: 22,
        ),
        expanded: true,
        textStyle: theme.body12.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.textPrimary.withValues(alpha: 0.5),
        ),
        backgroundColor: context.rlTheme.bgModal,
      ),
    );
  }
}
