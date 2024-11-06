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

const _statuses = {
  'hr': ["You're free to travel about", ""],
  'h': ["Status update in", "Status will update at"],
  'r': ["You will lose your status in", "Status is safe until"],
  'a': ["Move to this country to regain status in", "Status may be updated at"]
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
    final RenderRepaintBoundary boundary =
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
          "Track your global residency journey with Resident Live! Download now: ${appStoreLink}",
    );
  }

  @override
  Widget build(BuildContext context) {
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
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        context.theme.cardColor,
                        context.theme.scaffoldBackgroundColor,
                      ],
                    ),
                  ),
                  child: child,
                ),
                child: SafeArea(
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: AiBackButton(
                                  padding: EdgeInsets.zero,
                                  title: "Back",
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (isFocused) ...[
                                    AppAssetImage(
                                      AppAssets.target,
                                      width: 18,
                                      height: 18,
                                      color:
                                          context.theme.colorScheme.secondary,
                                    ),
                                    Gap(8),
                                  ],
                                  Text(
                                    widget.name,
                                    style: TextStyle(
                                      fontFamily: "SFPro",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  if (isHere) ...[
                                    Gap(4),
                                    Here(shorter: true),
                                  ],
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: BouncingButton(
                                    onPressed: (_) {
                                      VibrationService.instance.tap();
                                      _captureAndShareScreenshot();
                                      // ShareService.instance.shareResidence(country);
                                    },
                                    child: AppAssetImage(
                                      AppAssets.squareAndArrowUpCircle,
                                      width: 32,
                                      color: Colors.white.withOpacity(0.85),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(48),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                                    doneLabel: "You are a resident!",
                                    label: "Residency Progress",
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
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " ${country.statusToggleIn} days",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ).animate(delay: 300.ms).slideX(
                                  begin: -1.5,
                                  curve: Curves.fastEaseInToSlowEaseOut,
                                  duration: 500.ms,
                                ),
                            Text(
                              suggestionText,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                              ),
                            ).animate(delay: 300.ms).slideX(
                                  begin: -1.5,
                                  curve: Curves.fastEaseInToSlowEaseOut,
                                  duration: 500.ms,
                                ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${country.statusToggleAt.toMMMMDDYYYY()}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ).animate(delay: 500.ms).slideX(
                                      begin: -1.5,
                                      curve: Curves.fastEaseInToSlowEaseOut,
                                      duration: 500.ms,
                                    ),
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
                                            width: 1, color: Colors.white)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.calendar,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                          Gap(4),
                                          Text(
                                            "Open",
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
                                ).animate(delay: 500.ms).slideX(
                                      begin: 1.5,
                                      curve: Curves.fastEaseInToSlowEaseOut,
                                      duration: 500.ms,
                                    ),
                              ],
                            ),
                            Gap(8),
                            Row(
                              children: [
                                Expanded(
                                    child:
                                        Text("Notify me for status updates")),
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
                            if (!isFocused)
                              Align(
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
                                    "Focus on this country",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          context.theme.colorScheme.secondary,
                                    ),
                                  ),
                                ),
                              ).animate().fadeIn(delay: 700.ms),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TransparentButton(
                                leading: AppAssetImage(
                                  AppAssets.redirect,
                                  width: 24,
                                  color: context.theme.colorScheme.secondary,
                                ),
                                onPressed: () {},
                                child: Text(
                                  "Read a residency rules",
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
                                          'Are you sure you want to remove this country from tracking?'),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: Text('Cancel'),
                                          onPressed: () =>
                                              Navigator.pop(context),
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
                                  "Remove country",
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
              ),
            );
          },
        ),
      ),
    );
  }
}
