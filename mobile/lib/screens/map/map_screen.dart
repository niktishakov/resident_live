import "package:domain/domain.dart";
import "package:flutter/material.dart";
import "package:resident_live/screens/map/widget/map_view.dart";

class MapScreen extends StatelessWidget {
  const MapScreen({required this.stayPeriods, super.key});
  final List<StayPeriodValueObject> stayPeriods;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MapView(stayPeriods: stayPeriods));
  }
}
