import "package:auto_size_text/auto_size_text.dart";
import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:resident_live/shared/shared.dart";

class TripContent extends StatelessWidget {
  const TripContent({required this.countryName, required this.trip, super.key});

  final String countryName;
  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: AutoSizeText(
                    countryName.toUpperCase(),
                    maxLines: 1,
                    style: theme.body18.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const Gap(60),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  trip.fromDate.toMonthYearString().replaceFirst(" ", ", "),
                  style: theme.body14.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
