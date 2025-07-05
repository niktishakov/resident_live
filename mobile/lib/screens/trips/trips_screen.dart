import "package:domain/domain.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import "package:resident_live/screens/trips/cubit/delete_trip_cubit.dart";
import "package:resident_live/screens/trips/cubit/trips_stream_cubit.dart";
import "package:resident_live/screens/trips/widget/empty_trips/empty_trips_list.dart";
import "package:resident_live/screens/trips/widget/trip_carousel/trips_carousel.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";
import "package:resident_live/shared/lib/service/toast.service.dart";
import "package:resident_live/shared/shared.dart";

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteTripCubit, ResourceState<Result<void>>>(
      listener: (context, state) {
        if (state.isSuccess) {
          ToastService.instance.showToast(context, message: "Trip deleted successfully");
        }
      },
      child: CupertinoScaffold(
        overlayStyle: getSystemOverlayStyle,
        transitionBackgroundColor: const Color(0xff121212),
        body: BlocBuilder<TripsStreamCubit, List<TripEntity>>(
          builder: (context, trips) {
            return trips.isEmpty ? const EmptyTripsList() : const TripsCarousel();
          },
        ),
      ),
    );
  }
}
