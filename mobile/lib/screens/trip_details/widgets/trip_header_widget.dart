import "package:country_code_picker/country_code_picker.dart";
import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/screens/trip_details/widgets/trip_background_image_widget.dart";
import "package:resident_live/screens/trips/widget/trip_carousel/widgets/trip_status_badge.dart";
import "package:resident_live/shared/shared.dart";

class TripHeaderWidget extends StatelessWidget {
  const TripHeaderWidget({required this.trip, super.key});

  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    final countryName = CountryCode.fromCountryCode(
      trip.countryCode,
    ).localize(context).toCountryStringOnly();

    return Hero(
      tag: "trip-image-${trip.id}",
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: 280,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Stack(
            children: [
              // Background image
              TripBackgroundImageWidget(trip: trip),
              // Dark overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              // Back button
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(8),
                    onPressed: () => context.pop(),
                    child: const Icon(CupertinoIcons.back, color: Colors.white, size: 24),
                  ),
                ),
              ),
              // Status badge
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                right: 16,
                child: TripStatusBadge(trip: trip),
              ),
              // Country info
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      countryName.toUpperCase(),
                      style: theme.body18.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
            ],
          ),
        ),
      ),
    );
  }
}
