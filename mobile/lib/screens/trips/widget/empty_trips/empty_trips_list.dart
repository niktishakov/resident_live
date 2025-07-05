import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/gen/translations.g.dart";
import "package:resident_live/screens/trips/widget/empty_trips/clouds_painter.dart";
import "package:resident_live/shared/shared.dart";
import "dart:ui" as ui;

class EmptyTripsList extends StatefulWidget {
  const EmptyTripsList({super.key});

  @override
  State<EmptyTripsList> createState() => _EmptyTripsListState();
}

class _EmptyTripsListState extends State<EmptyTripsList> with TickerProviderStateMixin {
  late AnimationController _cloudController;
  late Animation<double> _cloudAnimation;
  ui.Image? _cloudImage;

  @override
  void initState() {
    super.initState();
    _cloudController = AnimationController(duration: const Duration(minutes: 10), vsync: this)
      ..repeat();
    _cloudAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _cloudController, curve: Curves.linear));

    _loadCloudImage();
  }

  Future<void> _loadCloudImage() async {
    try {
      final image = await CloudsPainter.loadCloudImage(AppAssets.cloud.path);
      if (mounted) {
        setState(() {
          _cloudImage = image;
        });
      }
    } catch (e) {
      // Handle error silently - clouds just won't show
    }
  }

  @override
  void dispose() {
    _cloudController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    final t = context.t;

    return Stack(
      children: [
        // Background clouds layer
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _cloudAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: CloudsPainter(_cloudAnimation.value, theme, _cloudImage),
                size: Size.infinite,
              );
            },
          ),
        ).animate().fade(),
        // Main content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                t.trips.noTripsYet,
                style: theme.body22.copyWith(
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0,
                  foreground: Paint()
                    ..style = PaintingStyle.fill
                    ..shader = LinearGradient(
                      colors: [theme.textPrimary, theme.textPrimary.withValues(alpha: 0.5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(const Rect.fromLTWH(0, 0, 150, 30)),
                ),
              ),
              context.vBox16,
              Text(
                t.trips.planFutureTripToAvoidMistakes,
                style: theme.body14.copyWith(fontWeight: FontWeight.w300, color: theme.textPrimary),
              ),
              context.vBox24,
              PrimaryButton(
                onPressed: () {
                  context.pushNamed(ScreenNames.addTrip);
                },
                label: t.trips.addYourFirstTrip,
                textStyle: theme.body14.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.textPrimaryOnColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
