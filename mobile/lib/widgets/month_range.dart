import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../features/features.dart';
import '../shared/shared.dart';

class DateScalePicker extends StatefulWidget {
  @override
  _DateScalePickerState createState() => _DateScalePickerState();
}

class _DateScalePickerState extends State<DateScalePicker> {
  late FixedExtentScrollController _scrollController;
  int totalDays = 365;
  DateTime currentDate = DateTime.now();
  late String currentCountry;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(initialItem: totalDays);
    currentCountry =
        getCountryForDate(currentDate, context.read<CountriesCubit>().state);
  }

  String getCountryForDate(DateTime date, CountriesState state) {
    var name = 'Unknown';
    state.countries.values.forEach((residence) {
      final startDate = residence.periods.lastOrNull?.startDate;
      final endDate = startDate?.add(residence.daysSpent.days);
      if (startDate != null) {
        if (startDate.isBefore(date) && endDate!.isAfter(date)) {
          name = residence.name;
        }
      }
    });

    return name;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountriesCubit, CountriesState>(
      builder: (context, state) {
        final date = currentDate;
        final country = getCountryForDate(date, state);
        final countryColor = getCountryColors(
          state.countries.values.map((e) => e.name).toList(),
        )[country];
        return Row(
          children: [
            // Left side showing current date and country
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: countryColor,
                  borderRadius: kBorderRadius,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(DateFormat('dd MMM yyyy').format(currentDate)),
                    Text(currentCountry),
                    // Add more UI elements as needed
                  ],
                ),
              ),
            ),
            // Right side with scrollable date picker
            Flexible(
              flex: 2,
              child: FadeBorder(
                bidirectional: true,
                child: NotificationListener<ScrollNotification>(
                  // onNotification: (ScrollNotification notification) {
                  //   if (notification is ScrollEndNotification) {
                  //     DateTime date = currentDate.subtract(Duration(
                  //         days: totalDays - _scrollController.selectedItem));
                  //     String country = getCountryForDate(date, state);
                  //     setState(() {
                  //       currentDate = date;
                  //       currentCountry = country;
                  //     });
                  //   }
                  //   return true;
                  // },
                  child: ListWheelScrollView.useDelegate(
                    perspective: 0.0001,

                    controller: _scrollController,
                    itemExtent: 35, // Set item height
                    diameterRatio: 1.8,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        currentDate = DateTime.now()
                            .subtract(Duration(days: totalDays - index));
                        currentCountry = getCountryForDate(
                          currentDate,
                          context.read<CountriesCubit>().state,
                        );
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        final date = currentDate
                            .subtract(Duration(days: totalDays - index));
                        final country = getCountryForDate(date, state);
                        final countryColor = getCountryColors(state
                            .countries.values
                            .map((e) => e.name)
                            .toList(),)[country];

                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          margin: EdgeInsets.only(right: 0),
                          decoration: BoxDecoration(
                            color: countryColor,
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(16),),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${DateFormat('dd MMM yyyy').format(date)}',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: totalDays,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
