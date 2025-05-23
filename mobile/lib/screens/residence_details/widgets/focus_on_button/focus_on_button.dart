import "package:flutter/cupertino.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/localization/generated/l10n/l10n.dart";
import "package:resident_live/screens/home/cubit/focus_on_country_cubit.dart";
import "package:resident_live/shared/shared.dart";
import "package:resident_live/shared/widget/transparent_button.dart";

class FocusOnButton extends StatelessWidget {
  const FocusOnButton({
    required this.isFocused,
    required this.countryCode,
    super.key,
  });

  final bool isFocused;
  final String countryCode;
  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      tween: Tween<double>(
        begin: 0,
        end: isFocused ? 0 : 1,
      ),
      builder: (context, value, child) {
        return SizedBox(
          height: value * 40,
          child: Transform.translate(
            offset: Offset(-20 * (1 - value), 0),
            child: Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: child,
            ),
          ),
        );
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: TransparentButton(
          leading: AppAssetImage(
            AppAssets.target,
            width: 24,
            color: context.theme.colorScheme.secondary,
          ),
          onPressed: () {
            getIt<FocusOnCountryCubit>().loadResource(countryCode);
          },
          child: Text(
            S.of(context).detailsFocusOnThisCountry,
            style: theme.body14.copyWith(
              fontWeight: FontWeight.w300,
              color: theme.textPrimary,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 700.ms);
  }
}
