import "package:country_code_picker/country_code_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:resident_live/screens/map/cubit/country_bg_cubit.dart";
import "package:resident_live/screens/trips/model/trip_model.dart";
import "package:resident_live/screens/validate_trip/widget/trip_card/trip_card_background.dart";
import "package:resident_live/screens/validate_trip/widget/trip_card/trip_card_badge.dart";
import "package:resident_live/shared/shared.dart";

class TripCard extends StatelessWidget {
  const TripCard({required this.trip, super.key});

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    final countryName = trip.countryCode.isNotEmpty
        ? (CountryCode.fromCountryCode(trip.countryCode).localize(context).name ?? "Unknown")
        : "Unknown Country";

    return Container(
      height: 200,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: theme.bgSecondary),
      child: Stack(
        children: [
          TripCardBackground(countryCode: trip.countryCode),
          TripCardBadge(text: countryName, alignment: Alignment.topLeft),
          TripCardBadge(
            text: "${trip.fromDate.toMMMDDString()} - ${trip.toDate.toMMMDDString()}",
            alignment: Alignment.topRight,
          ),
          TripCardBadge(text: "${trip.days} days", alignment: Alignment.bottomRight),
          // Refresh button
          TripCardBadge(
            alignment: Alignment.bottomLeft,
            leading: const Icon(Icons.refresh, color: Colors.white, size: 20),
            text: "Change photo",
            onTap: () {
              context.read<CountryBackgroundCubit>().refreshCountryBackground(trip.countryCode);
            },
          ),
        ],
      ),
    );
  }
}
