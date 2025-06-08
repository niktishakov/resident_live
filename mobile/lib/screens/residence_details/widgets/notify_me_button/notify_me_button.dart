import "package:flutter/cupertino.dart";
import "package:resident_live/gen/translations.g.dart";
import "package:resident_live/shared/shared.dart";

class NotifyMeButton extends StatelessWidget {
  const NotifyMeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {},
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.t.detailsNotifyMe,
              style: theme.body14.copyWith(
                fontWeight: FontWeight.w300,
                color: theme.textPrimary,
                letterSpacing: 0.1,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                "Every 30 days",
                style: theme.body14.copyWith(
                  fontWeight: FontWeight.w300,
                  color: theme.textSecondary,
                ),
              ),
              Icon(CupertinoIcons.chevron_right, size: 24, color: theme.iconSecondary),
            ],
          ),
        ],
      ),
    );
  }
}
