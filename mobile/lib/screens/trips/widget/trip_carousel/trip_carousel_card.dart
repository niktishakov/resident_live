import "package:country_code_picker/country_code_picker.dart";
import "package:domain/domain.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/screens/map/cubit/country_bg_cubit.dart";
import "package:resident_live/screens/trips/widget/trip_carousel/widgets/trip_background_image.dart";
import "package:resident_live/screens/trips/widget/trip_carousel/widgets/trip_content.dart";
import "package:resident_live/screens/trips/widget/trip_carousel/widgets/trip_dark_overlay.dart";
import "package:resident_live/screens/trips/widget/trip_carousel/widgets/trip_location_pin.dart";
import "package:resident_live/screens/trips/widget/trip_carousel/widgets/trip_status_badge.dart";
import "package:resident_live/shared/shared.dart";

enum TripStatus { upcoming, current, past }

// Extension to get trip status
extension TripStatusExtension on TripEntity {
  TripStatus get status {
    final now = DateTime.now();
    if (now.isBefore(fromDate)) {
      return TripStatus.upcoming;
    } else if (now.isAfter(toDate)) {
      return TripStatus.past;
    } else {
      return TripStatus.current;
    }
  }

  Color get statusColor {
    switch (status) {
      case TripStatus.upcoming:
        return Colors.blue;
      case TripStatus.current:
        return Colors.green;
      case TripStatus.past:
        return Colors.grey.shade600;
    }
  }

  String get statusText {
    switch (status) {
      case TripStatus.upcoming:
        return "Upcoming";
      case TripStatus.current:
        return "Current";
      case TripStatus.past:
        return "Past";
    }
  }
}

class TripCarouselCard extends StatelessWidget {
  const TripCarouselCard({required this.trip, this.onTap, this.onDelete, super.key});

  final TripEntity trip;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final countryName = CountryCode.fromCountryCode(
      trip.countryCode,
    ).localize(context).toCountryStringOnly();

    return BlocProvider(
      create: (_) => getIt<CountryBackgroundCubit>()..loadCountryBackground(trip.countryCode),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: "trip-image-${trip.id}",
          child: Material(
            child: Container(
              width: context.mediaQuery.size.width * 0.9,
              height: context.mediaQuery.size.height * 0.55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  TripBackgroundImage(trip: trip),
                  const TripDarkOverlay(),
                  TripContent(countryName: countryName, trip: trip),
                  // const Positioned(right: 20, top: 20, child: TripLocationPin()),
                  // Status badge
                  Positioned(bottom: 16, right: 16, child: TripStatusBadge(trip: trip)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
