import "package:cached_network_image/cached_network_image.dart";
import "package:country_code_picker/country_code_picker.dart";
import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:resident_live/screens/map/cubit/country_bg_cubit.dart";
import "package:resident_live/shared/lib/service/vibration_service.dart";
import "package:resident_live/shared/shared.dart";

class StayPeriodItem extends StatelessWidget {
  const StayPeriodItem({
    required this.stayPeriod,
    required this.index,
    this.onTap,
    super.key,
    this.isSelected = false,
  });

  final StayPeriodValueObject stayPeriod;
  final Function(String countryCode, int index)? onTap;
  final int index;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    final countryName =
        CountryCode.fromCountryCode(stayPeriod.countryCode).localize(context).name ??
        stayPeriod.countryCode;

    return BlocBuilder<CountryBackgroundCubit, CountryBackgroundState>(
      builder: (context, state) {
        final backgroundUrl = state.maybeMap(
          loaded: (loaded) => loaded.countryImages[stayPeriod.countryCode],
          orElse: () => null,
        );

        return BouncingButton(
          vibrate: false,
          onPressed: () {
            VibrationService.instance.light();
            onTap?.call(stayPeriod.countryCode, index);
          },
          borderRadius: BorderRadius.circular(16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: backgroundUrl == null
                  ? LinearGradient(
                      colors: [
                        theme.bgAccent.withValues(alpha: 0.8),
                        theme.bgAccent.withValues(alpha: 0.4),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              image: backgroundUrl != null
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(backgroundUrl, cacheKey: backgroundUrl),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withValues(alpha: 0.3),
                        BlendMode.darken,
                      ),
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Gradient overlay for better text readability
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withValues(alpha: 0.2)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  height: isSelected ? 160 : 120,
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Country name with enhanced styling
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          countryName,
                          style: theme.body14.copyWith(
                            color: theme.textPrimary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      // Date and duration info with better hierarchy
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${stayPeriod.startDate.toDDMMMYYString()} - ${stayPeriod.endDate.toDDMMMYYString()}",
                            style: theme.body14.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.time,
                                size: 14,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${stayPeriod.days} days",
                                style: theme.body12.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w400,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(alpha: 0.3),
                                      blurRadius: 1,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Selection indicator
                if (isSelected)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.bgAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.check, size: 16, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
