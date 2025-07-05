import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/screens/trip_details/widgets/action_button_widget.dart";
import "package:resident_live/screens/trips/cubit/delete_trip_cubit.dart";
import "package:resident_live/shared/lib/service/toast.service.dart";
import "package:resident_live/shared/shared.dart";

class TripActionsWidget extends StatelessWidget {
  const TripActionsWidget({required this.trip, super.key});

  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ActionButtonWidget(
                label: "Edit Trip",
                isSecondary: true,
                icon: CupertinoIcons.pencil,
                onTap: () => _editTrip(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ActionButtonWidget(
            label: "Delete Trip",
            icon: CupertinoIcons.delete,
            onTap: () => _deleteTrip(context),
            isDanger: true,
          ),
        ),
      ],
    );
  }

  void _editTrip(BuildContext context) {
    context.pushNamed(ScreenNames.addTrip, extra: trip);
  }

  void _showOnMap(BuildContext context) {
    context.pushNamed(ScreenNames.map, extra: trip);
  }

  void _deleteTrip(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (dialog) => CupertinoAlertDialog(
        title: const Text("Delete Trip"),
        content: const Text("Are you sure you want to delete this trip?"),
        actions: [
          CupertinoDialogAction(child: const Text("Cancel"), onPressed: () => context.pop()),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text("Delete"),
            onPressed: () {
              ToastService.instance.showToast(context, message: "Trip deleted");
              context.read<DeleteTripCubit>().loadResource(trip.id);
              context.pop();
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
