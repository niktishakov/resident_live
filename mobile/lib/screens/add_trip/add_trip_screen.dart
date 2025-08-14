import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/screens/add_trip/cubit/add_trip_cubit.dart";
import "package:resident_live/screens/add_trip/widget/country_dropdown/country_dropdown.dart";
import "package:resident_live/screens/add_trip/widget/trip_stay_period.dart";
import "package:resident_live/screens/trips/cubit/trips_stream_cubit.dart";
import "package:resident_live/screens/trips/model/trip_model.dart";
import "package:resident_live/shared/lib/service/toast.service.dart";
import "package:resident_live/shared/lib/utils/dependency_squirrel.dart";
import "package:resident_live/shared/shared.dart";

class AddTripScreen extends StatelessWidget {
  const AddTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    final trips = context.watch<TripsStreamCubit>().state.length;
    final isEditMode = context.watch<AddTripCubit>().state.isEditMode;

    final previousPageTitle = isEditMode ? "Back" : "Trips";
    final title = isEditMode
        ? "Edit Trip"
        : trips > 0
        ? "Add a New Trip"
        : "Add Your First Trip";

    return Material(
      child: Scaffold(
        backgroundColor: theme.bgPrimary,
        body: BlocListener<AddTripCubit, AddTripState>(
          listener: (context, state) {
            // Show only success messages in toast, errors will be shown in UI
            if (state.isSuccess) {
              ToastService.instance.showToast(
                context,
                message: isEditMode ? "Trip updated successfully" : "Trip saved successfully",
                status: ToastStatus.success,
              );

              // Handle navigation after successful save
              if (state.isEditMode) {
                // For edit mode, replace current route with trip details with updated data
                context.pop(); // Pop edit screen
                context.pushReplacementNamed(ScreenNames.tripDetails, extra: state.trip.toEntity());
              }
            }
          },
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  CupertinoSliverNavigationBar(
                    backgroundColor: theme.bgPrimary,
                    padding: EdgeInsetsDirectional.zero,
                    leading: CupertinoNavigationBarBackButton(
                      previousPageTitle: previousPageTitle,
                      color: theme.textAccent,
                      onPressed: () {
                        context.pop();
                      },
                    ),
                    middle: Text(
                      title,
                      style: theme.body16.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.textPrimary,
                      ),
                    ),
                    alwaysShowMiddle: false,
                    largeTitle: Text(
                      title,
                      style: theme.body22.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: theme.textPrimary,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: context.vBox32),
                  const SliverToBoxAdapter(child: Column(children: [CountryDropdown()])),
                  SliverToBoxAdapter(child: context.vBox32),
                  const SliverToBoxAdapter(child: Column(children: [TripStayPeriod()])),
                  SliverToBoxAdapter(child: context.vBox32),
                  // Show validation error in UI
                  SliverToBoxAdapter(
                    child: BlocBuilder<AddTripCubit, AddTripState>(
                      builder: (context, state) {
                        if (state.validationError.isEmpty) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            state.validationError,
                            style: theme.body14.copyWith(color: theme.bgDanger),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(child: context.vBox32),
                ],
              ),
              BlocBuilder<AddTripCubit, AddTripState>(
                builder: (context, state) {
                  final isValid = state.trip.isValid;
                  final isLoading = state.isLoading;

                  return SafeArea(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
                        child: PrimaryButton(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          label: isEditMode ? "Save Changes" : "Evaluate Risks",
                          fontSize: 16,
                          enabled: isValid && !isLoading,
                          expanded: true,
                          onPressed: isValid && !isLoading
                              ? () {
                                  final cubit = find<AddTripCubit>(context);
                                  if (isEditMode) {
                                    cubit.saveTrip(cubit.state.trip);
                                  } else {
                                    if (cubit.canProceedToValidation()) {
                                      context.pushNamed(
                                        ScreenNames.validateTrip,
                                        extra: cubit.state.trip,
                                      );
                                    }
                                  }
                                }
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
