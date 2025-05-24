import "package:domain/domain.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:gap/gap.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import "package:resident_live/app/init_app.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/screens/all_countries/all_countries_screen.dart";
import "package:resident_live/screens/home/cubit/focus_on_country_cubit.dart";
import "package:resident_live/screens/home/cubit/home_cubit.dart";
import "package:resident_live/screens/home/widgets/focused_country/focused_country_page_view.dart";
import "package:resident_live/screens/home/widgets/greeting_view.dart";
import "package:resident_live/screens/home/widgets/tracking_residences/tracking_residences.dart";
import "package:resident_live/screens/home/widgets/week_line_view.dart";
import "package:resident_live/screens/residence_details/residence_details_screen.dart";
import "package:resident_live/screens/splash/cubit/get_user_cubit.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";
import "package:resident_live/shared/lib/utils/debug_actions_sheet.dart";
import "package:resident_live/shared/lib/utils/route_utils.dart";
import "package:resident_live/shared/shared.dart";
import "package:resident_live/shared/widget/today_button.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getIt<HomeCubit>().requestPushPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserCubit, ResourceState<UserEntity>>(
      bloc: getIt<GetUserCubit>(),
      builder: (context, state) {
        final focusedCountryCode = state.data?.focusedCountryCode;
        final otherResidences = state.data?.countries;
        otherResidences?.removeWhere((key, value) => key == focusedCountryCode);

        return MultiBlocListener(
          listeners: [
            BlocListener<FocusOnCountryCubit, ResourceState<UserEntity>>(
              bloc: getIt<FocusOnCountryCubit>(),
              listener: _onFocusOnCountryListen,
            ),
            BlocListener<GetUserCubit, ResourceState<UserEntity>>(
              bloc: getIt<GetUserCubit>(),
              listener: _onGetUserListen,
            ),
          ],
          child: GestureDetector(
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
                    if (focusedCountryCode != null) ...[
                      SliverToBoxAdapter(
                        child: RepaintBoundary(
                          child: SizedBox(
                            height: 320,
                            child: FocusedCountryView(
                              onTap:
                                  (countryCode) => navigatorKey.currentContext?.navigator.push(
                                    kDefaultFadeRouteBuilder(
                                      page: ResidenceDetailsScreen(countryCode: countryCode),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (otherResidences != null && otherResidences.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: OtherResidencesView(
                          residences: otherResidences,
                          onTap:
                              () => navigatorKey.currentContext?.navigator.push(
                                kDefaultFadeRouteBuilder(page: const AllCountriesScreen()),
                              ),
                        ),
                      ),
                    ],
                    SliverToBoxAdapter(child: Gap(context.mediaQuery.padding.bottom + 64)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onFocusOnCountryListen(BuildContext context, ResourceState<UserEntity> state) {}
  void _onGetUserListen(BuildContext context, ResourceState<UserEntity> state) {}
}

class CustomSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  CustomSliverHeaderDelegate({required this.expandedHeight});
  final double expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 44;

  @override
  double get maxExtent => expandedHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = context.rlTheme;
    final proportion = (expandedHeight - shrinkOffset) / expandedHeight;

    // Calculate the title size based on the scroll proportion

    // Divider opacity - 0.0 when fully expanded, 1.0 when fully collapsed
    final dividerOpacity = 1 - proportion;

    return ClipRect(
      child: ColoredBox(
        color: theme.bgPrimary.withValues(alpha: dividerOpacity.clamp(0.0, 1.0)),
        child: Stack(
          children: [
            const Positioned(left: 24, bottom: 12.0, child: GreetingView()),
            Positioned(
              bottom: 12.0,
              right: 24,
              child: Opacity(
                opacity: dividerOpacity > 0.4 ? (3.5 * dividerOpacity - 1.0).clamp(0.0, 1.0) : 0.0,
                child: TodayButton(
                  onTap: () {},
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
                color: context.theme.dividerColor.withValues(alpha: dividerOpacity),
                height: 2.0,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
