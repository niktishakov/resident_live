import "dart:async";

import "package:domain/domain.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/screens/map/cubit/country_bg_cubit.dart";
import "package:resident_live/screens/splash/cubit/get_user_cubit.dart";
import "package:resident_live/screens/trip_details/widgets/trip_actions_widget.dart";
import "package:resident_live/screens/trip_details/widgets/trip_header_sliver_delegate.dart";
import "package:resident_live/screens/trip_details/widgets/trip_impact_analysis_widget.dart";
import "package:resident_live/screens/trip_details/widgets/trip_stats_widget.dart";
import "package:resident_live/screens/trips/cubit/trips_stream_cubit.dart";
import "package:resident_live/shared/shared.dart";

class TripDetailsScreen extends StatefulWidget {
  const TripDetailsScreen({required this.trip, super.key});

  final TripEntity trip;

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  late ScrollController _scrollController;
  late TripHeaderSliverDelegate _headerDelegate;

  // Scroll tracking variables
  double _lastScrollPosition = 0.0;
  double _scrollVelocity = 0.0;
  DateTime _lastScrollTime = DateTime.now();
  Timer? _scrollEndTimer;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _headerDelegate = TripHeaderSliverDelegate(
      trip: widget.trip,
      scrollController: _scrollController,
    );

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final currentPosition = _scrollController.position.pixels;
    final currentTime = DateTime.now();

    // Calculate velocity
    final timeDiff = currentTime.difference(_lastScrollTime).inMilliseconds;
    if (timeDiff > 0) {
      final positionDiff = currentPosition - _lastScrollPosition;
      _scrollVelocity = positionDiff / timeDiff * 1000; // pixels per second
    }

    _isScrolling = true;
    _lastScrollPosition = currentPosition;
    _lastScrollTime = currentTime;

    // Cancel previous timer
    _scrollEndTimer?.cancel();

    // Start new timer to detect scroll end
    _scrollEndTimer = Timer(const Duration(milliseconds: 150), _onScrollEnd);
  }

  void _onScrollEnd() {
    if (!_isScrolling) return;

    _isScrolling = false;

    // Apply snap logic here
    _handleSnapLogic(currentPosition: _lastScrollPosition, velocity: _scrollVelocity);
  }

  void _handleSnapLogic({required double currentPosition, required double velocity}) {
    // Get header dimensions from delegate constants
    const headerHeight = 280.0; // TripHeaderSliverDelegate._maxHeaderHeight
    const minHeaderHeight = 120.0; // TripHeaderSliverDelegate._baseMinHeaderHeight
    const actualMinHeight = minHeaderHeight;
    const headerScrollRange = headerHeight - actualMinHeight; // maxExtent - minExtent

    // Check if we're in the header scroll range
    if (currentPosition <= headerScrollRange) {
      double targetPosition;

      // Quick gesture detection
      if (velocity.abs() > 500) {
        if (velocity > 0) {
          // Fast scroll down - collapse header
          targetPosition = headerScrollRange;
        } else {
          // Fast scroll up - expand header
          targetPosition = 0.0;
        }
      } else {
        // Normal gesture - snap to nearest position (0 or headerScrollRange)
        final snapPoints = [
          0.0, // Fully expanded
          headerScrollRange, // Fully collapsed
        ];

        targetPosition = _findNearestSnapPoint(currentPosition, snapPoints);
      }

      _animateToPosition(targetPosition);
    } else {
      // We're scrolling content, no snap needed
    }
  }

  double _findNearestSnapPoint(double currentPosition, List<double> snapPoints) {
    var nearestPoint = snapPoints.first;
    var minDistance = (currentPosition - snapPoints.first).abs();

    for (final point in snapPoints) {
      final distance = (currentPosition - point).abs();
      if (distance < minDistance) {
        minDistance = distance;
        nearestPoint = point;
      }
    }

    return nearestPoint;
  }

  void _animateToPosition(double targetPosition) {
    if (!_scrollController.hasClients) return;

    final currentPosition = _scrollController.position.pixels;
    final distance = (targetPosition - currentPosition).abs();

    if (distance < 2.0) return; // Skip if already close

    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final clampedTarget = targetPosition.clamp(0.0, maxScrollExtent);

    final duration = Duration(milliseconds: (300 * (distance / 100)).clamp(200, 500).round());

    _scrollController.animateTo(clampedTarget, duration: duration, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _scrollEndTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<CountryBackgroundCubit>()..loadCountryBackground(widget.trip.countryCode),
        ),
        BlocProvider(create: (_) => getIt<GetUserCubit>()..loadResource()),
        BlocProvider(create: (_) => getIt<TripsStreamCubit>()),
      ],
      child: Material(
        child: Scaffold(
          backgroundColor: theme.bgPrimary,
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPersistentHeader(delegate: _headerDelegate, pinned: true, floating: false),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TripStatsWidget(trip: widget.trip),
                      const SizedBox(height: 24),
                      TripImpactAnalysisWidget(trip: widget.trip),
                      const SizedBox(height: 24),
                      TripActionsWidget(trip: widget.trip),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
