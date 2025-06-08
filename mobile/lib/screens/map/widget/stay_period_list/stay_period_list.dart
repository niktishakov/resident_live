import "package:data/data.dart";
import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/screens/map/widget/stay_period_list/stay_period_item.dart";
import "package:resident_live/screens/map/widget/timeline/timeline.dart";
import "package:resident_live/shared/shared.dart";

class StayPeriodList extends StatelessWidget {
  const StayPeriodList({
    required this.stayPeriods,
    required this.sheetController,
    super.key,
    this.onPeriodTap,
    this.selectedPeriodIndex,
  });

  final ScrollController sheetController;
  final List<StayPeriodValueObject> stayPeriods;
  final Function(String countryCode, int index)? onPeriodTap;
  final int? selectedPeriodIndex;

  @override
  Widget build(BuildContext context) {
    getIt<LoggerService>().debug("StayPeriodList");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Timeline(stayPeriods: stayPeriods, selectedPeriodIndex: selectedPeriodIndex),
        ),

        Expanded(
          child: Column(
            children: List.generate(
              stayPeriods.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: StayPeriodItem(
                  stayPeriod: stayPeriods[index],
                  onTap: onPeriodTap,
                  index: index,
                  isSelected: selectedPeriodIndex == index,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
