import "dart:math";

import "package:domain/domain.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:resident_live/localization/generated/l10n/l10n.dart";
import "package:resident_live/shared/lib/utils/hero_utils.dart";
import "package:resident_live/shared/shared.dart";

class OtherResidencesView extends StatefulWidget {
  const OtherResidencesView({
    required this.residences,
    required this.onTap,
    super.key,
  });

  final List<CountryEntity> residences;
  final Future? Function() onTap;

  @override
  State<StatefulWidget> createState() => _OtherResidencesViewState();
}

class _OtherResidencesViewState extends State<OtherResidencesView> {
  final _listKey = GlobalKey<SliverAnimatedListState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final residences = widget.residences.sublist(0, min(widget.residences.length, 2));
    final beginBorderRadius = BorderRadius.circular(38);
    return residences.isEmpty
        ? const SizedBox()
        : Container(
            key: _listKey,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, bottom: 13),
                  child: Text(
                    S.of(context).homeTrackingResidences,
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: context.theme.colorScheme.secondary.withValues(alpha: 0.87),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Hero(
                    tag: "tracking_residences",
                    flightShuttleBuilder: (
                      flightContext,
                      animation,
                      flightDirection,
                      fromHeroContext,
                      toHeroContext,
                    ) =>
                        toFirstHeroFlightShuttleBuilder(
                      flightContext: flightContext,
                      animation: animation,
                      flightDirection: flightDirection,
                      fromHeroContext: fromHeroContext,
                      toHeroContext: toHeroContext,
                      beginBorderRadius: beginBorderRadius.topLeft.x,
                    ),
                    child: RlCard(
                      gradient: kMainGradient,
                      borderRadius: beginBorderRadius.topLeft.x,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          children: [
                            ...residences.sublist(0, residences.length.clamp(0, 2)).map((e) => _buildItem(context, e)),
                            const Gap(10),
                            const _SeeAll(),
                            const Gap(5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildItem(BuildContext context, CountryEntity residence) {
    const backgroundColor = Color(0xff3C3C3C);
    const valueColor = Color(0xff8E8E8E);
    final value = residence.daysSpent;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                residence.name,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    maxLines: 2,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: context.theme.colorScheme.tertiary.withValues(alpha: 0.5),
                    ),
                    "${residence.daysSpent} / 183 ${S.of(context).homeDays}",
                  ),
                ],
              ),
            ],
          ),
          const Gap(6),
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
  }
}

class _SeeAll extends StatelessWidget {
  const _SeeAll();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          S.of(context).homeSeeAll,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: context.theme.colorScheme.secondary.withValues(alpha: 0.5),
          ),
        ),
        AppAssetImage(
          AppAssets.chevronCompactDown,
          width: 21,
          color: context.theme.colorScheme.secondary.withValues(alpha: 0.5),
        ),
      ],
    );
  }
}
