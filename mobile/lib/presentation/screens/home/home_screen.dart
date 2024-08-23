import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/core/constants.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/presentation/screens/home/widgets/rl.navigation_bar.dart';
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

        print(currentResidence?.countryName);
        final otherResidences = state.user.countryResidences.values
            .where((e) => e.isoCountryCode != currentResidence?.isoCountryCode)
            .toList();

        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: CustomSliverHeaderDelegate(
                    expandedHeight: 100.0,
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
                    padding: const EdgeInsets.all(16.0),
                    child: Text("Tracking Residences",
                        style: context.theme.textTheme.titleLarge),
                  )),
                  OtherResidencesView(
                    residences: otherResidences,
                  ),
                ],
                SliverToBoxAdapter(
                    child: Gap(context.mediaQuery.padding.bottom)),
              ],
            ),
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
  double get minExtent => kToolbarHeight;

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

    return Container(
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 8.0,
            left: 16,
            right: 0,
            child: Text(
              "Resident Live",
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: context.theme.colorScheme.secondary,
              ),
            ),
          ),
          Positioned(
            bottom: 10.0,
            right: 16,
            child: GestureDetector(
              child: Icon(
                CupertinoIcons.plus_rectangle_fill_on_rectangle_fill,
                color: context.theme.colorScheme.primary,
                size: 28,
              ),
              onTap: () {
                context.pushNamed(ScreenNames.addResidency);
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: context.theme.dividerColor.withOpacity(dividerOpacity),
              height: 1.0,
              width: double.infinity,
            ),
          )
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
