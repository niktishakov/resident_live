import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../features/features.dart';
import '../../shared/shared.dart';

class ResidenceDetailsScreen extends StatefulWidget {
  const ResidenceDetailsScreen({super.key, required this.name});
  final String name;

  @override
  State<ResidenceDetailsScreen> createState() => _ResidenceDetailsScreenState();
}

class _ResidenceDetailsScreenState extends State<ResidenceDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<BorderRadius> _borderAnimation;

  double _initialDragY = 0.0;
  final double _dragThreshold = 200.0;
  final progressKey = GlobalKey();

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.75).animate(_animationController);
    _opacityAnimation =
        Tween<double>(begin: 1.0, end: 0.5).animate(_animationController);
    _borderAnimation =
        Tween<BorderRadius>(begin: kLargeBorderRadius, end: kBorderRadius)
            .animate(_animationController);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    _initialDragY = details.globalPosition.dy;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_animationController.value > 0.5) {
      _animationController.forward().then((_) => {if (mounted) context.pop()});
    }

    final currentDrag = details.globalPosition.dy;
    final dragDelta = currentDrag - _initialDragY;

    _animationController.value = (dragDelta / _dragThreshold).clamp(0.0, 1.0);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_animationController.value > 0.5 ||
        details.velocity.pixelsPerSecond.dy > 700) {
      _animationController.forward().then((_) => context.pop());
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final country =
        context.watch<CountriesCubit>().state.getCountryByName(widget.name);
    final state = context.watch<LocationCubit>().state;
    final isHere = state.isCurrentResidence(country.isoCode);

    final progress = country.isResident ? 1.0 : (country.daysSpent) / 183;

    final statusText = country.isResident
        ? "${country.statusToggleIn} extra days are free\nfor travelling"
        : "${country.statusToggleIn} days left until reaching a residency status";
    final suggestionText = country.isResident
        ? "Your resident status will be saved until "
        : "You’ll reach a residency status at ";

    return Scaffold(
      body: GestureDetector(
        onVerticalDragStart: _handleDragStart,
        onVerticalDragUpdate: _handleDragUpdate,
        onVerticalDragEnd: _handleDragEnd,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) => Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Hero(
                    tag: 'residence_${country.name}',
                    flightShuttleBuilder: endFlightShuttleBuilder,
                    child: Material(
                      color: Colors.transparent,
                      child: RlCard(
                        // color: context.theme.cardColor,
                        borderRadius: _borderAnimation.value,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            context.theme.cardColor,
                            context.theme.scaffoldBackgroundColor,
                          ],
                        ),
                        child: child,
                      ),
                    ),
                  ))),
          child: SafeArea(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 8),
              children: [
                Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.name,
                          style: context.theme.textTheme.titleLarge,
                        ),
                        if (isHere) ...[
                          Gap(4),
                          Here(shorter: true),
                        ],
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        VibrationService.instance.tap();
                        ShareService.instance.shareResidence(country);
                      },
                      child: AppAssetImage(
                        AppAssets.squareAndArrowUpCircle,
                        width: 32,
                        color: Colors.grey[300],
                      ),
                    )
                        .animate()
                        .scale(curve: Curves.elasticInOut, duration: 1.seconds),
                    Gap(10),
                    GestureDetector(
                      onTap: () {
                        VibrationService.instance.tap();
                        context.pop();
                      },
                      child: Icon(
                        CupertinoIcons.clear_circled_solid,
                        size: 34,
                        color: Colors.grey[500],
                      ),
                    )
                  ],
                ),
                Gap(64),
                Text(
                  statusText,
                  style: context.theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.theme.colorScheme.secondary),
                ),
                Gap(48),
                Center(
                  child: Material(
                    color: Colors.transparent,
                    child: RepaintBoundary(
                      key: progressKey,
                      child: ProgressBar(
                        completionPercentage: progress,
                        direction: isHere
                            ? ProgressDirection.up
                            : ProgressDirection.down,
                        radius: 200,
                        strokeWidth: 20,
                        duration: 900.ms,
                        doneLabel: "You are a resident!",
                        label: "Residency Progress",
                      ),
                    ),
                  ),
                ),
                Gap(32),
                Text.rich(TextSpan(children: [
                  TextSpan(
                      text: suggestionText,
                      style: context.theme.textTheme.bodyLarge),
                  TextSpan(text: "\n"),
                  TextSpan(
                      text: "${country.statusToggleAt.toMMMDDYYYY()}",
                      style: context.theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ])).animate(delay: isHere ? 1000.ms : 300.ms).fade(),
                Row(
                  children: [
                    Expanded(child: Text("Notify me for status updates")),
                    Switch(
                      value: true,
                      onChanged: (value) {
                        // TODO: schedule notification for this country
                      },
                    ),
                  ],
                ).animate(delay: isHere ? 1100.ms : 300.ms).fade(),
                Gap(24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
