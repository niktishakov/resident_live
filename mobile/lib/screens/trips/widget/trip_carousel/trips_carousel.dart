import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/screens/trips/cubit/delete_trip_cubit.dart";
import "package:resident_live/screens/trips/cubit/trips_stream_cubit.dart";
import "package:resident_live/screens/trips/widget/empty_trips/empty_trips_list.dart";
import "package:resident_live/screens/trips/widget/trip_carousel/tabs_bar.dart";
import "package:resident_live/screens/trips/widget/trip_carousel/trip_carousel_card.dart";
import "package:resident_live/shared/shared.dart";
import "package:resident_live/shared/widget/rl.sliver_header.dart";
import "package:resident_live/shared/widget/transparent_button.dart";

enum TripFilter { all, current, coming, completed }

class TripsCarousel extends StatefulWidget {
  const TripsCarousel({super.key});

  @override
  State<TripsCarousel> createState() => _TripsCarouselState();
}

class _TripsCarouselState extends State<TripsCarousel> {
  TripFilter selectedFilter = TripFilter.all;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripsStreamCubit, List<TripEntity>>(
      builder: (context, trips) {
        final filteredTrips = _filterTrips(trips);

        if (trips.isEmpty) {
          return const SliverToBoxAdapter(child: EmptyTripsList());
        }

        return CustomScrollView(
          slivers: [
            const AiSliverHeader(titleText: "Trips", showBackButton: false),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabsBar(
                    selectedFilter: selectedFilter,
                    onSelected: (filter) => setState(() => selectedFilter = filter),
                  ),
                  SizedBox(
                    height: context.mediaQuery.size.height * 0.55,
                    child: filteredTrips.isEmpty
                        ? Center(
                            child: Text(
                              _getEmptyMessage(),
                              style: context.rlTheme.body14.copyWith(
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                          )
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: filteredTrips.length,
                            separatorBuilder: (context, index) => context.hBox12,
                            itemBuilder: (context, index) {
                              final trip = filteredTrips[index];
                              return TripCarouselCard(
                                trip: trip,
                                onTap: () => _onTripTap(context, trip),
                                onDelete: () => _onTripDelete(context, trip),
                              );
                            },
                          ),
                  ),
                  context.vBox12,
                  // Add trip button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Center(
                      child: TransparentButton(
                        alignment: Alignment.center,
                        onPressed: () => context.pushNamed(ScreenNames.addTrip),
                        leading: const Icon(CupertinoIcons.add, color: Colors.white, size: 20),
                        child: Text(
                          "Add Trip",
                          style: context.rlTheme.body14.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<TripEntity> _filterTrips(List<TripEntity> trips) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (selectedFilter) {
      case TripFilter.all:
        return trips;
      case TripFilter.current:
        return trips.where((trip) {
          final fromDate = DateTime(trip.fromDate.year, trip.fromDate.month, trip.fromDate.day);
          final toDate = DateTime(trip.toDate.year, trip.toDate.month, trip.toDate.day);
          return today.isAtSameMomentAs(fromDate) ||
              today.isAtSameMomentAs(toDate) ||
              (today.isAfter(fromDate) && today.isBefore(toDate));
        }).toList();
      case TripFilter.coming:
        return trips.where((trip) {
          final fromDate = DateTime(trip.fromDate.year, trip.fromDate.month, trip.fromDate.day);
          return today.isBefore(fromDate);
        }).toList();
      case TripFilter.completed:
        return trips.where((trip) {
          final toDate = DateTime(trip.toDate.year, trip.toDate.month, trip.toDate.day);
          return today.isAfter(toDate);
        }).toList();
    }
  }

  String _getEmptyMessage() {
    switch (selectedFilter) {
      case TripFilter.all:
        return "No trips available";
      case TripFilter.current:
        return "No current trips";
      case TripFilter.coming:
        return "No upcoming trips";
      case TripFilter.completed:
        return "No completed trips";
    }
  }

  void _onTripTap(BuildContext context, TripEntity trip) {
    context.pushNamed(ScreenNames.tripDetails, extra: trip);
  }

  void _onTripDelete(BuildContext context, TripEntity trip) {
    context.read<DeleteTripCubit>().loadResource(trip.id);
  }
}
