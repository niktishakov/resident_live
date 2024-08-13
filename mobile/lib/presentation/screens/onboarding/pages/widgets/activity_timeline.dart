import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:math';

import 'package:resident_live/core/extensions/context.extension.dart';

import 'timeline_painter.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class ActivitySegment {
  DateTime startDate;
  DateTime endDate;
  String country;

  ActivitySegment(
      {required this.startDate, required this.endDate, required this.country});
}

class ActivityTimeline extends StatefulWidget {
  const ActivityTimeline({
    Key? key,
    required this.onSegmentsChanged,
    required this.countries,
  }) : super(key: key);

  final Function(List<ActivitySegment>) onSegmentsChanged;
  final List<String> countries;

  @override
  _ActivityTimelineState createState() => _ActivityTimelineState();
}

class _ActivityTimelineState extends State<ActivityTimeline> {
  List<ActivitySegment> segments = [];
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

  @override
  Widget build(BuildContext context) {
    final timelineWidth = (endDate.difference(startDate).inDays * 2).toDouble();

    return Column(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 64),
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          child: GestureDetector(
            onTapUp: _handleTap,
            child: CustomPaint(
              willChange: true,
              size: Size(
                context.mediaQuery.size.width,
                150,
              ), // Or any other square size that fits your layout
              painter: TimelinePainter(
                countries: widget.countries,
                segments: segments,
                startDate: startDate,
                endDate: endDate,
                onSegmentPressed: () {},
              ),
            ),
          ),
        ),
        Gap(16),
        ElevatedButton(
          onPressed: _showDateRangePicker,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add),
              Text('Add Segment'),
            ],
          ),
        ),
      ],
    );
  }

  void _handleTap(TapUpDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);
    final totalDays = endDate.difference(startDate).inDays;
    final tappedDate = startDate.add(Duration(
        days: (localPosition.dx / box.size.width * totalDays).round()));

    print(tappedDate);
    _editSegment(tappedDate);
  }

  void _showDateRangePicker() async {
    final range = await showDateRangePicker(
      context: context,
      // showTitleActions: true,
      firstDate: startDate,
      lastDate: endDate,
      currentDate: startDate,
    );

    if (range != null) _addSegment(range.start, range.end);
  }

  void _addSegment(DateTime start, DateTime end) {
    _showCountrySelectionDialog((country) {
      setState(() {
        segments.add(ActivitySegment(
          startDate: start,
          endDate: end,
          country: country,
        ));
        segments.sort((a, b) => a.startDate.compareTo(b.startDate));
        _mergeOverlappingSegments();
      });
      widget.onSegmentsChanged(segments);
    });
  }

  void _editSegment(DateTime tappedDate) {
    int index = segments.indexWhere((segment) =>
        segment.startDate.isBefore(tappedDate) &&
        segment.endDate.isAfter(tappedDate));

    if (index != -1) {
      _showCountrySelectionDialog((country) {
        setState(() {
          segments[index].country = country;
        });
        widget.onSegmentsChanged(segments);
      });
    }
  }

  void _mergeOverlappingSegments() {
    segments.sort((a, b) => a.startDate.compareTo(b.startDate));
    for (int i = 0; i < segments.length - 1; i++) {
      if (segments[i].endDate.isAfter(segments[i + 1].startDate)) {
        segments[i].endDate = segments[i + 1].startDate;
      }
    }
    segments.removeWhere(
        (segment) => segment.startDate.isAtSameMomentAs(segment.endDate));
  }

  void _showCountrySelectionDialog(Function(String) onSelect) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CountrySelectionDialog(
          countries: widget.countries,
          onSelect: onSelect,
        );
      },
    );
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
      title: Text('Select a Country'),
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: countries.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(countries[index]),
              onTap: () {
                onSelect(countries[index]);
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
    );
  }
}
