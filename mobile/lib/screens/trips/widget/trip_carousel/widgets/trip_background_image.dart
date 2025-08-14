import "package:cached_network_image/cached_network_image.dart";
import "package:domain/domain.dart";
import "package:flutter/material.dart";

import "package:resident_live/screens/trips/widget/trip_carousel/widgets/trip_fallback_background.dart";

class TripBackgroundImage extends StatelessWidget {
  const TripBackgroundImage({required this.trip, super.key});

  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: CachedNetworkImage(
          imageUrl: trip.backgroundUrl ?? "",
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => const TripFallbackBackground(),
          errorWidget: (context, url, error) => const TripFallbackBackground(),
        ),
      ),
    );
  }
}
