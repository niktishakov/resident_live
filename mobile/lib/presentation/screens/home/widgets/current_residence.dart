import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resident_live/core/constants.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/core/extensions/datetime_extension.dart';
import 'package:resident_live/presentation/screens/residence_details/residence_details_screen.dart';
import 'package:resident_live/presentation/utils/hero_utils.dart';
import 'package:resident_live/presentation/utils/route_utils.dart';
import 'package:resident_live/presentation/widgets/here.dart';
import 'package:resident_live/presentation/widgets/rl.card.dart';
import 'package:resident_live/services/share.service.dart';
import '../../../../data/residence.model.dart';

class CurrentResidenceView extends StatelessWidget {
  final ResidenceModel residence;

  const CurrentResidenceView({
    Key? key,
    required this.residence,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoContextMenu(
      enableHapticFeedback: true,
      actions: [
        CupertinoContextMenuAction(
            child: Text("Share"),
            trailingIcon: CupertinoIcons.share,
            onPressed: () {
              ShareService.instance.shareResidence(residence);
              context.pop();
            }),
      ],
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          kDefaultFadeRouteBuilder(
            page: ResidenceDetailsScreen(countryName: residence.countryName),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Material(
            borderRadius: kBorderRadius,
            elevation: 0,
            color: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 230,
                maxWidth: context.mediaQuery.size.width,
              ),
              child: Hero(
                tag: 'residence_${residence.countryName}',
                flightShuttleBuilder: startFlightShuttleBuilder,
                child: Material(
                  color: Colors.transparent,
                  elevation: 0,
                  child: RlCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              residence.countryName,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                            Here(),
                          ],
                        ),
                        SizedBox(height: 16),
                        if (residence.isResident)
                          _buildResidentInfo(context)
                        else
                          _buildNonResidentInfo(context),
                        Gap(20),
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

  Widget _buildResidentInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "You're available to travel",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "${residence.daysSpent - 183} days for free",
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xff63FF3C)),
        ),
      ],
    );
  }

  Widget _buildNonResidentInfo(BuildContext context) {
    final daysSpent = residence.daysSpent;
    final daysLeft = 183 - daysSpent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "To become a resident",
          style: TextStyle(fontSize: 18),
        ),
        Text(
          "$daysLeft days left",
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: context.theme.primaryColor),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final backgroundColor = residence.isResident
        ? context.theme.primaryColor
        : context.theme.colorScheme.tertiary;
    final color = context.theme.primaryColor;
    final value = residence.isResident ? 183 : residence.daysSpent;
    final title =
        residence.isResident ? "You are a resident" : "Progress to a Residency";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title,
                style: context.theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            Spacer(),
            Text(
              "${value} days of 183",
              style: TextStyle(
                  fontSize: 14,
                  color: context.theme.colorScheme.tertiary.withOpacity(0.5)),
            )
          ],
        ),
        SizedBox(height: 8),
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: value / 183),
          duration: 2.seconds,
          curve: Curves.fastEaseInToSlowEaseOut,
          builder: (context, v, child) {
            return LinearProgressIndicator(
              value: v,
              backgroundColor: backgroundColor,
              valueColor: AlwaysStoppedAnimation(
                residence.isResident
                    ? Color(0xff63FF3C)
                    : context.theme.primaryColor,
              ),
              minHeight: 20,
              borderRadius: kBorderRadius,
              color: color,
            ).animate().shimmer(duration: 1.seconds, delay: 2.seconds);
          },
        ),
      ],
    );
  }
}
