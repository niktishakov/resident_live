import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/screens/map/widget/map_view.dart";
import "package:resident_live/shared/shared.dart";

class MapScreen extends StatelessWidget {
  const MapScreen({required this.stayPeriods, super.key});
  final List<StayPeriodValueObject> stayPeriods;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    return Scaffold(body: MapView(stayPeriods: stayPeriods));
  }
}
