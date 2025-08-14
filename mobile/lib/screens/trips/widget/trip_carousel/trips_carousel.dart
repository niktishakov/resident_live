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
  final ScrollController _scrollController = ScrollController();
  String? _lastScrollToTripId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkScrollParameter();
  }

  void _checkScrollParameter() {
    final uri = GoRouterState.of(context).uri;
    final scrollToTripId = uri.queryParameters['scrollTo'];

    // Only process if it's a new scroll target
    if (scrollToTripId != null && scrollToTripId != _lastScrollToTripId) {
      _lastScrollToTripId = scrollToTripId;

      // Switch to ALL tab to make sure we can find the trip
      setState(() {
        selectedFilter = TripFilter.all;
      });

      // Scroll to the trip after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        _scrollToTripById(scrollToTripId);
      });
    }
  }

  void _scrollToTripById(String tripId) {
    final tripsState = context.read<TripsStreamCubit>().state;
    final allTrips = _filterTrips(tripsState); // Get filtered trips for ALL tab
    final tripIndex = allTrips.indexWhere((trip) => trip.id == tripId);

    print("🎯 Looking for trip ID: $tripId");
    print("🎯 Found at index: $tripIndex");
    print("🎯 Total trips: ${allTrips.length}");

    if (tripIndex != -1) {
      // Calculate card width and spacing
      final cardWidth = context.mediaQuery.size.width * 0.9;
      const spacing = 12.0;

      // Calculate target offset
      final targetOffset = (cardWidth + spacing) * tripIndex;

      print("🎯 Scrolling to offset: $targetOffset");

      // Animate to target position
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
                            controller: _scrollController,
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
        // Sort trips by time: closest first, furthest last
        return trips.toList()..sort((a, b) {
          final aFromDate = DateTime(a.fromDate.year, a.fromDate.month, a.fromDate.day);
          final aToDate = DateTime(a.toDate.year, a.toDate.month, a.toDate.day);
          final bFromDate = DateTime(b.fromDate.year, b.fromDate.month, b.fromDate.day);
          final bToDate = DateTime(b.toDate.year, b.toDate.month, b.toDate.day);

          // Check if trips are current
          final aIsCurrent =
              today.isAtSameMomentAs(aFromDate) ||
              today.isAtSameMomentAs(aToDate) ||
              (today.isAfter(aFromDate) && today.isBefore(aToDate));
          final bIsCurrent =
              today.isAtSameMomentAs(bFromDate) ||
              today.isAtSameMomentAs(bToDate) ||
              (today.isAfter(bFromDate) && today.isBefore(bToDate));

          // Current trips go first
          if (aIsCurrent && !bIsCurrent) return -1;
          if (!aIsCurrent && bIsCurrent) return 1;

          // If both are current, sort by start date (earliest first)
          if (aIsCurrent && bIsCurrent) {
            return aFromDate.compareTo(bFromDate);
          }

          // Check if trips are upcoming
          final aIsUpcoming = today.isBefore(aFromDate);
          final bIsUpcoming = today.isBefore(bFromDate);

          // Upcoming trips go after current but before completed
          if (aIsUpcoming && !bIsUpcoming) return -1;
          if (!aIsUpcoming && bIsUpcoming) return 1;

          // If both are upcoming, sort by start date (earliest first)
          if (aIsUpcoming && bIsUpcoming) {
            return aFromDate.compareTo(bFromDate);
          }

          // Both are completed - sort by end date (most recent first)
          return bToDate.compareTo(aToDate);
        });
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
        }).toList()..sort((a, b) {
          final aFromDate = DateTime(a.fromDate.year, a.fromDate.month, a.fromDate.day);
          final bFromDate = DateTime(b.fromDate.year, b.fromDate.month, b.fromDate.day);
          return aFromDate.compareTo(bFromDate);
        });
      case TripFilter.completed:
        return trips.where((trip) {
          final toDate = DateTime(trip.toDate.year, trip.toDate.month, trip.toDate.day);
          return today.isAfter(toDate);
        }).toList()..sort((a, b) {
          final aToDate = DateTime(a.toDate.year, a.toDate.month, a.toDate.day);
          final bToDate = DateTime(b.toDate.year, b.toDate.month, b.toDate.day);
          return bToDate.compareTo(aToDate);
        });
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
