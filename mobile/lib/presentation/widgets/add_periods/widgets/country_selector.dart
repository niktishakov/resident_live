import 'package:country_list_pick/support/code_countries_en.dart';
import 'package:flutter/material.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/presentation/utils/colors_utils.dart';

class CountrySelector extends StatefulWidget {
  const CountrySelector({
    required this.countries,
    required this.onCountrySelected,
    this.focusedCountry,
  });

  final List<String> countries;
  final Function(String, Color) onCountrySelected;
  final String? focusedCountry;

  @override
  _CountrySelectorState createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelector> {
  late Map<String, Color> countryColors;

  @override
  void initState() {
    super.initState();
    // Assign a unique color to each country
    countryColors = getCountryColors(widget.countries);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // Adjusts the space between items
      runSpacing: 8.0, // Adjusts the space between lines
      children: widget.countries.map((String country) {
        final isSelected = widget.focusedCountry == country;
        return GestureDetector(
          onTap: () {
            widget.onCountrySelected(country, countryColors[country]!);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? countryColors[country]
                  : context.theme.colorScheme
                      .tertiary, // Change color for selected country
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              country,
              style: TextStyle(
                color: isSelected
                    ? context.theme.scaffoldBackgroundColor
                    : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
