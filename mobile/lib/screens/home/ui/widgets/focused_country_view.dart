import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:resident_live/domain/domain.dart";
import "package:resident_live/features/features.dart";
import "package:resident_live/generated/l10n/l10n.dart";
import "package:resident_live/shared/shared.dart";

class FocusedCountryView extends StatefulWidget {
  const FocusedCountryView({
    required this.onTap, super.key,
    this.focusedCountry,
  });
  final CountryEntity? focusedCountry;
  final Function(CountryEntity) onTap;

  @override
  State<FocusedCountryView> createState() => _FocusedCountryViewState();
}

class _FocusedCountryViewState extends State<FocusedCountryView> {
  late PageController _pageController;
  late CountryEntity _currentPageCountry;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    final countries =
        context.read<CountriesCubit>().state.countries.values.toList();
    _currentPageCountry = countries.firstWhere(
      (c) => c.isoCode == widget.focusedCountry?.isoCode,
      orElse: () => countries.first,
    );
    _currentPage = countries.indexOf(_currentPageCountry);
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LocationCubit>().state;
    final countries =
        context.watch<CountriesCubit>().state.countries.values.toList();

    final beginBorderRadius = BorderRadius.circular(24);
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
            borderRadius: beginBorderRadius,
            padding:
                const EdgeInsets.only(left: 0, right: 0, top: 16, bottom: 8),
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
                          _currentPageCountry = countries[index];
                        });
                      },
                      itemCount: countries.length,
                      restorationId: "FocusedCountryViewPageView",
                      itemBuilder: (context, index) {
                        final country = countries[index];
                        final isHere =
                            state.isCurrentResidence(country.isoCode);
                        final isFocused =
                            country.isoCode == widget.focusedCountry?.isoCode;
                        return Hero(
                          tag: "residence_${country.name}",
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
                            endBorderRadius: kLargeBorderRadius.topLeft.x,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: FocusedCountryCard(
                              country: country,
                              isHere: isHere,
                              isFocused: isFocused,
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
                    maxValue: countries.length,
                    radius: 3,
                    padding: 3,
                    activeColor: context.theme.primaryColor,
                    inactiveColor:
                        context.theme.colorScheme.secondary.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FocusedCountryCard extends StatelessWidget {
  const FocusedCountryCard({
    required this.country, required this.isHere, required this.isFocused, required this.onTap, super.key,
  });

  final CountryEntity country;
  final bool isHere;
  final bool isFocused;
  final Function(CountryEntity) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(country),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    SizedBox(
                      width: constraints.maxWidth * 0.5,
                      child: AnimatedCrossFade(
                        firstChild: Text(
                          S.of(context).homeYourFocus,
                          style: context.rlTheme.body14,
                        ),
                        secondChild: GestureDetector(
                          onTap: () => find<CountriesCubit>(context)
                              .setFocusedCountry(country),
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
                          )
                              .animate()
                              .shimmer(duration: 1.seconds, delay: 1.seconds),
                        ),
                        crossFadeState: isFocused
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 300),
                      ),
                    ),
                    const Spacer(),
                    if (isHere) const Here(),
                  ],
                );
              },
            ),
            Text(
              country.name,
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            _buildProgressIndicator(context, country),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, CountryEntity country) {
    final backgroundColor = country.isResident
        ? context.theme.primaryColor
        : context.theme.colorScheme.tertiary;
    final color = context.theme.primaryColor;
    final value = country.isResident ? 183 : country.daysSpent;
    final progress = (value / 183).clamp(0, 1.0);
    // final progress = 1.0;

    return LayoutBuilder(
      builder: (context, ctrx) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${country.daysSpent}/183 ${S.of(context).homeDays}",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: context.theme.colorScheme.secondary.withOpacity(0.5),
              ),
            ),
            const Gap(2),
            Text(
              "${(value / 183 * 100).round()}%",
              style: GoogleFonts.poppins(
                fontSize: 64,
                fontWeight: FontWeight.w500,
                color: context.theme.colorScheme.secondary,
                height: 57 / 64,
              ),
            ),
            const Gap(16),
            Container(
              width: ctrx.maxWidth,
              height: 62,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: DiagonalProgressBar(
                  progress: progress.toDouble(),
                  isAnimationEnabled: isHere,
                ),
              ),
            ),
            const Gap(8),
          ],
        );
      },
    );
  }
}
