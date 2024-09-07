import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resident_live/core/constants.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/core/extensions/datetime_extension.dart';
import 'package:resident_live/presentation/screens/home/widgets/rl.navigation_bar.dart';
import 'package:resident_live/presentation/widgets/bouncing_button.dart';
import 'package:resident_live/presentation/widgets/primary_button.dart';
import 'package:resident_live/presentation/widgets/rl.card.dart';
import 'package:resident_live/presentation/widgets/today_button.dart';
import '../../../core/shared_state/shared_state_cubit.dart';
import '../../navigation/screen_names.dart';
import 'widgets/current_residence.dart';
import 'widgets/other_residences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SharedStateCubit, SharedStateState>(
      builder: (context, state) {
        final currentResidence =
            state.user.countryResidences[state.currentPosition?.isoCountryCode];

        final otherResidences = state.user.countryResidences.values
            .where((e) => e.isoCountryCode != currentResidence?.isoCountryCode)
            .toList();

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: CustomSliverHeaderDelegate(
                  expandedHeight: 80.0 + context.mediaQuery.padding.top,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0, bottom: 16),
                  child: TodayButton(),
                ),
              ),
              if (currentResidence != null) ...[
                SliverToBoxAdapter(
                  child: CurrentResidenceView(
                    residence: currentResidence,
                  ),
                ),
              ],
              if (otherResidences.isNotEmpty) ...[
                SliverToBoxAdapter(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16),
                  child: Text("Tracking Residences",
                      style: context.theme.textTheme.titleLarge),
                )),
                OtherResidencesView(
                  residences: otherResidences,
                ),
              ],
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                  child: BouncingButton(
                    onPressed: (_) =>
                        context.pushNamed(ScreenNames.addResidency),
                    child: RlCard(
                      color: context.theme.primaryColor,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.add_circled_solid,
                              color: Colors.white,
                            ),
                            Gap(4),
                            Text("Add",
                                style: context.theme.textTheme.labelLarge
                                    ?.copyWith(
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Gap(context.mediaQuery.padding.bottom + 64)),
            ],
          ),
        );
      },
    );
  }
}

class CustomSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  CustomSliverHeaderDelegate({required this.expandedHeight});

  @override
  double get minExtent => kToolbarHeight + 44;

  @override
  double get maxExtent => expandedHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final proportion = (expandedHeight - shrinkOffset) / expandedHeight;
    const largeSize = 32.0;
    const smallSize = 18.0;

    // Calculate the title size based on the scroll proportion
    final titleSize = (largeSize * proportion).clamp(smallSize, largeSize);

    // Calculate the horizontal position from left to center
    final titleLeftPadding =
        0.0 + (MediaQuery.of(context).size.width / 4 - 0.0) * (1 - proportion);

    // Divider opacity - 0.0 when fully expanded, 1.0 when fully collapsed
    final double dividerOpacity = 1 - proportion;

    return ClipRect(
      child: Container(
        color: context.theme.scaffoldBackgroundColor,
        child: ColoredBox(
          color: context.theme.dialogBackgroundColor
              .withOpacity(dividerOpacity.clamp(0.0, 1.0)),
          child: Stack(
            children: [
              Positioned(
                bottom: 10.0,
                left: 24,
                right: 0,
                child: Text(
                  "Resident Live",
                  style: GoogleFonts.besley(
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.secondary,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              Positioned(
                bottom: 12.0,
                right: 24,
                child: Opacity(
                  opacity: dividerOpacity > 0.4
                      ? (3.5 * dividerOpacity - 1.0).clamp(0.0, 1.0)
                      : 0.0,
                  child: TodayButton(
                      iconSize: 20,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.theme.colorScheme.secondary,
                      )),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: context.theme.dividerColor.withOpacity(dividerOpacity),
                  height: 2.0,
                  width: double.infinity,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
