import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/cupertino.dart";
import "package:resident_live/shared/shared.dart";

class UpdateButton extends StatelessWidget {
  const UpdateButton({required this.onTap, required this.date, super.key});

  final VoidCallback onTap;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(12),
      onPressed: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: theme.borderWarning, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: AutoSizeText(
            "Update, ${date.toDDMMMYYString()}",
            maxLines: 1,
            style: context.rlTheme.body12.copyWith(
              color: theme.borderWarning,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
