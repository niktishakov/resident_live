import "package:cached_network_image/cached_network_image.dart";
import "package:domain/domain.dart";
import "package:flutter/material.dart";

class TripBackgroundImageWidget extends StatelessWidget {
  const TripBackgroundImageWidget({required this.trip, super.key});

  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        child: CachedNetworkImage(
          imageUrl: trip.backgroundUrl ?? "",
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => const TripFallbackBackgroundWidget(),
          errorWidget: (context, url, error) => const TripFallbackBackgroundWidget(),
        ),
      ),
    );
  }
}

class TripFallbackBackgroundWidget extends StatelessWidget {
  const TripFallbackBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade400, Colors.purple.shade600],
        ),
      ),
    );
  }
}
