import "package:country_code_picker/country_code_picker.dart";
import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:gap/gap.dart";
import "package:get_it/get_it.dart";
import "package:go_router/go_router.dart";
import "package:google_fonts/google_fonts.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/localization/generated/l10n/l10n.dart";
import "package:resident_live/screens/all_countries/cubit/remove_country_cubit.dart";
import "package:resident_live/screens/splash/cubit/get_user_cubit.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";
import "package:resident_live/shared/lib/service/vibration_service.dart";
import "package:resident_live/shared/lib/utils/hero_utils.dart";
import "package:resident_live/shared/shared.dart";
import "package:resident_live/shared/widget/transparent_button.dart";

part "widgets/country_item.dart";
part "widgets/reordable_countries_list.dart";

class AllCountriesScreen extends StatefulWidget {
  const AllCountriesScreen({super.key});

  @override
  State<AllCountriesScreen> createState() => _AllCountriesScreenState();
}

class _AllCountriesScreenState extends State<AllCountriesScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<BorderRadius> _borderAnimation;
  final screenKey = GlobalKey();
  bool isEditing = false;
  List<String> selected = [];
  bool _isPopping = false;

  double _initialDragY = 0.0;
  final double _dragThreshold = 200.0;
  final progressKey = GlobalKey();

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.75).animate(_animationController);
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(_animationController);
    _borderAnimation = Tween<BorderRadius>(
      begin: BorderRadius.circular(kLargeBorderRadius),
      end: BorderRadius.circular(38),
    ).animate(_animationController);

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
      _animationController.forward().then((_) {
        if (mounted) {
          setState(() => _isPopping = true);
          context.pop();
        }
      });
    }

    final currentDrag = details.globalPosition.dy;
    final dragDelta = currentDrag - _initialDragY;

    _animationController.value = (dragDelta / _dragThreshold).clamp(0.0, 1.0);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_animationController.value > 0.5 || details.velocity.pixelsPerSecond.dy > 700) {
      _animationController.forward().then((_) {
        if (context.canPop()) {
          setState(() => _isPopping = true);
          context.pop();
        }
      });
    } else {
      _animationController.reverse();
    }
  }

  void toggleSelection({required String countryCode, required bool isSelected}) {
    if (isSelected) {
      selected.add(countryCode);
    } else {
      selected.remove(countryCode);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return GestureDetector(
      onVerticalDragStart: _handleDragStart,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      child: Material(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) => Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: "tracking_residences",
                    flightShuttleBuilder: (
                      flightContext,
                      animation,
                      flightDirection,
                      fromHeroContext,
                      toHeroContext,
                    ) =>
                        toSecondHeroFlightShuttleBuilder(
                      flightContext: flightContext,
                      animation: animation,
                      flightDirection: flightDirection,
                      fromHeroContext: fromHeroContext,
                      toHeroContext: toHeroContext,
                      beginBorderRadius: BorderRadius.circular(38).topLeft.x,
                    ),
                    child: RlCard(
                      borderRadius: _borderAnimation.value.topLeft.x,
                      gradient: vGradient,
                    ),
                  ),
                  Visibility(
                    visible: !_isPopping,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: RlCard(
                        borderRadius: _borderAnimation.value.topLeft.x,
                        gradient: vGradient,
                        padding: EdgeInsets.zero,
                        child: CupertinoPageScaffold(
                          backgroundColor: Colors.transparent,
                          navigationBar: CupertinoNavigationBar(
                            padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 24,
                            ),
                            backgroundColor: Colors.transparent,
                            middle: Text(
                              S.of(context).homeTrackingResidences,
                              style: theme.title16Semi.copyWith(
                                color: theme.textPrimary,
                              ),
                            ),
                            leading: TransparentButton(
                              width: 60,
                              onPressed: () {
                                setState(() {
                                  isEditing = !isEditing;
                                  selected = [];
                                });
                              },
                              child: Text(
                                isEditing ? S.of(context).commonContinue : S.of(context).commonEdit,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: isEditing ? FontWeight.w600 : FontWeight.w500,
                                ),
                              ),
                            ),
                            trailing: BouncingButton(
                              onPressed: (_) {
                                VibrationService.instance.tap();
                                context.pop();
                              },
                              child: Icon(
                                CupertinoIcons.clear_circled_solid,
                                size: 34,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                          ),
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Column(
                                children: [
                                  const Gap(32),
                                  ReordableCountriesList(
                                    isEditing: isEditing,
                                    selected: selected,
                                    toggleSelection: toggleSelection,
                                  ),
                                  const Spacer(),
                                  TweenAnimationBuilder(
                                    duration: 500.ms,
                                    curve: Curves.fastOutSlowIn,
                                    tween: Tween<double>(
                                      begin: 1.0,
                                      end: isEditing ? 0.0 : 1.0,
                                    ),
                                    builder: (context, value, child) {
                                      return Transform.translate(
                                        offset: Offset(0, value * 300),
                                        child: child,
                                      );
                                    },
                                    child: PrimaryButton(
                                      label: "Delete",
                                      backgroundColor: Colors.redAccent,
                                      enabled: selected.isNotEmpty,
                                      onPressed: () {
                                        VibrationService.instance.tap();
                                        showCupertinoDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context) => CupertinoAlertDialog(
                                            title: const Text("Delete Residences"),
                                            content: const Text(
                                              "Are you sure you want to delete the selected residences?",
                                            ),
                                            actions: [
                                              CupertinoDialogAction(
                                                isDestructiveAction: true,
                                                onPressed: () async {
                                                  setState(
                                                    () => _isPopping = true,
                                                  );

                                                  context.pop();
                                                  for (final isoCode in selected) {
                                                    GetIt.I<RemoveCountryCubit>().loadResource(isoCode);
                                                  }
                                                  setState(selected.clear);
                                                  VibrationService.instance.success();
                                                },
                                                child: const Text("Delete"),
                                              ),
                                              CupertinoDialogAction(
                                                child: const Text("Cancel"),
                                                onPressed: () => context.pop(),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ).animate().fade(delay: 200.ms),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
