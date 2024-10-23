import 'package:flutter/material.dart';
import 'package:resident_live/shared/shared.dart';

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

class _CountrySelectorState extends State<CountrySelector>
    with WidgetsBindingObserver {
  late Map<String, Color> countryColors;

  @override
  void initState() {
    super.initState();
    // Assign a unique color to each country
    WidgetsBinding.instance.addObserver(this);
    _updateCountryColors();
  }

  void _updateCountryColors() {
    countryColors = getCountryColors(widget.countries);
  }

  @override
  void didChangePlatformBrightness() {
    setState(_updateCountryColors);
    widget.onCountrySelected(
        widget.focusedCountry!, countryColors[widget.focusedCountry]!);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
