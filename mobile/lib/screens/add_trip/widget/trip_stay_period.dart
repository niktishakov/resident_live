import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:resident_live/screens/add_trip/cubit/add_trip_cubit.dart";
import "package:resident_live/screens/trips/model/trip_model.dart";
import "package:resident_live/shared/lib/utils/dependency_squirrel.dart";
import "package:resident_live/shared/shared.dart";

Future<DateTime?> showCupertinoDatePicker(
  BuildContext context,
  DateTime initialDate, {
  DateTime? minimumDate,
  DateTime? maximumDate,
}) {
  final theme = context.rlTheme;

  return showModalBottomSheet<DateTime?>(
    context: context,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    isScrollControlled: false,
    builder: (context) {
      var selectedDate = initialDate;

      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: theme.bgPrimary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Grabber(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel", style: TextStyle(color: theme.textAccent)),
                ),
                Text("Select Date", style: theme.title16Semi.copyWith(color: theme.textPrimary)),
                TextButton(
                  onPressed: () => Navigator.pop(context, selectedDate),
                  child: Text("Done", style: TextStyle(color: theme.textAccent)),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: initialDate,
                minimumDate: minimumDate,
                maximumDate: maximumDate,
                onDateTimeChanged: (newDate) {
                  selectedDate = newDate;
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

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

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: RlCard(
            child: Column(
              children: [
                Row(children: [const Text("Stay Period"), const Spacer(), Text("$days days")]),
                context.vBox24,
                Row(
                  children: [
                    Text("From Date", style: theme.body16M.copyWith(color: theme.textPrimary)),
                    const Spacer(),
                    BouncingButton(
                      onPressed: () async {
                        final date = await showCupertinoDatePicker(context, fromDate);
                        if (date != null && context.mounted) {
                          final cubit = find<AddTripCubit>(context);
                          var newToDate = toDate;

                          // If new fromDate is not before toDate, adjust toDate to be next day
                          if (!date.isBefore(toDate)) {
                            newToDate = date.add(const Duration(days: 1));
                          }

                          cubit.updateTripModel(
                            cubit.state.trip.copyWith(fromDate: date, toDate: newToDate),
                          );
                        }
                      },
                      child: RlCard(
                        borderRadius: 8,
                        padding: const EdgeInsets.all(8),
                        color: theme.bgAccent,
                        child: Text(
                          fromDate.toMMMDDString(),
                          style: theme.body16M.copyWith(color: theme.textPrimaryOnColor),
                        ),
                      ),
                    ),
                  ],
                ),
                context.vBox16,
                Row(
                  children: [
                    Text("To Date", style: theme.body16M.copyWith(color: theme.textPrimary)),
                    const Spacer(),
                    BouncingButton(
                      onPressed: () async {
                        final date = await showCupertinoDatePicker(
                          context,
                          toDate,
                          minimumDate: fromDate.add(const Duration(days: 1)),
                        );
                        if (date != null && context.mounted) {
                          final cubit = find<AddTripCubit>(context);
                          cubit.updateTripModel(cubit.state.trip.copyWith(toDate: date));
                        }
                      },
                      child: RlCard(
                        borderRadius: 8,
                        padding: const EdgeInsets.all(8),
                        color: theme.bgAccent,
                        child: Text(
                          toDate.toMMMDDString(),
                          style: theme.body16M.copyWith(color: theme.textPrimaryOnColor),
                        ),
                      ),
                    ),
                  ],
                ),
                context.vBox8,
              ],
            ),
          ),
        );
      },
    );
  }
}
