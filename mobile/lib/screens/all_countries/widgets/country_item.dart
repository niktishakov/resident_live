part of "../all_countries_screen.dart";

class _CountryItem extends StatelessWidget {
  const _CountryItem({
    required this.countryCode,
    required this.daysSpent,
    required this.toggleSelection,
    required this.isEditing,
    required this.isSelected,
    required this.isLast,
    super.key,
  });

  final String countryCode;
  final int daysSpent;
  final bool isEditing;
  final bool isSelected;
  final bool isLast;
  final Function({
    required String countryCode,
    required bool isSelected,
  }) toggleSelection;

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xff3C3C3C);
    const valueColor = Color(0xff8E8E8E);
    final theme = context.rlTheme;
    final country = CountryCode.fromCountryCode(countryCode);
    final countryName = country.name ?? "";

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: GestureDetector(
        onTap: isEditing
            ? () => toggleSelection(countryCode: countryCode, isSelected: !isSelected)
            : () {
                context.pushNamed(
                  ScreenNames.residenceDetails2,
                  extra: countryCode,
                );
              },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 1),
          color: Colors.white.withValues(alpha: 0.0001),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(begin: 0, end: isEditing ? 1 : 0),
                      builder: (context, value, child) {
                        return SizedBox(
                          width: value * 45,
                          height: 45,
                          child: Transform.translate(
                            offset: Offset(-40 * (1 - value), 0),
                            child: Opacity(
                              opacity: value.clamp(0.0, 1.0),
                              child: OverflowBox(
                                minWidth: 45,
                                maxWidth: 45,
                                minHeight: 45,
                                maxHeight: 45,
                                child: child,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: SizedBox.square(
                          dimension: 45,
                          child: Center(
                            child: RlCheckbox(
                              value: isSelected,
                              onToggle: (value) => toggleSelection(countryCode: countryCode, isSelected: value),
                            ),
                          ),
                        ),
                      ),
                    ),
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(
                        begin: 0,
                        end: isEditing ? 1 : 0,
                      ),
                      builder: (context, value, child) {
                        return Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    countryName,
                                    style: theme.body12M.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Gap(4),
                                  Flexible(
                                    child: Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: context.theme.colorScheme.tertiary.withValues(alpha: 0.5),
                                      ),
                                      "$daysSpent / 183 ${S.of(context).homeDays}",
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(6),
                              TweenAnimationBuilder(
                                duration: 2.seconds,
                                tween: Tween<double>(
                                  begin: 1.0,
                                  end: (daysSpent / 183).clamp(0.0, 1.0),
                                ),
                                curve: Curves.fastEaseInToSlowEaseOut,
                                builder: (context, v, child) {
                                  return LinearProgressIndicator(
                                    minHeight: 8,
                                    borderRadius: BorderRadius.circular(8),
                                    value: v,
                                    backgroundColor: backgroundColor,
                                    valueColor: const AlwaysStoppedAnimation(valueColor),
                                  ).animate().shimmer(
                                    duration: 1.seconds,
                                    delay: 1.seconds,
                                    stops: [1.0, 0.5, 0.0],
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(begin: 0, end: isEditing ? 1 : 0),
                      builder: (context, value, child) {
                        return SizedBox(
                          width: value * 45,
                          height: 45,
                          child: Transform.translate(
                            offset: Offset(45 * (1 - value), 0),
                            child: Opacity(
                              opacity: value.clamp(0.0, 1.0),
                              child: OverflowBox(
                                minWidth: 45,
                                maxWidth: 45,
                                minHeight: 45,
                                maxHeight: 45,
                                child: child,
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 12.0),
                        child: SizedBox.square(
                          dimension: 45,
                          child: Center(
                            child: AppAssetImage(
                              AppAssets.burger,
                              width: 30,
                              color: Color(0xff8E8E8E),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(16),
              if (!isLast)
                Divider(
                  color: context.theme.colorScheme.surface,
                  height: 2,
                  thickness: 2,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
