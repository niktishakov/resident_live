import "package:collection/collection.dart";
import "package:country_code_picker/country_code_picker.dart";
import "package:domain/domain.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:gap/gap.dart";
import "package:get_it/get_it.dart";
import "package:google_fonts/google_fonts.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/localization/generated/l10n/l10n.dart";
import "package:resident_live/screens/home/cubit/focus_on_country_cubit.dart";
import "package:resident_live/screens/splash/cubit/get_user_cubit.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";
import "package:resident_live/shared/lib/utils/hero_utils.dart";
import "package:resident_live/shared/shared.dart";
import "package:resident_live/shared/widget/rl.outlined_button.dart";

part "country_card/country_card.dart";
part "set_focus_button.dart";
part "country_card/country_progress_indicator.dart";

class FocusedCountryView extends StatefulWidget {
  const FocusedCountryView({
    required this.onTap,
    super.key,
  });
  final Function(String) onTap;

  @override
  State<FocusedCountryView> createState() => _FocusedCountryViewState();
}

class _FocusedCountryViewState extends State<FocusedCountryView> {
  late PageController _pageController;
  late String _currentPageCountryCode;
  late List<String> _countries;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    final user = GetIt.I<GetUserCubit>().state.data;
    final countries = user?.countries;
    final focusedCountryCode = user?.focusedCountryCode;
    _countries = countries?.keys.toList() ?? [];

    _currentPageCountryCode = countries?.keys.firstWhereOrNull((c) => c == focusedCountryCode) ?? "";
    _currentPage = countries?.keys.toList().indexOf(_currentPageCountryCode) ?? 0;
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final beginBorderRadius = BorderRadius.circular(24);
    return BlocBuilder<GetUserCubit, ResourceState<UserEntity>>(
      bloc: getIt<GetUserCubit>(),
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Material(
            borderRadius: beginBorderRadius,
            elevation: 0,
            color: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: context.mediaQuery.size.width,
              ),
              child: RlCard(
                gradient: kMainGradient,
                borderRadius: beginBorderRadius.topLeft.x,
                padding: const EdgeInsets.only(left: 0, right: 0, top: 16, bottom: 8),
                child: SizedBox(
                  height: 280,
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                              _currentPageCountryCode = _countries[index];
                            });
                          },
                          itemCount: _countries.length,
                          restorationId: "FocusedCountryViewPageView",
                          itemBuilder: (context, index) {
                            final countryCode = _countries[index];
                            final isHere = state.data?.isHere(countryCode) ?? false;

                            return Hero(
                              tag: "residence_$countryCode",
                              flightShuttleBuilder: (
                                flightContext,
                                animation,
                                flightDirection,
                                fromHeroContext,
                                toHeroContext,
                              ) =>
                                  toFirstHeroFlightShuttleBuilder(
                                flightContext: flightContext,
                                animation: animation,
                                flightDirection: flightDirection,
                                fromHeroContext: fromHeroContext,
                                toHeroContext: toHeroContext,
                                beginBorderRadius: beginBorderRadius.topLeft.x,
                                endBorderRadius: kLargeBorderRadius,
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: CountryCard(
                                  countryCode: countryCode,
                                  isHere: isHere,
                                  onTap: widget.onTap,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const Gap(8),
                      AnimatedDots(
                        value: _currentPage,
                        maxValue: _countries.length,
                        radius: 3,
                        padding: 3,
                        activeColor: context.theme.primaryColor,
                        inactiveColor: context.theme.colorScheme.secondary.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
