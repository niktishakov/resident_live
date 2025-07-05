import "package:domain/domain.dart";
import "package:flutter/material.dart";
import "package:resident_live/screens/trip_details/widgets/risk_item_widget.dart";
import "package:resident_live/shared/shared.dart";

class TripRiskAnalysisWidget extends StatelessWidget {
  const TripRiskAnalysisWidget({required this.trip, super.key});

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
            "Risk Analysis",
            style: theme.body16.copyWith(color: theme.textPrimary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          const RiskItemWidget(label: "Tax Residency Risk", value: "Low", color: Colors.green),
          const SizedBox(height: 12),
          const RiskItemWidget(
            label: "Stay Period Compliance",
            value: "Compliant",
            color: Colors.green,
          ),
          const SizedBox(height: 12),
          RiskItemWidget(
            label: "Annual Days Count",
            value: "${trip.days} / 183 days",
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
