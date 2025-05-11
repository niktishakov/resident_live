part of "focused_country_page_view.dart";

class SetFocusButton extends StatelessWidget {
  const SetFocusButton({
    required this.countryCode,
    required this.isFocused,
    super.key,
  });

  final String countryCode;
  final bool isFocused;
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: Text(
        S.of(context).homeYourFocus,
        style: context.rlTheme.body14,
      ),
      secondChild: GestureDetector(
        onTap: () => getIt<FocusOnCountryCubit>().loadResource(countryCode),
        behavior: HitTestBehavior.opaque,
        child: PrimaryButton(
          behavior: HitTestBehavior.opaque,
          label: S.of(context).homeSetFocus,
          fontSize: 12,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: const AppAssetImage(
            AppAssets.target,
            height: 14,
          ),
        ).animate().shimmer(duration: 1.seconds, delay: 1.seconds),
      ),
      crossFadeState: isFocused ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300),
    );
  }
}
