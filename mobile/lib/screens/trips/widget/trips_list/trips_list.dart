import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:gap/gap.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/screens/trips/cubit/delete_trip_cubit.dart";
import "package:resident_live/screens/trips/cubit/trips_stream_cubit.dart";
import "package:resident_live/screens/trips/widget/empty_trips/empty_trips_list.dart";
import "package:resident_live/screens/trips/widget/trips_list/trip_item.dart";
import "package:resident_live/shared/shared.dart";
import "package:resident_live/shared/widget/rl.outlined_button.dart";
import "package:resident_live/shared/widget/rl.sliver_header.dart";

class TripsList extends StatelessWidget {
  const TripsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripsStreamCubit, List<TripEntity>>(
      builder: (context, trips) {
        if (trips.isEmpty) {
          return const SliverToBoxAdapter(child: EmptyTripsList());
        }

        return CustomScrollView(
          slivers: [
            const AiSliverHeader(titleText: "Trips", showBackButton: false),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final trip = trips[index];
                  return Padding(
                    key: ValueKey(trip.id),
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: TripItem(
                      trip: trip,
                      onTap: () => _onTripTap(context, trip),
                      onDelete: () => _onTripDelete(context, trip),
                    ),
                  );
                }, childCount: trips.length),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RlOutlinedButton(
                  onPressed: () => context.pushNamed(ScreenNames.addTrip),
                  label: "Add Trip",
                  leading: const Icon(CupertinoIcons.add, color: Colors.white, size: 20),
                  expanded: true,
                  textStyle: context.rlTheme.body14.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: Gap(120)),
          ],
        );
      },
    );
  }

  void _onTripTap(BuildContext context, TripEntity trip) {
    // Навигация к деталям поездки или редактированию
    // context.push('/trip-details', extra: trip);
  }

  void _onTripDelete(BuildContext context, TripEntity trip) {
    context.read<DeleteTripCubit>().loadResource(trip.id);
  }
}
