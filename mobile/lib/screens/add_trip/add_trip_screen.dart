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
    final title = trips > 0 ? "Add a New Trip" : "Add Your First Trip";

    return Material(
      child: Scaffold(
        backgroundColor: theme.bgPrimary,
        body: BlocListener<AddTripCubit, AddTripState>(
          listener: (context, state) {
            // Показываем ошибки валидации
            if (state.validationError.isNotEmpty) {
              ToastService.instance.showToast(
                context,
                message: state.validationError,
                status: ToastStatus.failure,
              );
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
                      previousPageTitle: "Trips",
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
                  // Показываем ошибку валидации под кнопкой
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
                  return SafeArea(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
                        child: PrimaryButton(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          label: "Evaluate Risks",
                          fontSize: 16,
                          enabled: isValid,
                          expanded: true,
                          onPressed: isValid
                              ? () {
                                  final cubit = find<AddTripCubit>(context);
                                  if (cubit.canProceedToValidation()) {
                                    context.pushNamed(
                                      ScreenNames.validateTrip,
                                      extra: cubit.state.trip,
                                    );
                                  }
                                }
                              : null, // Блокируем кнопку если данные невалидны
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
