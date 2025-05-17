import "package:auto_size_text/auto_size_text.dart";
import "package:country_code_picker/country_code_picker.dart";
import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:gap/gap.dart";
import "package:go_router/go_router.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import "package:resident_live/app/injection.config.dart";
import "package:resident_live/screens/residence_details/widgets/calendar_circle_bar.dart/calendar_circle_bar.dart";
import "package:resident_live/screens/residence_details/widgets/focus_on_button/focus_on_button.dart";
import "package:resident_live/screens/residence_details/widgets/header/header.dart";
import "package:resident_live/screens/residence_details/widgets/notify_me_button/notify_me_button.dart";
import "package:resident_live/screens/residence_details/widgets/read_rules_button/read_residency_rules_button.dart";
import "package:resident_live/screens/residence_details/widgets/remove_residence_button/remove_residence_button.dart";
import "package:resident_live/screens/splash/cubit/get_user_cubit.dart";
import "package:resident_live/screens/your_journey/journey_page.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";
import "package:resident_live/shared/lib/utils/hero_utils.dart";
import "package:resident_live/shared/shared.dart";

part "widgets/calendar_buttons/today_button.dart";
part "widgets/calendar_buttons/update_button.dart";

class ResidenceDetailsScreen extends StatefulWidget {
  const ResidenceDetailsScreen({
    required this.countryCode,
    super.key,
  });
  final String countryCode;

  @override
  State<ResidenceDetailsScreen> createState() => _ResidenceDetailsScreenState();
}

