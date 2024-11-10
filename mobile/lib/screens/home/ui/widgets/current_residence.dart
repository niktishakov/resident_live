import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resident_live/domain/domain.dart';
import 'package:resident_live/features/features.dart';
import 'package:resident_live/shared/shared.dart';

class CurrentResidenceView extends StatelessWidget {
  const CurrentResidenceView({
    Key? key,
    required this.country,
    required this.onTap,
  }) : super(key: key);
  final CountryEntity country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LocationCubit>().state;
    final isHere = state.isCurrentResidence(country.isoCode);
    final beginBorderRadius = BorderRadius.circular(24);
    return CupertinoContextMenu(
      enableHapticFeedback: true,
      actions: [
        CupertinoContextMenuAction(
            child: Text("Share"),
            trailingIcon: CupertinoIcons.share,
            onPressed: () {
              ShareService.instance.shareResidence(country);
              context.pop();
            }),
      ],
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Material(
            borderRadius: beginBorderRadius,
            elevation: 0,
            color: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(
                // maxHeight: 230,
                maxWidth: context.mediaQuery.size.width,
              ),
              child: Hero(
                tag: 'residence_${country.name}',
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
                  endBorderRadius: kLargeBorderRadius.topLeft.x,
                ),
                child: Material(
                  color: Colors.transparent,
                  elevation: 0,
                  child: RlCard(
                    gradient: kMainGradient,
                    borderRadius: beginBorderRadius,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Your Focus",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Spacer(),
                            if (isHere) Here(),
                          ],
                        ),
                        Text(
                          country.name,
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 24),
                        _buildProgressIndicator(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final backgroundColor = country.isResident
        ? context.theme.primaryColor
        : context.theme.colorScheme.tertiary;
    final color = context.theme.primaryColor;
    final value = country.isResident ? 183 : country.daysSpent;
    final double progress = (value / 183).clamp(0, 1.0);
    // final progress = 1.0;

    return LayoutBuilder(
      builder: (context, ctrx) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${country.daysSpent}/183 days",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: context.theme.colorScheme.secondary.withOpacity(0.5),
              ),
            ),
            Gap(2),
            Text(
              "${(value / 183 * 100).round()}%",
              style: GoogleFonts.poppins(
                fontSize: 64,
                fontWeight: FontWeight.w500,
                color: context.theme.colorScheme.secondary,
                height: 57 / 64,
              ),
            ),
            Gap(16),
            Container(
              width: ctrx.maxWidth,
              height: 62,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: DiagonalProgressBar(progress: progress),
              ),
            ),
            Gap(8),
          ],
        );
      },
    );
  }
}
