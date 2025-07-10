import "package:auto_size_text/auto_size_text.dart";
import "package:country_code_picker/country_code_picker.dart";
import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:gap/gap.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/screens/trip_details/widgets/trip_background_image_widget.dart";
import "package:resident_live/screens/trips/widget/trip_carousel/widgets/trip_location_pin.dart";
import "package:resident_live/screens/trips/widget/trip_carousel/widgets/trip_status_badge.dart";
import "package:resident_live/shared/shared.dart";

class TripHeaderSliverDelegate extends SliverPersistentHeaderDelegate {
  const TripHeaderSliverDelegate({required this.trip, this.scrollController});

  final TripEntity trip;
  final ScrollController? scrollController;

  static const double _maxHeaderHeight = 280.0;
  static const double _baseMinHeaderHeight = 120.0;

  @override
  double get minExtent => _baseMinHeaderHeight;

  @override
  double get maxExtent => _maxHeaderHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = context.rlTheme;
    final countryName = CountryCode.fromCountryCode(
      trip.countryCode,
    ).localize(context).toCountryStringOnly();

    final statusBarHeight = context.mediaQuery.viewPadding.top;
    final actualMinHeight = _baseMinHeaderHeight + statusBarHeight;

    // Calculate shrink progress (0.0 to 1.0)
    final shrinkProgress = shrinkOffset / (maxExtent - actualMinHeight);
    final clampedShrinkProgress = shrinkProgress.clamp(0.0, 1.0);

    // Calculate heights for animation - ensure it never goes below actualMinHeight
    final currentHeight = (maxExtent - shrinkOffset).clamp(actualMinHeight, maxExtent);
    final currentBorderRadius = (1 - shrinkProgress / 2) * 36;

    return Hero(
      tag: "trip-image-${trip.id}",
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: currentHeight,
          padding: EdgeInsets.only(bottom: ((1 - shrinkProgress) * 30).clamp(0, 20)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(currentBorderRadius),
              bottomRight: Radius.circular(currentBorderRadius),
            ),
          ),
          child: Stack(
            children: [
              // Background image
              TripBackgroundImageWidget(trip: trip, borderRadius: currentBorderRadius),
              // Dark overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(currentBorderRadius),
                    bottomRight: Radius.circular(currentBorderRadius),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.2 + (clampedShrinkProgress * 0.8)),
                      Colors.black.withValues(alpha: 0.6 + (clampedShrinkProgress * 0.4)),
                    ],
                  ),
                ),
              ),
              // Back button
              Positioned(
                top: statusBarHeight + 8,
                left: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(8),
                    onPressed: () => context.pop(),
                    child: const Icon(CupertinoIcons.back, color: Colors.white, size: 24),
                  ),
                ).animate().fadeIn(delay: 500.ms),
              ),
              // Status badge
              Positioned(
                bottom: 16,
                right: 16,
                child: AnimatedOpacity(
                  opacity: (1.0 - clampedShrinkProgress).clamp(0.0, 1.0),
                  duration: const Duration(milliseconds: 100),
                  child: TripStatusBadge(trip: trip),
                ),
              ),
              // Country info - positioned based on shrink progress
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: AnimatedOpacity(
                  opacity: (1.0 - clampedShrinkProgress).clamp(0.0, 1.0),
                  duration: const Duration(milliseconds: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              countryName.toUpperCase(),
                              maxLines: 1,
                              style: theme.body18.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Gap(context.mediaQuery.size.width * 0.25),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        trip.fromDate.toMonthYearString().replaceFirst(" ", ", "),
                        style: theme.body14.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Country name in center when collapsed
              if (clampedShrinkProgress > 0.75)
                Positioned(
                  top: statusBarHeight + 20,
                  left: 80,
                  right: 80,
                  child: AnimatedOpacity(
                    opacity: (clampedShrinkProgress - 0.5) * 2,
                    duration: const Duration(milliseconds: 100),
                    child: Center(
                      child: Text(
                        countryName.toUpperCase(),
                        style: theme.body16.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              Positioned(
                right: 20,
                top: statusBarHeight + 8,
                child: AnimatedOpacity(
                  opacity: (1.0 - clampedShrinkProgress).clamp(0.0, 1.0),
                  duration: const Duration(milliseconds: 100),
                  child: const TripLocationPin().animate(delay: 500.ms).fadeIn(),
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
    return oldDelegate is TripHeaderSliverDelegate && oldDelegate.trip != trip;
  }
}