class _ResidenceDetailsScreenState extends State<ResidenceDetailsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  final screenKey = GlobalKey();
  final _scrollController = ScrollController();

  double _initialDragY = 0.0;
  final double _dragThreshold = 200.0;
  final progressKey = GlobalKey();
  bool _isDraggingFromTop = false;
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

  void _finishDrag(double velocity) {
    if (_animationController.value > 0.5) {
      _animationController.forward().then((_) {
        if (mounted && context.canPop()) context.pop();
      });
    } else {
      _animationController.reverse();
    }

    // Сброс состояния
    _isDraggingFromTop = false;
    _lastScrollVelocity = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return BlocBuilder<GetUserCubit, ResourceState<UserEntity>>(
      bloc: getIt<GetUserCubit>(),
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

        final statusText = "Status update in $statusUpdateIn days";
        final country = CountryCode.fromCountryCode(widget.countryCode);

        return RepaintBoundary(
          key: screenKey,
          child: CupertinoScaffold(
            overlayStyle: getSystemOverlayStyle,
            transitionBackgroundColor: const Color(0xff121212),
            body: Builder(
              builder: (context) {
                return Material(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollUpdateNotification &&
                          notification.metrics.pixels <= 0 &&
                          notification.dragDetails != null &&
                          notification.dragDetails!.delta.dy > 0) {
                        if (!_isDraggingFromTop) {
                          _isDraggingFromTop = true;
                          _initialDragY = notification.dragDetails!.globalPosition.dy;
                        }

                        if (_isDraggingFromTop) {
                          final currentDrag = notification.dragDetails!.globalPosition.dy;
                          final dragDelta = currentDrag - _initialDragY;

                          if (notification.dragDetails!.primaryDelta != null) {
                            _lastScrollVelocity = notification.dragDetails!.primaryDelta!;
                          }

                          _animationController.value = (dragDelta / _dragThreshold).clamp(0.0, 1.0);

                          if (_animationController.value > 0.5) {
                            _animationController.forward().then((_) {
                              if (mounted) context.pop();
                            });
                          }
                          return true;
                        }
                      } else if (notification is ScrollEndNotification) {
                        if (_isDraggingFromTop) {
                          _finishDrag(_lastScrollVelocity * 20); // Умножаем на 20 для приближенного эквивалента velocity
                          return true;
                        }
                      } else if (notification is UserScrollNotification && notification.direction == ScrollDirection.idle && _isDraggingFromTop) {
                        // Дополнительная проверка для случаев, когда ScrollEndNotification может не сработать
                        _finishDrag(_lastScrollVelocity * 20);
                        return true;
                      }
                      return false;
                    },
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
                            tag: "residence_${widget.countryCode}",
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
                                color: theme.bgPrimary,
                                // gradient: LinearGradient(
                                //   begin: Alignment.topCenter,
                                //   end: Alignment.bottomCenter,
                                //   colors: [
                                //     context.theme.cardColor,
                                //     context.theme.scaffoldBackgroundColor,
                                //   ],
                                // ),
                                child: SafeArea(
                                  bottom: false,
                                  child: Builder(
                                    builder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Header(
                                              countryName: country.name ?? "",
                                              isFocused: isFocused,
                                              isHere: isHere,
                                              screenKey: screenKey,
                                            ),
                                            const Gap(16),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4.0),
                                              child: Text(
                                                "$progressInPercentage%",
                                                style: theme.title36Semi.copyWith(
                                                  height: 1.5,
                                                  fontFamily: kFontFamilySecondary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            LayoutBuilder(
                                              builder: (context, constraints) {
                                                return Container(
                                                  width: constraints.maxWidth,
                                                  height: 38,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(24.0),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(24.0),
                                                    child: DiagonalProgressBar(
                                                      progress: progress.toDouble(),
                                                      isAnimationEnabled: isHere,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            Text(
                                              statusText,
                                              style: theme.body14.copyWith(
                                                color: theme.textSecondary,
                                                height: 1.75,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            Expanded(
                                              child: FadeBorder(
                                                stops: const [0.0, 0.05],
                                                child: ListView(
                                                  controller: _scrollController,
                                                  children: [
                                                    const Gap(24),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        _TodayButton(
                                                          onTap: () {
                                                            CupertinoScaffold.showCupertinoModalBottomSheet(
                                                              useRootNavigator: true,
                                                              context: context,
                                                              duration: 300.ms,
                                                              animationCurve: Curves.fastEaseInToSlowEaseOut,
                                                              builder: (context) => ResidencyJourneyScreen(
                                                                initialDate: DateTime.now(),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                        const Gap(4),
                                                        _UpdateButton(
                                                          onTap: () {
                                                            CupertinoScaffold.showCupertinoModalBottomSheet(
                                                              useRootNavigator: true,
                                                              context: context,
                                                              duration: 300.ms,
                                                              animationCurve: Curves.fastEaseInToSlowEaseOut,
                                                              builder: (context) => ResidencyJourneyScreen(
                                                                initialDate: statusUpdateAt,
                                                              ),
                                                            );
                                                          },
                                                          date: statusUpdateAt,
                                                        ),
                                                      ],
                                                    ).animate(delay: 500.ms).fadeIn(delay: 400.ms),
                                                    const Gap(16),
                                                    FractionallySizedBox(
                                                      widthFactor: 0.85,
                                                      child: CalendarCircleBar(
                                                        dividerColor: context.theme.scaffoldBackgroundColor,
                                                        stayPeriods: countryStayPeriods,
                                                        progress: "$daysSpent/183",
                                                        backgroundColor: const Color.fromARGB(255, 54, 95, 137).withValues(alpha: 0.2),
                                                        activeColor: Colors.green,
                                                        statusUpdateDate: statusUpdateAt,
                                                        centerTextStyle: theme.title32Semi.copyWith(
                                                          fontWeight: FontWeight.w300,
                                                          color: theme.textSecondary,
                                                          fontSize: 30,
                                                          fontFamily: kFontFamilySecondary,
                                                        ),
                                                        centerSubtitleStyle: theme.body16.copyWith(
                                                          fontWeight: FontWeight.w300,
                                                          color: theme.textSecondary,
                                                          fontFamily: kFontFamilySecondary,
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
                                                              final date = DateTime(now.year, (index + 1) % 12, now.day);
                                                              return ResidencyJourneyScreen(
                                                                initialDate: date,
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ).animate(),
                                                    const Gap(32),
                                                    const NotifyMeButton().animate().fadeIn(delay: 600.ms),
                                                    const Gap(24),
                                                    const Divider(
                                                      color: Color(0x88888888),
                                                    ).animate().fadeIn(delay: 700.ms),
                                                    const Gap(8),
                                                    FocusOnButton(isFocused: isFocused, countryCode: widget.countryCode),
                                                    const ReadResidencyRulesButton().animate().fadeIn(delay: 900.ms),
                                                    const RemoveResidenceButton().animate().fadeIn(delay: 1000.ms),
                                                    const Gap(40),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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
      },
    );
  }
}
