import "package:domain/domain.dart";
import "package:flutter/material.dart";
import "package:resident_live/screens/trip_details/widgets/stat_item_widget.dart";
import "package:resident_live/screens/trips/widget/trip_carousel/trip_carousel_card.dart";
import "package:resident_live/shared/shared.dart";

class TripStatsWidget extends StatelessWidget {
  const TripStatsWidget({required this.trip, super.key});

  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: theme.bgModal, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Trip Details",
            style: theme.body16.copyWith(color: theme.textPrimary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StatItemWidget(label: "Duration", value: "${trip.days} days"),
              ),
              Expanded(
                child: StatItemWidget(label: "Status", value: trip.statusText),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatItemWidget(label: "Start Date", value: trip.fromDate.toMMMDDString()),
              ),
              Expanded(
                child: StatItemWidget(label: "End Date", value: trip.toDate.toMMMDDString()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
