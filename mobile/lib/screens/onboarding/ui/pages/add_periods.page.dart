import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:resident_live/shared/lib/constants.dart';
import 'package:resident_live/screens/home/ui/widgets/rl.navigation_bar.dart';
import 'package:resident_live/shared/lib/utils/colors_utils.dart';
import 'package:resident_live/shared/shared.dart';
import 'package:resident_live/shared/ui/primary_button.dart';

import '../../../../domain/domain.dart';
import '../../../../shared/ui/fade_border.dart';
import '../../../../widgets/add_periods/widgets/country_selector.dart';
import '../../../../widgets/add_periods/widgets/timeline_slider.dart';
import '../../../../widgets/add_periods/widgets/show_toast.dart';

class AddPeriodsPage extends StatefulWidget {
  AddPeriodsPage({
    required this.countries,
    required this.segments,
  });

  final List<String> countries;
  final List<StayPeriod> segments;

  @override
  _AddPeriodsPageState createState() => _AddPeriodsPageState();
}

class _AddPeriodsPageState extends State<AddPeriodsPage>
    with WidgetsBindingObserver {
  List<StayPeriod> segments = [];
  String? focusedCountry;
  late DateTime startDate;
  late DateTime endDate;
  late Color sliderColor = Colors.grey;
  late ScrollController _controller;
  late List<StayPeriod> initialSegments;

  @override
  void initState() {
    segments = widget.segments;
    focusedCountry = widget.countries.first;
    sliderColor = getCountryColors(widget.countries).entries.first.value;

    initialSegments = List<StayPeriod>.from(widget.segments);
    endDate = DateTime.now();
    startDate = endDate.subtract(Duration(days: 365));
    _controller = ScrollController();

    super.initState();
  }

  void _updateColor() {
    sliderColor = getCountryColors(widget.countries).entries.first.value;
  }

  @override
  void didChangePlatformBrightness() {
    setState(_updateColor);
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  DateTime _getDateFromValue(double value) {
    return DateTime.now().subtract(Duration(days: (365 - value).toInt()));
  }

  void _onCountrySelected(String country, Color color) {
    setState(() {
      focusedCountry = country;
      sliderColor = color; // Set the slider color to the selected country color
    });
  }

  bool _onAddPeriodPressed(RangeValues values) {
    if (focusedCountry != null) {
      final segmentStart = _getDateFromValue(values.start);
      final segmentEnd = _getDateFromValue(values.end);

      // Reset selection
      setState(() {
        segments.add(
          StayPeriod(
            startDate: segmentStart,
            endDate: segmentEnd,
            country: focusedCountry!,
          ),
        );
        segments.sort((a, b) => a.startDate.compareTo(b.startDate));
      });
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: kDefaultDuration,
        curve: Curves.fastEaseInToSlowEaseOut,
      );
      return true;
    } else {
      showToast(context, "Please select a country");
      return false;
    }
  }

  // compare that initialSegments and segments has the same data. In this case return false. Otherwise return true
  bool get _canApply {
    if (initialSegments.length != segments.length) {
      return true;
    }

    for (var i = 0; i < initialSegments.length; i++) {
      if (initialSegments[i].country != segments[i].country ||
          initialSegments[i].startDate != segments[i].startDate ||
          initialSegments[i].endDate != segments[i].endDate) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: 365));

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: RlCupertinoNavBar(title: "Add Stay Periods"),
      ),
      body: SafeArea(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Gap(9),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  textAlign: TextAlign.left,
                  TextSpan(
                    style: context.theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: "Add your travel timeline: ",
                      ),
                      TextSpan(
                        text: "Country > Dates > Add",
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ).animate().fade(delay: 200.ms),
              ),
            ),
            Gap(16),
            CountrySelector(
              countries: widget.countries,
              focusedCountry: focusedCountry,
              onCountrySelected: _onCountrySelected,
            ).animate().fade(delay: 200.ms),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Gap(20),
                  SizedBox(
                    width: context.mediaQuery.size.width,
                    child: TimelineSlider(
                      min: 0,
                      max: 365,
                      initialStart: 0,
                      initialEnd: 365,
                      startDate: startDate,
                      endDate: endDate,
                      color: sliderColor,
                      periods: segments,
                      onAddPeriodPressed: _onAddPeriodPressed,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FadeBorder(
                bidirectional: true,
                child: ListView.builder(
                  controller: _controller,
                  padding: EdgeInsets.symmetric(vertical: 32),
                  shrinkWrap: true,
                  itemCount: segments.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(segments[index].hashCode.toString()),
                      onDismissed: (direction) => setState(() {
                        segments.removeAt(index);
                      }),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Delete",
                                style: context.theme.textTheme.bodyMedium
                                    ?.copyWith(color: Colors.white)),
                            Gap(8),
                            Icon(CupertinoIcons.delete, color: Colors.white),
                          ],
                        ),
                      ),
                      child: CupertinoContextMenu(
                        actions: [
                          CupertinoContextMenuAction(
                            child: Text("Delete"),
                            trailingIcon: CupertinoIcons.delete,
                            isDestructiveAction: true,
                            onPressed: () {
                              setState(() => segments.removeAt(index));
                              context.pop();
                            },
                          ),
                        ],
                        child: Material(
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: context.mediaQuery.size.width,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  segments[index].country,
                                  style: context.theme.textTheme.bodyLarge
                                      ?.copyWith(
                                    color: context.theme.colorScheme.secondary,
                                  ),
                                ),
                                Text(
                                  '${_formatDate(segments[index].startDate)} - ${_formatDate(segments[index].endDate)}',
                                  style: context.theme.textTheme.bodyLarge
                                      ?.copyWith(
                                    color: context.theme.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ).animate().moveX(
                          begin: -200,
                          duration: 400.ms,
                          curve: Curves.fastEaseInToSlowEaseOut,
                        );
                  },
                ),
              ),
            ).animate().fade(delay: 400.ms),
            TweenAnimationBuilder<double>(
                duration: 500.ms,
                curve: Curves.fastOutSlowIn,
                tween:
                    Tween<double>(begin: 0, end: segments.isNotEmpty ? 1 : 0),
                builder: (context, value, child) =>
                    Opacity(opacity: value, child: child),
                child: PrimaryButton(
                  enabled: _canApply,
                  onPressed: () {
                    Navigator.pop(context, segments);
                  },
                  label: "Apply",
                )
                    .animate(
                      onPlay: (controller) =>
                          _canApply ? controller.repeat() : null,
                    )
                    .shimmer(duration: 1.seconds, delay: 3.seconds)),
            Gap(8),
          ],
        ),
      ),
    );
  }
}
