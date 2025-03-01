import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:resident_live/generated/codegen_loader.g.dart';
import 'package:resident_live/shared/shared.dart';
import '../domain/domain.dart';

class ActivityTimeline extends StatefulWidget {
  const ActivityTimeline({
    Key? key,
    required this.onSegmentsChanged,
    required this.addRanges,
    required this.countries,
  }) : super(key: key);

  final Function(List<StayPeriod>) onSegmentsChanged;
  final Future<List<StayPeriod>> Function(List<StayPeriod>) addRanges;
  final List<String> countries;

  @override
  _ActivityTimelineState createState() => _ActivityTimelineState();
}

class _ActivityTimelineState extends State<ActivityTimeline> {
  List<StayPeriod> segments = [];
  late DateTime startDate;
  late DateTime endDate;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    endDate = DateTime.now();
    startDate = endDate.subtract(const Duration(days: 365));
    _scrollController = ScrollController();
  }

  double calcProgressBySegments() {
    final totalDays = endDate.difference(startDate).inDays;

    int usedDays = 0;

    for (var segment in segments) {
      usedDays += segment.startDate.difference(segment.endDate).inDays;
    }

    return usedDays / totalDays;
  }

  String _formatDate(DateTime date) {
    return '${kMonths[date.month - 1].substring(0, 3)}';
  }

  List<String> _getMonthLabels() {
    final totalDays = endDate.difference(startDate).inDays;
    const labelCount = 12;
    final labels = <String>[];

    for (var i = 0; i <= labelCount; i++) {
      final date = startDate.add(Duration(days: i * totalDays ~/ labelCount));
      labels.add(_formatDate(date));
    }

    return labels;
  }

  @override
  Widget build(BuildContext context) {
    const timelineWidth = 40.0 * 13; // Assuming 12 months, 40 px per month.
    final totalDays = endDate.difference(startDate).inDays;
    final completionPercentage = calculateCompletionPercentage(segments);

    return Column(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          child: GestureDetector(
            onTap: _onAddRange,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  transitionOnUserGestures: true,
                  tag: 'timeline',
                  flightShuttleBuilder: _flightShuttleBuilder,
                  createRectTween: (begin, end) {
                    return RectTween(begin: begin, end: end);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Material(
                        child: Stack(
                          children: [
                            _buildTimeline(context, timelineWidth),
                            ..._buildSegments(context, timelineWidth, totalDays)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(8),
                _buildMonths(context, timelineWidth),
              ],
            ),
          ),
        ),
        Gap(32),
        ProgressBar(
          completionPercentage: min(completionPercentage, 1.0),
          radius: 200,
          strokeWidth: 20,
        ),
      ],
    );
  }

  int calculateTotalDays(List<StayPeriod> segments) {
    var totalDays = 0;
    for (var segment in segments) {
      totalDays += segment.getDays();
    }
    return totalDays;
  }

  double calculateCompletionPercentage(List<StayPeriod> segments) {
    final totalDays = calculateTotalDays(segments);
    const maxDays = 365; // Assuming non-leap year, adjust if needed
    return totalDays / maxDays;
  }

  Future<void> _onAddRange() async {
    final result = await widget.addRanges(segments);

    if (result.isNotEmpty) {
      setState(() {
        segments = result;
        segments.sort((a, b) => a.startDate.compareTo(b.startDate));
      });
    }

    widget.onSegmentsChanged(segments);
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // Define separate animations for fading in and fading out
        final fadeOutTween =
            Tween<double>(begin: 1.0, end: 0.5).animate(animation);
        final fadeInTween =
            Tween<double>(begin: 0.0, end: 1.0).animate(animation);

        // Stack both widgets to animate them in parallel
        return Stack(
          children: [
            // The widget that's being transitioned from
            FadeTransition(
              opacity: fadeOutTween,
              child: toHeroContext.widget,
            ),
            // The widget that's being transitioned to
            FadeTransition(
              opacity: fadeInTween,
              child: fromHeroContext.widget,
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimeline(BuildContext context, double timelineWidth) {
    return Container(
      height: 80,
      width: timelineWidth,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(40),
      ),
      alignment: Alignment.center,
      child: segments.isEmpty
          ? Text(
              LocaleKeys.add_stay_period_clickToGetStarted.tr(),
              style: context.theme.textTheme.headlineSmall?.copyWith(
                color: context.theme.scaffoldBackgroundColor,
              ),
            )
          : null,
    )
        .animate(
          onPlay: (controller) => controller.repeat(),
        )
        .shimmer(duration: 1.seconds, delay: 1.seconds);
  }

  Widget _buildMonths(BuildContext context, double timelineWidth) {
    return Row(
      children: [
        ..._getMonthLabels()
            .mapIndexed((index, e) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  width: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(e),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }

  List<Widget> _buildSegments(
    BuildContext context,
    double timelineWidth,
    int totalDays,
  ) {
    return segments.isNotEmpty
        ? segments.map((e) {
            final leftPosition =
                e.startDate.difference(startDate).inDays.toDouble() /
                    totalDays *
                    timelineWidth;
            final segmentWidth =
                e.endDate.difference(e.startDate).inDays.toDouble() /
                    totalDays *
                    timelineWidth;

            return Positioned(
              top: 0.5,
              left: leftPosition,
              width: segmentWidth + 0.5,
              height: 80,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.horizontal(
                    left: leftPosition == 0 ? Radius.circular(40) : Radius.zero,
                    right: leftPosition + segmentWidth == timelineWidth
                        ? Radius.circular(40)
                        : Radius.zero,
                  ),
                ),
                child: Text(
                  e.country,
                  maxLines: 1,
                  style: TextStyle(
                    color: context.theme.scaffoldBackgroundColor,
                  ),
                ),
                alignment: Alignment.center,
              ),
            );
          }).toList()
        : [];
  }
}

class CountrySelectionDialog extends StatelessWidget {
  final List<String> countries;
  final Function(String) onSelect;

  const CountrySelectionDialog(
      {Key? key, required this.countries, required this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('Select a Country'),
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: countries.length,
          itemBuilder: (context, index) {
            return BouncingButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(countries[index],
                    style: context.theme.textTheme.bodyLarge
                        ?.copyWith(color: context.theme.primaryColor)),
              ),
              onPressed: (_) {
                onSelect(countries[index]);
                Navigator.of(context).pop(countries[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
