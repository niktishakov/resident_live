import 'package:flutter/material.dart';
import 'package:resident_live/core/constants.dart';
import '../../../../data/country_residence.model.dart';

class CurrentResidenceView extends StatelessWidget {
  final CountryResidenceModel residence;
  final int daysToResidence;

  const CurrentResidenceView({
    Key? key,
    required this.residence,
    required this.daysToResidence,
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
          // gradient: LinearGradient(
          //   colors: [
          //     Colors.red.shade100,
          //     // Colors.white,
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
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
              if (residence.isResident)
                _buildResidentInfo()
              else
                _buildNonResidentInfo(),
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
          "You are a resident",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        SizedBox(height: 8),
        Text(
          "You are available to travel 180 days",
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
          "Days to residence:",
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 8),
        Text(
          "$daysToResidence",
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ],
    );
  }
}
