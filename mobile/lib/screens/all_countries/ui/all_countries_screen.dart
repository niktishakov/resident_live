import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:gap/gap.dart";
import "package:go_router/go_router.dart";
import "package:google_fonts/google_fonts.dart";
import "package:resident_live/features/countries/model/countries_cubit.dart";
import "package:resident_live/features/countries/model/countries_state.dart";
import "package:resident_live/generated/l10n/l10n.dart";
import "package:resident_live/shared/lib/service/vibration_service.dart";
import "package:resident_live/shared/shared.dart";

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

  void toggleSelection({required CountryEntity country, required bool isSelected}) {
    if (isSelected) {
      selected.add(country.isoCode);
    } else {
      selected.remove(country.isoCode);
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
                                color: theme.textPrimaryOnColor,
                                fontFamily: "SFPro",
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
                                  BlocBuilder<CountriesCubit, CountriesState>(
                                    builder: (c, s) {
                                      return RlCard(
                                        borderRadius: 24,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: Stack(
                                          children: [
                                            // Normal ListView
                                            Opacity(
                                              opacity: isEditing ? 0.0 : 1.0,
                                              child: IgnorePointer(
                                                ignoring: isEditing,
                                                child: ListView.builder(
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemBuilder: (context, index) {
                                                    final country = s.countries.values.toList()[index];
                                                    return _CountryItem(
                                                      country: country,
                                                      toggleSelection: toggleSelection,
                                                      isEditing: isEditing,
                                                      isSelected: selected.contains(
                                                        country.isoCode,
                                                      ),
                                                      isLast: index == s.countries.length - 1,
                                                    );
                                                  },
                                                  itemCount: s.countries.length,
                                                ),
                                              ),
                                            ),

                                            // Reorderable ListView
                                            Opacity(
                                              opacity: isEditing ? 1.0 : 0.0,
                                              child: IgnorePointer(
                                                ignoring: !isEditing,
                                                child: ReorderableListView.builder(
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemBuilder: (context, index) {
                                                    final country = s.countries.values.toList()[index];
                                                    return _CountryItem(
                                                      key: Key(country.isoCode),
                                                      country: country,
                                                      toggleSelection: toggleSelection,
                                                      isEditing: isEditing,
                                                      isSelected: selected.contains(
                                                        country.isoCode,
                                                      ),
                                                      isLast: index == s.countries.length - 1,
                                                    );
                                                  },
                                                  itemCount: s.countries.length,
                                                  onReorder: (
                                                    oldIndex,
                                                    newIndex,
                                                  ) {
                                                    find<CountriesCubit>(
                                                      context,
                                                    ).reorderCountry(
                                                      oldIndex,
                                                      newIndex,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
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
                                                    find<CountriesCubit>(
                                                      context,
                                                    ).removeCountry(isoCode);
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

class _CountryItem extends StatelessWidget {
  const _CountryItem({
    required this.country,
    required this.toggleSelection,
    required this.isEditing,
    required this.isSelected,
    required this.isLast,
    super.key,
  });

  final CountryEntity country;
  final bool isEditing;
  final bool isSelected;
  final bool isLast;
  final Function({required CountryEntity country, required bool isSelected}) toggleSelection;

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xff3C3C3C);
    const valueColor = Color(0xff8E8E8E);
    final theme = context.rlTheme;
    final daysSpent = country.daysSpent;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: GestureDetector(
        onTap: isEditing
            ? () => toggleSelection(country: country, isSelected: !isSelected)
            : () {
                context.pushNamed(
                  ScreenNames.residenceDetails2,
                  extra: country.name,
                );
              },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 1),
          color: Colors.white.withValues(alpha: 0.0001),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(begin: 0, end: isEditing ? 1 : 0),
                      builder: (context, value, child) {
                        return SizedBox(
                          width: value * 45,
                          height: 45,
                          child: Transform.translate(
                            offset: Offset(-40 * (1 - value), 0),
                            child: Opacity(
                              opacity: value.clamp(0.0, 1.0),
                              child: OverflowBox(
                                minWidth: 45,
                                maxWidth: 45,
                                minHeight: 45,
                                maxHeight: 45,
                                child: child,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: SizedBox.square(
                          dimension: 45,
                          child: Center(
                            child: RlCheckbox(
                              value: isSelected,
                              onToggle: (value) => toggleSelection(country: country, isSelected: value),
                            ),
                          ),
                        ),
                      ),
                    ),
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(
                        begin: 0,
                        end: isEditing ? 1 : 0,
                      ),
                      builder: (context, value, child) {
                        return Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    country.name,
                                    style: theme.body12M.copyWith(
                                      color: theme.textPrimaryOnColor,
                                    ),
                                  ),
                                  const Gap(4),
                                  Flexible(
                                    child: Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: context.theme.colorScheme.tertiary.withValues(alpha: 0.5),
                                      ),
                                      "${country.daysSpent} / 183 ${S.of(context).homeDays}",
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(6),
                              TweenAnimationBuilder(
                                duration: 2.seconds,
                                tween: Tween<double>(
                                  begin: 1.0,
                                  end: (daysSpent / 183).clamp(0.0, 1.0),
                                ),
                                curve: Curves.fastEaseInToSlowEaseOut,
                                builder: (context, v, child) {
                                  return LinearProgressIndicator(
                                    minHeight: 8,
                                    borderRadius: BorderRadius.circular(8),
                                    value: v,
                                    backgroundColor: backgroundColor,
                                    valueColor: const AlwaysStoppedAnimation(valueColor),
                                  ).animate().shimmer(
                                    duration: 1.seconds,
                                    delay: 1.seconds,
                                    stops: [1.0, 0.5, 0.0],
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(begin: 0, end: isEditing ? 1 : 0),
                      builder: (context, value, child) {
                        return SizedBox(
                          width: value * 45,
                          height: 45,
                          child: Transform.translate(
                            offset: Offset(45 * (1 - value), 0),
                            child: Opacity(
                              opacity: value.clamp(0.0, 1.0),
                              child: OverflowBox(
                                minWidth: 45,
                                maxWidth: 45,
                                minHeight: 45,
                                maxHeight: 45,
                                child: child,
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 12.0),
                        child: SizedBox.square(
                          dimension: 45,
                          child: Center(
                            child: AppAssetImage(
                              AppAssets.burger,
                              width: 30,
                              color: Color(0xff8E8E8E),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(16),
              if (!isLast)
                Divider(
                  color: context.theme.colorScheme.surface,
                  height: 2,
                  thickness: 2,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
