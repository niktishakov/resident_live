import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:resident_live/domain/domain.dart';
import 'package:resident_live/shared/ui/rl.sliver_header.dart';
import 'package:resident_live/widgets/widgets.dart';
import 'package:share_plus/share_plus.dart';

import '../../features/features.dart';
import '../../shared/shared.dart';
import 'widgets/residency_rules_modal.dart';

const _statuses = {
  'hr': ["You're free to travel about", 'You can travel until'],
  'h': ['Status update in', 'Status will update at'],
  'r': ['You will lose your status in', 'Status is safe until'],
  'a': ['Move to this country to reach status in', 'Status may be updated at'],
};

List<String> getStatusMessage(bool isHere, bool isResident) =>
    _statuses[isHere && isResident
        ? 'hr'
        : isHere
            ? 'h'
            : isResident
                ? 'r'
                : 'a']!;

class ResidenceDetailsScreen2 extends StatefulWidget {
  const ResidenceDetailsScreen2({super.key, required this.name});
  final String name;

  @override
  State<ResidenceDetailsScreen2> createState() =>
      _ResidenceDetailsScreen2State();
}

class _ResidenceDetailsScreen2State extends State<ResidenceDetailsScreen2>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final screenKey = GlobalKey();

  final progressKey = GlobalKey();

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _captureAndShareScreenshot() async {
    final boundary =
        screenKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    await Share.shareXFiles(
      [
        XFile.fromData(
          bytes,
          name: 'residence_status.png',
          mimeType: 'image/png',
        ),
      ],
      text:
          'Track your global residency journey with Resident Live! Download now: $appStoreLink',
    );
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

    final progress = country.isResident
        ? 1.0
        : (country.daysSpent) / Duration(days: 183).inDays;

    final statuses = getStatusMessage(isHere, isResident);
    final statusText = statuses.first;
    final suggestionText = statuses.last;

    return RepaintBoundary(
      key: screenKey,
      child: Material(
        child: Builder(
          builder: (context) {
            return AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) => RlCard(
                borderRadius: BorderRadius.circular(0),
                padding: EdgeInsets.zero,
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
              child: CupertinoPageScaffold(
                backgroundColor: Colors.transparent,
                navigationBar: CupertinoNavigationBar(
                  backgroundColor: Colors.transparent,
                  leading: AiBackButton(
                    padding: EdgeInsets.zero,
                    title: 'Back',
                  ),
                  trailing: BouncingButton(
                    onPressed: (_) {
                      VibrationService.instance.tap();
                      _captureAndShareScreenshot();
                    },
                    child: AppAssetImage(
                      AppAssets.squareAndArrowUpCircle,
                      width: 32,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                  middle: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isFocused) ...[
                        AppAssetImage(
                          AppAssets.target,
                          width: 18,
                          height: 18,
                          color: context.theme.colorScheme.secondary,
                        ),
                        Gap(8),
                      ],
                      Text(
                        widget.name,
                        style: theme.title16Semi.copyWith(
                          fontFamily: 'SFPro',
                          color: theme.textPrimaryOnColor,
                          fontSize: 17,
                        ),
                      ),
                      if (isHere) ...[
                        Gap(4),
                        Here(shorter: true),
                      ],
                    ],
                  ),
                ),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Gap(48),
                    Padding(
                      padding: context.paddingEdges24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                  doneLabel: 'You are a resident!',
                                  label: 'Residency Progress',
                                  backgroundColor: Color(0xff3C3C3C),
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
                                  text: '\n${country.statusToggleIn} days',
                                  style: theme.body18M
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          )
                              .animate(delay: 500.ms)
                              .slideX(
                                begin: -2,
                                curve: Curves.fastEaseInToSlowEaseOut,
                                duration: 500.ms,
                              )
                              .fade(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          fontWeight: FontWeight.w700,),
                                    ),
                                  ],
                                ),
                              )
                                  .animate(delay: 500.ms)
                                  .slideX(
                                    begin: -2,
                                    curve: Curves.fastEaseInToSlowEaseOut,
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
                                    animationCurve:
                                        Curves.fastEaseInToSlowEaseOut,
                                    builder: (context) =>
                                        ResidencyJourneyScreen(),
                                  );
                                },
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                          width: 1, color: Colors.white,),),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
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
                                          'Open',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
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
                                    curve: Curves.fastEaseInToSlowEaseOut,
                                    duration: 500.ms,
                                  )
                                  .fade(),
                            ],
                          ),
                          Gap(8),
                          Row(
                            children: [
                              Expanded(
                                  child: Text('Notify me for status updates'),),
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
                            tween:
                                Tween<double>(begin: 0, end: isFocused ? 0 : 1),
                            builder: (context, value, child) {
                              return SizedBox(
                                height: value * 40,
                                child: Transform.translate(
                                  offset: Offset(-20 * (1 - value), 0),
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
                                  color: context.theme.colorScheme.secondary,
                                ),
                                onPressed: () {
                                  find<CountriesCubit>(context)
                                      .setFocusedCountry(country);
                                },
                                child: Text(
                                  'Focus on this country',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: context.theme.colorScheme.secondary,
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
                                color: context.theme.colorScheme.secondary,
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  useRootNavigator: true,
                                  useSafeArea: false,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  transitionAnimationController:
                                      AnimationController(
                                    vsync: Navigator.of(context),
                                    duration: const Duration(milliseconds: 300),
                                  ),
                                  builder: (_) => ResidencyRulesModal(),
                                ).then((_) {
                                  // Fade out the blur effect when the modal is dismissed
                                  Future.delayed(Duration(milliseconds: 300),
                                      () {
                                    // Optionally, you can add any additional logic here
                                  });
                                });
                              },
                              child: Text(
                                'Read a residency rules',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: context.theme.colorScheme.secondary,
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
                                  builder: (context) => CupertinoAlertDialog(
                                    title: Text('Remove Country'),
                                    content: Text(
                                        'Are you sure you want to remove this country from tracking?',),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: Text('Cancel'),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      CupertinoDialogAction(
                                        isDestructiveAction: true,
                                        child: Text('Remove'),
                                        onPressed: () {
                                          context.pop();
                                          context.pop();
                                          find<CountriesCubit>(context)
                                              .removeCountry(country.isoCode);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              leading: Icon(
                                CupertinoIcons.rectangle_stack_badge_minus,
                                color: Colors.redAccent,
                                size: 24,
                              ),
                              child: Text(
                                'Remove country',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ).animate().fadeIn(delay: 900.ms),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
