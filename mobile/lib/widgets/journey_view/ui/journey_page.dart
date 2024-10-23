import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../features/features.dart';
import '../../../shared/shared.dart';
import '../../add_periods/ui/country_selector.dart';

class ResidencyJourneyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final state = context.watch<CountriesCubit>().state;
        final otherResidences = state.countries.values.toList();

        return Scaffold(
          body: Column(
            children: [
              Grabber(),
              Gap(16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RichText(
                          text: TextSpan(
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                height: 31 / 22,
                              ),
                              children: [
                            TextSpan(text: "Your Journey Over the\n"),
                            TextSpan(
                              text: "Last 12 Months",
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: context.theme.primaryColor,
                                height: 31 / 22,
                              ),
                            )
                          ])),
                    ),
                  ),
                  RlCloseButton(
                      color: context.theme.colorScheme.secondary
                          .withOpacity(0.85)),
                  Gap(16)
                ],
              ),
              Gap(8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CalendarDatePicker(
                          initialDate: DateTime.now(),
                          firstDate:
                              DateTime.now().subtract(Duration(days: 365)),
                          lastDate: DateTime.now(),
                          onDateChanged: (d) {}),
                      CountrySelector(
                        countries: otherResidences.map((e) => e.name).toList(),
                        onCountrySelected: (d, a) {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Mock data: Days spent in each country for the last 12 months
  final Map<DateTime, int> userResidencyData = {
    DateTime(2024, 9, 12): 3, // Spent 3 days in a country on this date
    DateTime(2024, 8, 23): 6,
    DateTime(2024, 7, 10): 4,
    DateTime(2024, 6, 5): 7,
    DateTime(2024, 5, 16): 2,
    DateTime(2024, 4, 25): 10,
    DateTime(2024, 3, 12): 8,
  };

  // Widget _buildWorldMapSection() {
  //   // You can implement a heatmap package or custom widget for the map
  //   return Expanded(
  //       child: WorldMapWidget(
  //     selectedCountry: _selectedCountry, // Country to highlight on the map
  //   ));
  // }

  Widget _buildResidencyProgressBars() {
    // Example for Residency Progress Bars
    List<Map<String, dynamic>> countries = [
      {'name': 'Kyrgyzstan', 'progress': 0.55},
      {'name': 'Albania', 'progress': 0.9},
      {'name': 'Russia', 'progress': 0.25},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: countries.map((country) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                country['name'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              LinearProgressIndicator(
                value: country['progress'],
                backgroundColor: Colors.grey.shade300,
                color: Colors.blueAccent,
              ),
              SizedBox(height: 5),
              Text(
                '${(country['progress'] * 183).toInt()} days of 183',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPieChart() {
    // Example Pie Chart using the fl_chart package
    // Install fl_chart in your pubspec.yaml for this
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 250,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 40,
              color: Colors.blueAccent,
              title: 'Kyrgyzstan',
            ),
            PieChartSectionData(
              value: 35,
              color: Colors.orangeAccent,
              title: 'Albania',
            ),
            PieChartSectionData(
              value: 25,
              color: Colors.redAccent,
              title: 'Russia',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableList() {
    // Example Expandable List for Travel Details
    return ExpansionTile(
      title: Text('Detailed Travel Information'),
      children: [
        ListTile(
          title: Text('Kyrgyzstan - 83 days left to residency'),
        ),
        ListTile(
          title: Text('Albania - Exceeded residency threshold'),
        ),
        ListTile(
          title: Text('Russia - 46 days so far'),
        ),
      ],
    );
  }
}
