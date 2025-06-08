import "package:domain/domain.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:gap/gap.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import "package:resident_live/app/init_app.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/screens/home/cubit/focus_on_country_cubit.dart";
import "package:resident_live/screens/home/cubit/home_cubit.dart";
import "package:resident_live/screens/home/widgets/countries/countries_page_view.dart";
import "package:resident_live/screens/home/widgets/header/sliver_header.dart";
import "package:resident_live/screens/home/widgets/map_preview/map_preview.dart";
import "package:resident_live/screens/home/widgets/re_enter_periods/re_enter_periods_button.dart";
import "package:resident_live/screens/home/widgets/week_line_view.dart";
import "package:resident_live/screens/residence_details/residence_details_screen.dart";
import "package:resident_live/screens/splash/cubit/get_user_cubit.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";
import "package:resident_live/shared/lib/utils/debug_actions_sheet.dart";
import "package:resident_live/shared/lib/utils/route_utils.dart";
import "package:resident_live/shared/shared.dart";

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
      buildWhen: (previous, current) =>
          previous.data?.focusedCountryCode != current.data?.focusedCountryCode ||
          previous.data?.countries != current.data?.countries ||
          previous.data?.stayPeriods != current.data?.stayPeriods,
      builder: (context, state) {
        final focusedCountryCode = state.data?.focusedCountryCode;
        final otherResidences = state.data?.countries;
        otherResidences?.removeWhere((key, value) => key == focusedCountryCode);
        final stayPeriods = state.data?.stayPeriods ?? [];

        return MultiBlocListener(
          listeners: [
            BlocListener<FocusOnCountryCubit, ResourceState<UserEntity>>(
              bloc: getIt<FocusOnCountryCubit>(),
              listener: _onFocusOnCountryListen,
            ),
            BlocListener<GetUserCubit, ResourceState<UserEntity>>(listener: _onGetUserListen),
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
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: HomeSliverHeader(
                        expandedHeight: 90.0 + context.mediaQuery.viewPadding.top,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: WeekLineView(),
                      ),
                    ),
                    const SliverPadding(padding: EdgeInsets.only(top: 16)),
                    if (focusedCountryCode != null) ...[
                      SliverToBoxAdapter(
                        child: RepaintBoundary(
                          child: CountriesPageView(
                            countries: state.data?.countries ?? {},
                            currentCountryCode: state.data?.currentCountryCode() ?? "",
                            focusedCountryCode: focusedCountryCode,
                            onTap: (countryCode) => navigatorKey.currentContext?.navigator.push(
                              kDefaultFadeRouteBuilder(
                                page: ResidenceDetailsScreen(countryCode: countryCode),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SliverPadding(padding: EdgeInsets.only(top: 8)),
                    ],

                    const SliverToBoxAdapter(child: ReEnterPeriodsButton()),
                    SliverToBoxAdapter(
                      child: RepaintBoundary(child: MapPreview(stayPeriods: stayPeriods)),
                    ),
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
