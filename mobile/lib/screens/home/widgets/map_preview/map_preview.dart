import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/gen/translations.g.dart";
import "package:resident_live/shared/shared.dart";
import "package:visibility_detector/visibility_detector.dart";

class MapPreview extends StatefulWidget {
  const MapPreview({required this.stayPeriods, super.key});
  final List<StayPeriodValueObject> stayPeriods;

  @override
  State<MapPreview> createState() => _MapPreviewState();
}

class _MapPreviewState extends State<MapPreview> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = context.rlTheme;

    final uniqueCountries = widget.stayPeriods.map((p) => p.countryCode).toSet().length;
    final totalDays = widget.stayPeriods.fold(0, (sum, period) => sum + period.days);

    // Кэшируем список стран
    final countryCodes = widget.stayPeriods.map((p) => p.countryCode).toSet().toList();

    return GestureDetector(
      onTap: () async {
        context.pushNamed(ScreenNames.map, extra: widget.stayPeriods);
      },
      child: Container(
        height: 130,
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Lazy загружаем карту только при первом появлении
              Positioned.fill(
                child: _LazyAppleGlobeView(
                  countryCodes: countryCodes,
                  stayPeriods: widget.stayPeriods,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(color: theme.bgModal.withValues(alpha: 0.5)),
                ),
              ),

              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.bgModal.withValues(alpha: 0.85),
                    gradient: kMainGradient.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.location_solid, size: 14, color: theme.iconPrimary),
                      const SizedBox(width: 4),
                      Text(
                        "$uniqueCountries countries",
                        style: theme.body10M.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      Icon(CupertinoIcons.calendar_today, size: 14, color: theme.iconPrimary),
                      const SizedBox(width: 4),
                      Text(
                        "$totalDays days tracked",
                        style: theme.body10M.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child:
                    Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: kMainGradient.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.location_solid,
                                size: 18,
                                color: theme.iconPrimary,
                              ),
                              context.hBox4,
                              Text(
                                context.t.common.showOnMap,
                                style: theme.body12.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )
                        .animate(onComplete: (controller) => controller.repeat())
                        .shimmer(duration: 1.seconds, delay: 20.seconds),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LazyAppleGlobeView extends StatefulWidget {
  const _LazyAppleGlobeView({required this.countryCodes, required this.stayPeriods});

  final List<String> countryCodes;
  final List<StayPeriodValueObject> stayPeriods;

  @override
  State<_LazyAppleGlobeView> createState() => _LazyAppleGlobeViewState();
}

class _LazyAppleGlobeViewState extends State<_LazyAppleGlobeView> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key("apple-globe-view"),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: Image.asset(AppAssets.earthBg.path, fit: BoxFit.cover),
    );
  }
}
