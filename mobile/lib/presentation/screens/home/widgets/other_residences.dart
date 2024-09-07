import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/core/constants.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/presentation/navigation/screen_names.dart';
import 'package:resident_live/presentation/screens/onboarding/pages/add_periods.page.dart';
import 'package:resident_live/presentation/utils/hero_utils.dart';
import 'package:resident_live/presentation/utils/route_utils.dart';
import 'package:resident_live/presentation/widgets/rl.card.dart';
import 'package:resident_live/services/share.service.dart';

import '../../../../core/shared_state/shared_state_cubit.dart';
import '../../../../data/residence.model.dart';
import '../../residence_details/residence_details_screen.dart';

class OtherResidencesView extends StatefulWidget {
  const OtherResidencesView({Key? key, required this.residences})
      : super(key: key);

  final List<ResidenceModel> residences;

  @override
  State<StatefulWidget> createState() => _OtherResidencesViewState();
}

class _OtherResidencesViewState extends State<OtherResidencesView> {
  GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final residences = widget.residences;
    return SliverAnimatedList(
      key: _listKey,
      initialItemCount: residences.length,
      findChildIndexCallback: (key) => key.hashCode,
      itemBuilder: (context, index, animation) =>
          _buildItem(context, residences[index], animation),
    );
  }

  Widget _buildItem(
    BuildContext context,
    ResidenceModel residence,
    Animation<double> animation,
  ) {
    final backgroundColor = residence.isResident
        ? context.theme.primaryColor
        : context.theme.colorScheme.tertiary;
    final value = residence.isResident
        ? residence.daysSpent - 183
        : 183 - residence.daysSpent;

    return SizeTransition(
      sizeFactor: animation,
      child: GestureDetector(
        child: CupertinoContextMenu(
          actions: [
            CupertinoContextMenuAction(
                child: Text("Share"),
                trailingIcon: CupertinoIcons.share,
                onPressed: () {
                  ShareService.instance.shareResidence(residence);
                  context.pop();
                }),
            CupertinoContextMenuAction(
                child: Text("Delete"),
                isDestructiveAction: true,
                trailingIcon: CupertinoIcons.delete,
                onPressed: () {
                  final index = widget.residences.indexWhere(
                      (r) => r.isoCountryCode == residence.isoCountryCode);
                  if (index != -1) {
                    _listKey.currentState?.removeItem(
                      index,
                      (context, animation) =>
                          _buildItem(context, residence, animation),
                      duration: 300.ms,
                    );
                    context.read<SharedStateCubit>().removeResidence(
                          residence.isoCountryCode,
                        );
                  }
                  context.pop();
                }),
          ],
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              kDefaultFadeRouteBuilder(
                page:
                    ResidenceDetailsScreen(countryName: residence.countryName),
              ),
            ),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 75,
                maxWidth: context.mediaQuery.size.width,
              ),
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: Hero(
                tag: 'residence_${residence.countryName}',
                flightShuttleBuilder: startFlightShuttleBuilder,
                child: Material(
                  color: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: kBorderRadius,
                  ),
                  child: RlCard(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(residence.countryName,
                                style: context.theme.textTheme.labelLarge),
                            Spacer(),
                            Column(
                              children: [
                                Text(
                                    maxLines: 2,
                                    style: context.theme.textTheme.bodySmall
                                        ?.copyWith(
                                            color: context
                                                .theme.colorScheme.tertiary
                                                .withOpacity(0.5)),
                                    "${residence.daysSpent} days of 183"),
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
                              minHeight: 12,
                              borderRadius: BorderRadius.circular(8),
                              value: v,
                              backgroundColor: backgroundColor,
                              valueColor: AlwaysStoppedAnimation(
                                  context.theme.primaryColor),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
