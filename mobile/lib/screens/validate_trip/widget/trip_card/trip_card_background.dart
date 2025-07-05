import "package:cached_network_image/cached_network_image.dart";
import "package:data/data.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/screens/map/cubit/country_bg_cubit.dart";
import "package:resident_live/shared/shared.dart";

class TripCardBackground extends StatefulWidget {
  const TripCardBackground({required this.countryCode, super.key});

  final String countryCode;

  @override
  State<TripCardBackground> createState() => _TripCardBackgroundState();
}

class _TripCardBackgroundState extends State<TripCardBackground> {
  @override
  void initState() {
    super.initState();
    // Загружаем фон для страны при инициализации
    if (widget.countryCode.isNotEmpty) {
      context.read<CountryBackgroundCubit>().loadCountryBackground(widget.countryCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: BlocBuilder<CountryBackgroundCubit, CountryBackgroundState>(
          builder: (context, state) {
            return state.maybeWhen(
              loaded: (countryImages) {
                final backgroundUrl = countryImages[widget.countryCode];
                getIt<LoggerService>().warning("backgroundUrl: $backgroundUrl");

                if (backgroundUrl != null) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: backgroundUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => _buildFallbackGradient(theme),
                        errorWidget: (context, url, error) => _buildFallbackGradient(theme),
                      ),
                      // Overlay градиент для лучшей читаемости текста
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              Colors.black.withValues(alpha: 0.6),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return _buildFallbackGradient(theme);
              },
              loading: () => Stack(
                fit: StackFit.expand,
                children: [
                  _buildFallbackGradient(theme),
                  const Center(
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  ),
                ],
              ),
              error: (message) => _buildFallbackGradient(theme),
              orElse: () => _buildFallbackGradient(theme),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFallbackGradient(RlTheme theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [theme.bgAccent.withValues(alpha: 0.3), theme.bgAccent.withValues(alpha: 0.8)],
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 1.seconds);
  }
}
