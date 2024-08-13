import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resident_live/presentation/screens/home_dashboard/widgets/rl.navigation_bar.dart';
import '../../../core/shared_state/shared_state_cubit.dart';
import 'widgets/current_residence.dart';
import 'widgets/other_residences.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SharedStateCubit, SharedStateState>(
      builder: (context, state) {
        final currentResidence =
            state.user.countryResidences[state.currentPosition?.isoCountryCode];

        print(currentResidence?.countryName);
        final otherResidences = state.user.countryResidences.values
            .where((e) => e.isoCountryCode != currentResidence?.isoCountryCode)
            .toList();

        return CupertinoPageScaffold(
          child: CustomScrollView(
            slivers: [
              RlNavBar(),
              if (currentResidence != null)
                SliverToBoxAdapter(
                  child: CurrentResidenceView(
                    residence: currentResidence,
                    daysToResidence: 183 - currentResidence.daysSpent,
                    daysSpentInCountry: currentResidence.daysSpent,
                  ),
                ),
              if (otherResidences.isNotEmpty)
                SliverToBoxAdapter(
                  child: OtherResidencesView(
                    residences: otherResidences,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
