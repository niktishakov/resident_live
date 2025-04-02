import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:gap/gap.dart";
import "package:go_router/go_router.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import "package:resident_live/app/main.dart";
import "package:resident_live/features/features.dart";
import "package:resident_live/screens/all_countries/ui/all_countries_screen.dart";
import "package:resident_live/screens/home/ui/widgets/focused_country_view.dart";
import "package:resident_live/screens/home/ui/widgets/greeting_view.dart";
import "package:resident_live/screens/home/ui/widgets/tracking_residences.dart";
import "package:resident_live/screens/screens.dart";
import "package:resident_live/shared/shared.dart";
import "package:resident_live/widgets/widgets.dart";
import "package:shared_preferences/shared_preferences.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _showLastStoredLocation(BuildContext context) async {
    final position = await GeolocationService.instance.getLastStoredPosition();
    if (position != null) {
      final lastUpdate = await SharedPreferences.getInstance().then(
          (prefs) => prefs.getInt(GeolocationService.LAST_UPDATE_TIME_KEY),);

      final lastUpdateStr = lastUpdate != null
          ? DateTime.fromMillisecondsSinceEpoch(lastUpdate).toString()
          : "unknown";

      ToastService.instance.showToast(
        context,
        message:
            "Last stored location:\nLat: ${position.latitude.toStringAsFixed(4)}\n"
            "Lng: ${position.longitude.toStringAsFixed(4)}\n"
            "Time: $lastUpdateStr",
        status: ToastStatus.warning,
      );
    } else {
      ToastService.instance.showToast(
        context,
        message: "No stored location found",
        status: ToastStatus.warning,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountriesCubit, CountriesState>(
      builder: (context, state) {
        final locationState = context.watch<LocationCubit>().state;
        final focusedCountry =
            context.watch<CountriesCubit>().state.focusedCountry;

        final otherResidences = state.countries.values
            .where((e) => e.isoCode != focusedCountry?.isoCode)
            .toList();

        return BlocListener<CountriesCubit, CountriesState>(
          listener: (context, state) {
            if (state.countries.isEmpty) {
              context.goNamed(ScreenNames.onboarding);
            }
          },
          child: GestureDetector(
            onTap: () => _showLastStoredLocation(context),
            onLongPress: () {
              if (kDebugMode) {
                showDebugActionsSheet(context);
              }
            },
            child: CupertinoScaffold(
              overlayStyle: getSystemOverlayStyle,
              body: Material(
                child: CustomScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  slivers: [
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: CustomSliverHeaderDelegate(
                        expandedHeight: 90.0 + context.mediaQuery.padding.top,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: WeekLineView(),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: RepaintBoundary(
                        child: SizedBox(
                          height: 320,
                          child: FocusedCountryView(
                            focusedCountry: focusedCountry,
                            onTap: (country) =>
                                navigatorKey.currentContext?.navigator.push(
                              kDefaultFadeRouteBuilder(
                                page: ResidenceDetailsScreen(
                                  name: country.name,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (otherResidences.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: OtherResidencesView(
                          residences: otherResidences,
                          onTap: () =>
                              navigatorKey.currentContext?.navigator.push(
                            kDefaultFadeRouteBuilder(
                              page: const AllCountriesScreen(),
                            ),
                          ),
                        ),
                      ),
                    ],
                    SliverToBoxAdapter(
                        child: Gap(context.mediaQuery.padding.bottom + 64),),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomSliverHeaderDelegate extends SliverPersistentHeaderDelegate {

  CustomSliverHeaderDelegate({required this.expandedHeight});
  final double expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 44;

  @override
  double get maxExtent => expandedHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent,) {
    final proportion = (expandedHeight - shrinkOffset) / expandedHeight;
    const largeSize = 32.0;
    const smallSize = 18.0;

    // Calculate the title size based on the scroll proportion
    final titleSize = (largeSize * proportion).clamp(smallSize, largeSize);

    // Calculate the horizontal position from left to center
    final titleLeftPadding =
        0.0 + (MediaQuery.of(context).size.width / 4 - 0.0) * (1 - proportion);

    // Divider opacity - 0.0 when fully expanded, 1.0 when fully collapsed
    final dividerOpacity = 1 - proportion;

    return ClipRect(
      child: ColoredBox(
        color: context.theme.scaffoldBackgroundColor,
        child: ColoredBox(
          color: context.theme.dialogBackgroundColor
              .withOpacity(dividerOpacity.clamp(0.0, 1.0)),
          child: Stack(
            children: [
              const Positioned(
                left: 24,
                bottom: 12.0,
                child: GreetingView(),
              ),
              Positioned(
                bottom: 12.0,
                right: 24,
                child: Opacity(
                  opacity: dividerOpacity > 0.4
                      ? (3.5 * dividerOpacity - 1.0).clamp(0.0, 1.0)
                      : 0.0,
                  child: TodayButton(
                    onTap: () {
                      CupertinoScaffold.showCupertinoModalBottomSheet(
                        context: context,
                        duration: 400.ms,
                        animationCurve: Curves.fastEaseInToSlowEaseOut,
                        builder: (context) => const VerticalTimeline(),
                      );
                    },
                    iconSize: 20,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.theme.colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: context.theme.dividerColor.withOpacity(dividerOpacity),
                  height: 2.0,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
