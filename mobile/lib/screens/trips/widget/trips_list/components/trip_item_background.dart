import "package:cached_network_image/cached_network_image.dart";
import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:resident_live/screens/map/cubit/country_bg_cubit.dart";
import "package:resident_live/shared/shared.dart";

class TripItemBackground extends StatelessWidget {
  const TripItemBackground({required this.trip, super.key});

  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return Stack(
      children: [
        // Background image
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: _buildBackgroundImage(context, theme),
        ),

        // Strong gradient overlay for better text readability
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withValues(alpha: 0.3), Colors.black.withValues(alpha: 0.7)],
            ),
          ),
        ),

        // Additional darkening for better contrast
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.bgModal.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundImage(BuildContext context, RlTheme theme) {
    // If trip has saved background URL, use it directly
    if (trip.backgroundUrl != null && trip.backgroundUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: trip.backgroundUrl!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildFallbackGradient(theme),
        errorWidget: (context, url, error) => _buildFallbackGradient(theme),
      );
    }

    // Fallback to loading from cubit if no saved background
    return BlocBuilder<CountryBackgroundCubit, CountryBackgroundState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (countryImages) {
            final backgroundUrl = countryImages[trip.countryCode];
            if (backgroundUrl != null) {
              return CachedNetworkImage(
                imageUrl: backgroundUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildFallbackGradient(theme),
                errorWidget: (context, url, error) => _buildFallbackGradient(theme),
              );
            }
            return _buildFallbackGradient(theme);
          },
          orElse: () => _buildFallbackGradient(theme),
        );
      },
    );
  }

  Widget _buildFallbackGradient(RlTheme theme) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.bgAccent.withValues(alpha: 0.6), theme.bgAccent.withValues(alpha: 0.8)],
        ),
      ),
    );
  }
}
