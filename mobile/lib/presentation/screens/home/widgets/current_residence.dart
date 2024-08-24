import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:resident_live/core/constants.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import '../../../../data/residence.model.dart';

class CurrentResidenceView extends StatelessWidget {
  final ResidenceModel residence;

  const CurrentResidenceView({
    Key? key,
    required this.residence,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          border: Border.all(
              width: 0.5,
              color: context.theme.colorScheme.secondary.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              offset: Offset(5, 5),
              color: context.theme.colorScheme.secondary.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
          borderRadius: kBorderRadius,
        ),
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    residence.countryName,
                    style: context.theme.textTheme.titleLarge,
                  ),
                  Spacer(),
                  Text("Here",
                      style: context.theme.textTheme.labelMedium?.copyWith(
                          color: context.theme.colorScheme.secondary)),
                  Gap(2),
                  Icon(
                    CupertinoIcons.circle_filled,
                    color: Colors.red,
                    size: 16,
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .fadeIn(duration: 300.ms, delay: 200.ms)
                      .then() // Starts the next animation after the previous ends
                      .fadeOut(duration: 300.ms, delay: 1000.ms),
                ],
              ),
              SizedBox(height: 8),
              SizedBox(height: 16),
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
    );
  }

  Widget _buildResidentInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "You are a resident",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            // color: context.theme.primaryColor,
          ),
        ),
        Text(
          "${residence.daysSpent - 183} days available",
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
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
    const color = Colors.green;
    final value =
        residence.isResident ? residence.daysSpent - 183 : residence.daysSpent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Progress to Residency",
          style: TextStyle(fontSize: 18),
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
              minHeight: 20,
              borderRadius: BorderRadius.circular(10),
              color: color,
            ).animate().shimmer(duration: 1.seconds, delay: 2.seconds);
          },
        ),
        SizedBox(height: 8),
        Text(
          "${(residence.daysSpent / 183 * 100).toStringAsFixed(1)}% of 183 days",
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ],
    );
  }
}
