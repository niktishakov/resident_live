import "package:domain/domain.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/screens/trips/cubit/trips_cubit.dart";
import "package:resident_live/screens/trips/widget/empty_trips_list.dart";
import "package:resident_live/shared/lib/resource_cubit/bloc_consumer.dart";

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResourceBlocBuilder<TripsCubit, Result<List<TripEntity>>>(
        bloc: context.watch<TripsCubit>(),
        data: (data) =>
            data.data.isEmpty ? const EmptyTripsList() : const Center(child: Text("Trips")),
        loading: () => const Center(child: Text("Loading")),
      ),
    );
  }
}
