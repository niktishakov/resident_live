import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/gen/translations.g.dart";
import "package:resident_live/shared/shared.dart";

class EmptyTripsList extends StatelessWidget {
  const EmptyTripsList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    final t = context.t;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            t.trips.noTripsYet,
            style: theme.body22.copyWith(
              fontWeight: FontWeight.w300,
              letterSpacing: 0,
              foreground: Paint()
                ..style = PaintingStyle.fill
                ..shader = LinearGradient(
                  colors: [theme.textPrimary, theme.textPrimary.withValues(alpha: 0.5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(const Rect.fromLTWH(0, 0, 150, 30)),
            ),
          ),
          context.vBox16,
          Text(
            t.trips.planFutureTripToAvoidMistakes,
            style: theme.body14.copyWith(fontWeight: FontWeight.w300, color: theme.textPrimary),
          ),
          context.vBox24,
          PrimaryButton(
            onPressed: () {
              context.goNamed(ScreenNames.addTrip);
            },
            label: t.trips.addYourFirstTrip,
            textStyle: theme.body14.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.textPrimaryOnColor,
            ),
          ),
        ],
      ),
    );
  }
}
