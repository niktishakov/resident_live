import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:gap/gap.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/screens/map/cubit/country_bg_cubit.dart";
import "package:resident_live/screens/trips/model/trip_model.dart";
import "package:resident_live/screens/validate_trip/cubit/save_trip_cubit.dart";
import "package:resident_live/screens/validate_trip/widget/stay_limit/stay_limits_analysis.dart";
import "package:resident_live/screens/validate_trip/widget/trip_card/trip_card.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";
import "package:resident_live/shared/lib/service/toast.service.dart";
import "package:resident_live/shared/lib/utils/dependency_squirrel.dart";
import "package:resident_live/shared/shared.dart";

class ValidateTripScreen extends StatelessWidget {
  const ValidateTripScreen({required this.trip, super.key});
  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return BlocProvider(
      create: (c) => getIt<CountryBackgroundCubit>(),
      child: Material(
        // color: theme.bgPrimary,
        child: Scaffold(
          backgroundColor: theme.bgPrimary,
          body: BlocListener<SaveTripCubit, ResourceState<Result<TripEntity>>>(
            listener: _handleSaveTripState,
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    CupertinoSliverNavigationBar(
                      backgroundColor: theme.bgPrimary,
                      padding: EdgeInsetsDirectional.zero,
                      leading: CupertinoNavigationBarBackButton(
                        previousPageTitle: "Add Trip",
                        color: theme.textAccent,
                        onPressed: () => context.pop(),
                      ),
                      largeTitle: Text(
                        "Trip to",
                        style: theme.title24Semi.copyWith(color: theme.textPrimary),
                      ),
                      alwaysShowMiddle: false,
                      middle: Text(
                        "Trip to",
                        style: theme.body16.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.textPrimary,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TripCard(trip: trip),
                            context.vBox24,
                            StayLimitsAnalysis(trip: trip),
                            Gap(150),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                _buildSaveButton(context, theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSaveTripState(BuildContext context, ResourceState<Result<TripEntity>> state) {
    final theme = context.rlTheme;

    state.maybeWhen(
      orElse: () {},
      data: (data) => _handleSuccessState(context, theme),
      error: (error, stackTrace) => _handleErrorState(context, theme, error!),
    );
  }

  void _handleSuccessState(BuildContext context, RlTheme theme) {
    ToastService.instance.showToast(
      context,
      message: "Trip saved successfully!",
      status: ToastStatus.success,
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) {
        context.go("${ScreenNames.trips}?scrollTo=${trip.toEntity().id}");
      }
    });
  }

  void _handleErrorState(BuildContext context, RlTheme theme, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.toString()),
        backgroundColor: theme.bgDanger,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, RlTheme theme) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.bgPrimary.withOpacity(0.0),
              theme.bgPrimary.withOpacity(0.8),
              theme.bgPrimary,
              theme.bgPrimary,
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16, top: 40),
            child: BlocBuilder<CountryBackgroundCubit, CountryBackgroundState>(
              builder: (context, bgState) {
                return PrimaryButton(
                  label: "Save trip",
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  onPressed: () {
                    // Get current background URL from cubit
                    String? backgroundUrl;
                    bgState.whenOrNull(
                      loaded: (countryImages) {
                        backgroundUrl = countryImages[trip.countryCode];
                      },
                    );

                    // Create trip with background URL
                    final tripWithBackground = trip.copyWith(backgroundUrl: backgroundUrl);
                    find<SaveTripCubit>(context).loadResource(tripWithBackground);
                  },
                  expanded: true,
                  textStyle: theme.body16M.copyWith(
                    color: theme.textPrimaryOnColor,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
