import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import "package:resident_live/screens/add_trip/widget/country_dropdown/country_dropdown.dart";
import "package:resident_live/screens/add_trip/widget/trip_stay_period.dart";
import "package:resident_live/shared/shared.dart";

class AddTripScreen extends StatelessWidget {
  const AddTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    return Material(
      child: CupertinoScaffold(
        body: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              backgroundColor: theme.bgPrimary,
              leading: CupertinoNavigationBarBackButton(
                previousPageTitle: "Trips",
                color: theme.textAccent,
                onPressed: () {
                  context.goNamed(ScreenNames.trips);
                },
              ),
              middle: Text(
                "Add Your First Trip",
                style: theme.body14.copyWith(fontWeight: FontWeight.w600, color: theme.textPrimary),
              ),

              alwaysShowMiddle: false,
              largeTitle: Text(
                "Add Your First Trip",
                style: theme.body22.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: theme.textPrimary,
                ),
              ),
            ),
            SliverToBoxAdapter(child: context.vBox32),
            const SliverToBoxAdapter(child: Column(children: [CountryDropdown()])),
            SliverToBoxAdapter(child: context.vBox32),
            const SliverToBoxAdapter(child: Column(children: [TripStayPeriod()])),
            SliverToBoxAdapter(child: context.vBox32),
            SliverToBoxAdapter(
              child: Center(
                child: PrimaryButton(
                  label: "Evaluate Risks",
                  onPressed: () {
                    context.goNamed(ScreenNames.validateTrip);
                  },
                  textStyle: theme.body14.copyWith(
                    color: theme.textPrimaryOnColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
