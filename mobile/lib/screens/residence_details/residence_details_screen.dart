
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:resident_live/generated/codegen_loader.g.dart';
import 'package:resident_live/screens/residence_details/widgets/header.dart';
import 'package:resident_live/widgets/widgets.dart';

import '../../features/features.dart';
import '../../shared/shared.dart';
import 'widgets/residency_rules_modal.dart';

final _statuses = {
  'hr': [
    LocaleKeys.residency_details_youAreAResident.tr(),
    LocaleKeys.residency_details_youAreAResident.tr(),
  ],
  'h': [
    LocaleKeys.residency_details_statusUpdateIn.tr(),
    LocaleKeys.residency_details_statusWillUpdateAt.tr(),
  ],
  'r': [
    LocaleKeys.residency_details_youWillLoseYourStatusIn.tr(),
    LocaleKeys.residency_details_statusIsSafeUntil.tr(),
  ],
  'a': [
    LocaleKeys.residency_details_moveToThisCountryToReachStatusIn.tr(),
    LocaleKeys.residency_details_statusMayBeUpdatedAt.tr(),
  ],
};

List<String> getStatusMessage(bool isHere, bool isResident) =>
    _statuses[isHere && isResident
        ? 'hr'
        : isHere
            ? 'h'
            : isResident
                ? 'r'
                : 'a']!;

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
  final screenKey = GlobalKey();

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
      _animationController.forward().then((_) {
        if (mounted && context.canPop()) context.pop();
      });
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    final country =
        context.watch<CountriesCubit>().state.getCountryByName(widget.name);
    final state = context.watch<LocationCubit>().state;
    final isHere = state.isCurrentResidence(country.isoCode);
    final isResident = country.isResident;
    final focusedCountry = context.watch<CountriesCubit>().state.focusedCountry;
    final isFocused = focusedCountry?.isoCode == country.isoCode;

    final progress = country.isResident ? 1.0 : (country.daysSpent) / 183;

    final statuses = getStatusMessage(isHere, isResident);
    final statusText = statuses.first;
    final suggestionText = statuses.last;

    return RepaintBoundary(
      key: screenKey,
      child: CupertinoScaffold(
        overlayStyle: getSystemOverlayStyle,
        transitionBackgroundColor: Color(0xff121212),
        body: Builder(
          builder: (context) {
            return Material(
              child: GestureDetector(
                onVerticalDragStart: _handleDragStart,
                onVerticalDragUpdate: _handleDragUpdate,
                onVerticalDragEnd: _handleDragEnd,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _opacityAnimation.value,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: child,
                      ),
                    );
                  },
                  child: Builder(
                    builder: (context) {
                      return Hero(
                        tag: 'residence_${country.name}',
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
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: RlCard(
                            // color: context.theme.cardColor,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                context.theme.cardColor,
                                context.theme.scaffoldBackgroundColor,
                              ],
                            ),
                            child: SafeArea(
                              child: Builder(
                                builder: (context) {
                                  return ListView(
                                    physics: NeverScrollableScrollPhysics(),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    children: [
                                      Header(
                                        countryName: widget.name,
                                        isFocused: isFocused,
                                        isHere: isHere,
                                        screenKey: screenKey,
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
                                              duration: 300.ms,
                                              doneLabel: LocaleKeys
                                                  .residency_details_youAreAResident
                                                  .tr(),
                                              label: LocaleKeys
                                                  .residency_details_residencyProgress
                                                  .tr(),
                                              backgroundColor:
                                                  Color(0xff3C3C3C),
                                              valueColor: isResident && isHere
                                                  ? Colors.greenAccent
                                                  : context.theme.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Gap(32),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: statusText,
                                              style: theme.body14,
                                            ),
                                            TextSpan(
                                              text:
                                                  '\n${country.statusToggleIn} days',
                                              style: theme.body18M.copyWith(
                                                  fontWeight: FontWeight.w700,),
                                            ),
                                          ],
                                        ),
                                      ).animate(delay: 300.ms).slideX(
                                            begin: -2,
                                            curve:
                                                Curves.fastEaseInToSlowEaseOut,
                                            duration: 500.ms,
                                          ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: suggestionText,
                                                  style: theme.body14,
                                                ),
                                                TextSpan(
                                                  text:
                                                      '\n${country.statusToggleAt.toMMMMDDYYYY()}',
                                                  style: theme.body18M.copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,),
                                                ),
                                              ],
                                            ),
                                          )
                                              .animate(delay: 300.ms)
                                              .slideX(
                                                begin: -2,
                                                curve: Curves
                                                    .fastEaseInToSlowEaseOut,
                                                duration: 500.ms,
                                              )
                                              .fade(),
                                          BouncingButton(
                                            onPressed: (_) async {
                                              await CupertinoScaffold
                                                  .showCupertinoModalBottomSheet(
                                                useRootNavigator: true,
                                                context: context,
                                                duration: 300.ms,
                                                animationCurve: Curves
                                                    .fastEaseInToSlowEaseOut,
                                                builder: (context) =>
                                                    ResidencyJourneyScreen(),
                                              );
                                            },
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.white,),),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0,),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons.calendar,
                                                      size: 18,
                                                      color: Colors.white,
                                                    ),
                                                    Gap(4),
                                                    Text(
                                                      LocaleKeys
                                                          .residency_details_calendar
                                                          .tr(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        height: 32 / 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                              .animate(delay: 500.ms)
                                              .slideX(
                                                begin: 1.5,
                                                curve: Curves
                                                    .fastEaseInToSlowEaseOut,
                                                duration: 500.ms,
                                              )
                                              .fade(),
                                        ],
                                      ),
                                      Gap(8),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            LocaleKeys
                                                .residency_details_notifyMe
                                                .tr(),
                                          ),),
                                          Switch(
                                            value: true,
                                            onChanged: (value) {
                                              // TODO: schedule notification for this country
                                            },
                                          ),
                                        ],
                                      ).animate().fadeIn(delay: 600.ms),
                                      Gap(24),
                                      Divider(
                                        color: Color(0x88888888),
                                      ).animate().fadeIn(delay: 700.ms),
                                      Gap(24),
                                      TweenAnimationBuilder(
                                        duration: Duration(milliseconds: 250),
                                        curve: Curves.easeInOut,
                                        tween: Tween<double>(
                                            begin: 0, end: isFocused ? 0 : 1,),
                                        builder: (context, value, child) {
                                          return SizedBox(
                                            height: value * 40,
                                            child: Transform.translate(
                                              offset:
                                                  Offset(-20 * (1 - value), 0),
                                              child: Opacity(
                                                opacity: value.clamp(0.0, 1.0),
                                                child: child,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: TransparentButton(
                                            leading: AppAssetImage(
                                              AppAssets.target,
                                              width: 24,
                                              color: context
                                                  .theme.colorScheme.secondary,
                                            ),
                                            onPressed: () {
                                              find<CountriesCubit>(context)
                                                  .setFocusedCountry(country);
                                            },
                                            child: Text(
                                              LocaleKeys
                                                  .residency_details_focusOnThisCountry
                                                  .tr(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: context.theme.colorScheme
                                                    .secondary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ).animate().fadeIn(delay: 700.ms),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TransparentButton(
                                          leading: AppAssetImage(
                                            AppAssets.bookPages,
                                            width: 24,
                                          ),
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              useRootNavigator: true,
                                              useSafeArea: false,
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              transitionAnimationController:
                                                  AnimationController(
                                                vsync: Navigator.of(context),
                                                duration: const Duration(
                                                    milliseconds: 300,),
                                              ),
                                              builder: (_) =>
                                                  ResidencyRulesModal(),
                                            ).then((_) {
                                              // Fade out the blur effect when the modal is dismissed
                                              Future.delayed(
                                                  Duration(milliseconds: 300),
                                                  () {
                                                // Optionally, you can add any additional logic here
                                              });
                                            });
                                          },
                                          child: Text(
                                            LocaleKeys
                                                .residency_details_readRules
                                                .tr(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: context
                                                  .theme.colorScheme.secondary,
                                            ),
                                          ),
                                        ),
                                      ).animate().fadeIn(delay: 800.ms),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TransparentButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) =>
                                                  CupertinoAlertDialog(
                                                title: Text(LocaleKeys
                                                    .residency_details_removeCountry
                                                    .tr(),),
                                                content: Text(LocaleKeys
                                                    .residency_details_removeCountryConfirmation
                                                    .tr(),),
                                                actions: [
                                                  CupertinoDialogAction(
                                                    child: Text(LocaleKeys
                                                        .common_cancel
                                                        .tr(),),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                  ),
                                                  CupertinoDialogAction(
                                                    isDestructiveAction: true,
                                                    child: Text(LocaleKeys
                                                        .common_remove
                                                        .tr(),),
                                                    onPressed: () {
                                                      context.pop();
                                                      context.pop();
                                                      find<CountriesCubit>(
                                                              context,)
                                                          .removeCountry(
                                                              country.isoCode,);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          leading: Icon(
                                            CupertinoIcons
                                                .rectangle_stack_badge_minus,
                                            color: Colors.redAccent,
                                            size: 24,
                                          ),
                                          child: Text(
                                            LocaleKeys
                                                .residency_details_removeCountry
                                                .tr(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ),
                                      ).animate().fadeIn(delay: 900.ms),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
