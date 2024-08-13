import 'package:flutter/material.dart';
import 'package:resident_live/core/constants.dart';
import '../../../../data/country_residence.model.dart';

class CurrentResidenceView extends StatelessWidget {
  final CountryResidenceModel residence;
  final int daysToResidence;
  final int daysSpentInCountry;

  const CurrentResidenceView({
    Key? key,
    required this.residence,
    required this.daysToResidence,
    required this.daysSpentInCountry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.5, color: Colors.black.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              offset: Offset(5, 5),
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
          borderRadius: kBorderRadius,
        ),
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                residence.countryName,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 8),
              Text(
                "Current Residence",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: 16),
              Text(
                "Days spent in this country: $daysSpentInCountry",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 16),
              if (residence.isResident)
                _buildResidentInfo()
              else
                _buildNonResidentInfo(),
              SizedBox(height: 16),
              _buildProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResidentInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          residence.isResident
              ? "You are a resident"
              : "You are not a resident",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: residence.isResident ? Colors.green : Colors.red,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "You can travel freely, but consider tax implications.",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildNonResidentInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Days to become a resident:",
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 8),
        Text(
          "$daysToResidence days left",
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Progress to Residency:",
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 8),
        LinearProgressIndicator(
          value: daysSpentInCountry / 183,
          backgroundColor: Colors.grey[300],
          color: residence.isResident ? Colors.green : Colors.blue,
        ),
        SizedBox(height: 8),
        Text(
          "${(daysSpentInCountry / 183 * 100).toStringAsFixed(1)}% of 183 days",
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ],
    );
  }
}
