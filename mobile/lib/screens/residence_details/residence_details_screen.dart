import "package:auto_size_text/auto_size_text.dart";
import "package:country_code_picker/country_code_picker.dart";
import "package:data/data.dart";
import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:gap/gap.dart";
import "package:go_router/go_router.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/gen/translations.g.dart";
import "package:resident_live/screens/residence_details/widgets/calendar_buttons/calendar_buttons.dart";

import "package:resident_live/screens/residence_details/widgets/calendar_circle_bar.dart/calendar_circle_bar.dart";
import "package:resident_live/screens/residence_details/widgets/focus_on_button/focus_on_button.dart";
import "package:resident_live/screens/residence_details/widgets/header/header.dart";
import "package:resident_live/screens/residence_details/widgets/notify_me_button/notify_me_button.dart";
import "package:resident_live/screens/residence_details/widgets/progress_bar/details_progress_bar.dart";
import "package:resident_live/screens/residence_details/widgets/read_rules_button/read_rules_button.dart";
import "package:resident_live/screens/residence_details/widgets/remove_residence_button/remove_residence_button.dart";
import "package:resident_live/screens/splash/cubit/get_user_cubit.dart";
import "package:resident_live/screens/your_journey/journey_page.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";
import "package:resident_live/shared/lib/utils/hero_utils.dart";
import "package:resident_live/shared/shared.dart";

part "helper/swipe_to_dismiss.dart";

final _logger = getIt<LoggerService>();

class ResidenceDetailsScreen extends StatefulWidget {
  const ResidenceDetailsScreen({required this.countryCode, super.key});
  final String countryCode;

  @override
  State<ResidenceDetailsScreen> createState() {
    return _ResidenceDetailsScreenState();
  }
}

class _ResidenceDetailsScreenState extends State<ResidenceDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  final screenKey = GlobalKey();
  final _scrollController = ScrollController();

  final progressKey = GlobalKey();
  bool _isDraggingFromTop = false;
  bool _isDragging = false;
  double _lastScrollVelocity = 0.0;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.75).animate(_animationController);
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(_animationController);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return BlocProvider(
      create: (context) => getIt<GetUserCubit>(),
      child: BlocBuilder<GetUserCubit, ResourceState<UserEntity>>(
        builder: (context, user) {
          final countryStayPeriods = user.data?.countries[widget.countryCode] ?? [];

          final allStayPeriods = user.data?.stayPeriods;
          final daysSpent = countryStayPeriods.fold<int>(0, (prev, element) => prev + element.days);

          final isHere = allStayPeriods?.last.countryCode == widget.countryCode;

          final isResident = daysSpent > 183;

          final isFocused = user.data?.focusedCountryCode == widget.countryCode;

          final statusUpdateIn = (183 - daysSpent).abs();
          final statusUpdateAt = DateTime.now().add(Duration(days: statusUpdateIn));

          final progress = isResident ? 1.0 : daysSpent / 183;
          final progressInPercentage = (progress * 100).toInt();

          final statusText = isResident
              ? context.t.details.resident
              : context.t.details.notResident(days: statusUpdateIn);
          final country = CountryCode.fromCountryCode(widget.countryCode).localize(context);

          return RepaintBoundary(
            key: screenKey,
            child: CupertinoScaffold(
              overlayStyle: getSystemOverlayStyle,
              transitionBackgroundColor: const Color(0xff121212),
              body: Material(
                child: _SwipeToDismiss(
                  onDismiss: () {
                    context.pop();
                  },
                  animationController: _animationController,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _opacityAnimation.value,
                        child: Transform.scale(scale: _scaleAnimation.value, child: child),
                      );
                    },
                    child: Hero(
                      tag: "residence_${widget.countryCode}",
                      flightShuttleBuilder:
                          (
                            flightContext,
                            animation,
                            flightDirection,
                            fromHeroContext,
                            toHeroContext,
                          ) {
                            return toSecondHeroFlightShuttleBuilder(
                              flightContext: flightContext,
                              animation: animation,
                              flightDirection: flightDirection,
                              fromHeroContext: fromHeroContext,
                              toHeroContext: toHeroContext,
                            );
                          },
                      child: SafeArea(
                        bottom: false,
                        child: Material(
                          color: Colors.transparent,
                          child: RlCard(
                            margin: EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            color: const Color(0xff090909),
                            child: Builder(
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: ListView(
                                    children: [
                                      Grabber(),
                                      context.vBox16,
                                      DetailsHeader(
                                        countryName: country.name ?? "",
                                        isFocused: isFocused,
                                        isHere: isHere,
                                        screenKey: screenKey,
                                      ),
                                      const Gap(16),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            DetailsProgressBar(
                                              progress: progress,
                                              progressInPercentage: progressInPercentage,
                                              status: statusText,
                                            ),
                                            context.vBox12,
                                            CalendarButtons(statusUpdateAt: statusUpdateAt),
                                          ],
                                        ),
                                      ),
                                      const Gap(16),
                                      Align(
                                        alignment: Alignment.center,
                                        child: FractionallySizedBox(
                                          widthFactor: 0.85,
                                          child: CalendarCircleBar(
                                            dividerColor: context.theme.scaffoldBackgroundColor,
                                            stayPeriods: countryStayPeriods,
                                            progress: "$daysSpent/183",
                                            backgroundColor: const Color.fromARGB(
                                              255,
                                              54,
                                              95,
                                              137,
                                            ).withValues(alpha: 0.2),
                                            activeColor: Colors.green,
                                            statusUpdateDate: statusUpdateAt,
                                            centerTextStyle: theme.title20Semi.copyWith(
                                              color: theme.textPrimary.withValues(alpha: 0.8),
                                              // fontFamily: kFontFamilySecondary,
                                            ),
                                            centerSubtitleStyle: theme.body14.copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: theme.textSecondary,
                                              // fontFamily: kFontFamilySecondary,
                                              letterSpacing: 0.5,
                                            ),
                                            monthTextStyle: theme.body12.copyWith(
                                              fontWeight: FontWeight.w100,
                                              fontFamily: kFontFamilySecondary,
                                              fontSize: 10,
                                              letterSpacing: 0.5,
                                            ),
                                            onMonthTap: (index) {
                                              CupertinoScaffold.showCupertinoModalBottomSheet(
                                                useRootNavigator: true,
                                                context: context,
                                                duration: 300.ms,
                                                animationCurve: Curves.fastEaseInToSlowEaseOut,
                                                builder: (context) {
                                                  final now = DateTime.now();
                                                  final date = DateTime(
                                                    now.year,
                                                    (index + 1) % 12,
                                                    now.day,
                                                  );
                                                  return ResidencyJourneyScreen(initialDate: date);
                                                },
                                              );
                                            },
                                          ),
                                        ).animate(),
                                      ),
                                      const Gap(32),
                                      const NotifyMeButton().animate().fadeIn(delay: 600.ms),
                                      const Gap(24),
                                      const Divider(
                                        color: Color(0x88888888),
                                      ).animate().fadeIn(delay: 700.ms),
                                      const Gap(8),
                                      FocusOnButton(
                                        isFocused: isFocused,
                                        countryCode: widget.countryCode,
                                      ),
                                      const ReadResidencyRulesButton().animate().fadeIn(
                                        delay: 900.ms,
                                      ),
                                      const RemoveResidenceButton().animate().fadeIn(
                                        delay: 1000.ms,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
