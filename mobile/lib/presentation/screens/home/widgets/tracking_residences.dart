import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resident_live/core/assets/rl.asset.dart';
import 'package:resident_live/core/assets/rl.asset_image.dart';
import 'package:resident_live/core/assets/rl.assets.dart';
import 'package:resident_live/core/constants.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/presentation/navigation/screen_names.dart';
import 'package:resident_live/presentation/screens/onboarding/pages/add_periods.page.dart';
import 'package:resident_live/presentation/utils/hero_utils.dart';
import 'package:resident_live/presentation/utils/route_utils.dart';
import 'package:resident_live/presentation/widgets/rl.card.dart';
import 'package:resident_live/services/share.service.dart';

import '../../../../core/shared_state/shared_state_cubit.dart';
import '../../../../data/residence.model.dart';
import '../../residence_details/residence_details_screen.dart';

class OtherResidencesView extends StatefulWidget {
  const OtherResidencesView({Key? key, required this.residences})
      : super(key: key);

  final List<ResidenceModel> residences;

  @override
  State<StatefulWidget> createState() => _OtherResidencesViewState();
}

class _OtherResidencesViewState extends State<OtherResidencesView> {
  GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final residences = widget.residences.sublist(0, 2);
    return residences.isEmpty
        ? SizedBox()
        : Container(
            key: _listKey,
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, bottom: 13),
                  child: Text(
                    "Tracking Residences",
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color:
                          context.theme.colorScheme.secondary.withOpacity(0.87),
                    ),
                  ),
                ),
                Hero(
                  tag: 'tracking_residences',
                  flightShuttleBuilder: startFlightShuttleBuilder,
                  child: RlCard(
                    gradient: kMainGradient,
                    borderRadius: BorderRadius.circular(38),
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: [
                          ...residences
                              .sublist(0, residences.length.clamp(0, 2))
                              .map((e) => _buildItem(context, e))
                              .toList(),
                          Gap(10),
                          _SeeAll(),
                          Gap(5),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildItem(BuildContext context, ResidenceModel residence) {
    final backgroundColor = Color(0xff3C3C3C);
    final valueColor = Color(0xff8E8E8E);
    final value = residence.daysSpent;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              Text(residence.countryName,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  )),
              Spacer(),
              Column(
                children: [
                  Text(
                      maxLines: 2,
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: context.theme.colorScheme.tertiary
                              .withOpacity(0.5)),
                      "${residence.daysSpent} of 183 days"),
                ],
              )
            ],
          ),
          Gap(6),
          TweenAnimationBuilder(
            duration: 2.seconds,
            tween: Tween<double>(
              begin: 1.0,
              end: (value / 183).clamp(0.0, 1.0),
            ),
            curve: Curves.fastEaseInToSlowEaseOut,
            builder: (context, v, child) {
              return LinearProgressIndicator(
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
                value: v,
                backgroundColor: backgroundColor,
                valueColor: AlwaysStoppedAnimation(valueColor),
              ).animate().shimmer(
                duration: 1.seconds,
                delay: 1.seconds,
                stops: [1.0, 0.5, 0.0],
              );
            },
          )
        ],
      ),
    );
  }
}

class _SeeAll extends StatelessWidget {
  const _SeeAll({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'see all',
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: context.theme.colorScheme.secondary.withOpacity(0.5),
          ),
        ),
        RlAssetImage(
          RlAssets.chevronCompactDown,
          width: 21,
          color: context.theme.colorScheme.secondary.withOpacity(0.5),
        ),
      ],
    );
  }
}
