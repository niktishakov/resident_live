import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/presentation/screens/onboarding/pages/add_periods.page.dart';

import '../../../../core/shared_state/shared_state_cubit.dart';
import '../../../../data/residence.model.dart';

class OtherResidencesView extends StatelessWidget {
  final List<ResidenceModel> residences;

  const OtherResidencesView({
    Key? key,
    required this.residences,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      initialItemCount: residences.length,
      findChildIndexCallback: (key) => key.hashCode,
      itemBuilder: (context, index, animation) {
        final residence = residences[index];
        final backgroundColor = residence.isResident
            ? context.theme.primaryColor
            : context.theme.colorScheme.tertiary;
        final value = residence.isResident
            ? residence.daysSpent - 183
            : 183 - residence.daysSpent;

        return CupertinoContextMenu(
          actions: [
            CupertinoContextMenuAction(
                child: Text("Delete"),
                isDestructiveAction: true,
                trailingIcon: CupertinoIcons.delete,
                onPressed: () {
                  context.read<SharedStateCubit>().removeResidence(
                        residence.isoCountryCode,
                      );
                  context.pop();
                }),
          ],
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 70,
                maxWidth: context.mediaQuery.size.width,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: context.theme.scaffoldBackgroundColor,
                border: Border.all(color: context.theme.dividerColor),
              ),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(residence.countryName),
                      Spacer(),
                      Column(
                        children: [
                          Text(
                              maxLines: 2,
                              "${value} days left until ${residence.isResident ? "expiration" : "renewal"}"),
                        ],
                      )
                    ],
                  ),
                  Gap(8),
                  TweenAnimationBuilder(
                    duration: 2.seconds,
                    tween: Tween<double>(
                        begin: 1.0,
                        end: residence.isResident
                            ? value / 183
                            : 1 - value / 183),
                    curve: Curves.fastEaseInToSlowEaseOut,
                    builder: (context, v, child) {
                      return LinearProgressIndicator(
                        minHeight: 7,
                        borderRadius: BorderRadius.circular(8),
                        value: v,
                        backgroundColor: backgroundColor,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          context.theme.colorScheme.error,
                        ),
                      ).animate().shimmer(
                        duration: 1.seconds,
                        delay: 1.seconds,
                        stops: [1.0, 0.5, 0.0],
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
