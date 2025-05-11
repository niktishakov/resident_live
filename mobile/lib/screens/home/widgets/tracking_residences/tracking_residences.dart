import "package:country_code_picker/country_code_picker.dart";
import "package:domain/domain.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:resident_live/localization/generated/l10n/l10n.dart";
import "package:resident_live/shared/lib/utils/hero_utils.dart";
import "package:resident_live/shared/shared.dart";

part "residence_item.dart";

class OtherResidencesView extends StatefulWidget {
  const OtherResidencesView({
    required this.residences,
    required this.onTap,
    super.key,
  });

  final Map<String, List<StayPeriodValueObject>> residences;
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
    final residences = widget.residences.entries.take(2).toList();

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
                            ...residences.map(
                              (e) => _ResidenceItem(
                                countryCode: e.key,
                                stayPeriods: e.value,
                              ),
                            ),
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
