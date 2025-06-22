import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:resident_live/screens/add_trip/cubit/add_trip_cubit.dart";
import "package:resident_live/screens/trips/model/trip_model.dart";
import "package:resident_live/shared/shared.dart";
import "package:resident_live/shared/widget/rl.card.dart";

class TripStayPeriod extends StatelessWidget {
  const TripStayPeriod({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    return BlocBuilder<AddTripCubit, AddTripState>(
      builder: (context, state) {
        final days = state.trip.days;
        final fromDate = state.trip.fromDate;
        final toDate = state.trip.toDate;

        return RlCard(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),

          child: Column(
            children: [
              Row(children: [Text("Stay Period"), const Spacer(), Text("$days days")]),
              context.vBox24,
              Row(
                children: [
                  Text("From Date", style: theme.body16M.copyWith(color: theme.textPrimary)),
                  const Spacer(),
                  RlCard(
                    borderRadius: 8,
                    padding: const EdgeInsets.all(8),
                    color: theme.bgAccent,
                    child: Text(
                      fromDate.toMMMDDString(),
                      style: theme.body16M.copyWith(color: theme.textPrimaryOnColor),
                    ),
                  ),
                ],
              ),
              context.vBox16,
              Row(
                children: [
                  Text("To Date", style: theme.body16M.copyWith(color: theme.textPrimary)),
                  const Spacer(),
                  RlCard(
                    borderRadius: 8,
                    padding: const EdgeInsets.all(8),
                    color: theme.bgAccent,
                    child: Text(
                      toDate.toMMMDDString(),
                      style: theme.body16M.copyWith(color: theme.textPrimaryOnColor),
                    ),
                  ),
                ],
              ),
              context.vBox8,
            ],
          ),
        );
      },
    );
  }
}
