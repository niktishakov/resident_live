part of "../residence_details_screen.dart";

class _TodayButton extends StatelessWidget {
  const _TodayButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    final date = DateTime.now();

    return CupertinoButton(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(12),
      onPressed: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: theme.borderAccent,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Text(
            "Today, ${date.toDDMMMYYString()}",
            style: context.rlTheme.body14.copyWith(
              color: theme.textAccent,
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
