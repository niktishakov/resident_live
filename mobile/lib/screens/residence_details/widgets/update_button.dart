part of "../residence_details_screen.dart";

class _UpdateButton extends StatelessWidget {
  const _UpdateButton({
    required this.onTap,
    required this.date,
  });

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
          border: Border.all(
            color: theme.borderWarning,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Text(
            "Update, ${date.toDDMMMYYString()}",
            style: context.rlTheme.body14.copyWith(
              color: theme.borderWarning,
              fontFamily: kFontFamilySecondary,
              fontWeight: FontWeight.w500,
              height: 1,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
