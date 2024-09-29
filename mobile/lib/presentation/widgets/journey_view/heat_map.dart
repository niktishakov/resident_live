import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class ResidencyHeatmap extends StatelessWidget {
  final Map<DateTime, CountryVisit> residencyData;

  ResidencyHeatmap({required this.residencyData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: HeatMap(
        datasets: _generateDatasets(),
        colorMode: ColorMode.color, // Use color instead of opacity
        defaultColor: Colors.grey[200]!,
        textColor: Colors.black,
        showColorTip: true,
        scrollable: true,
        colorsets: {
          1: Colors.red, // Example: red for France
          2: Colors.blue, // Example: blue for Japan
          3: Colors.green, // Example: green for the USA
        },
        onClick: (value) {
          final country = residencyData[value]?.country;
          final days = residencyData[value]?.days;
          if (country != null) {
            print("On $value, spent $days days in $country");
          }
        },
      ),
    );
  }

  // Generate dataset with values indicating countries
  Map<DateTime, int> _generateDatasets() {
    return residencyData
        .map((date, visit) => MapEntry(date, visit.countryCode));
  }
}

class CountryVisit {
  final String country;
  final int countryCode;
  final int days;

  CountryVisit({
    required this.country,
    required this.countryCode,
    required this.days,
  });
}
