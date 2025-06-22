import "package:country_code_picker/country_code_picker.dart";
import "package:flutter/material.dart";
import "package:resident_live/shared/lib/utils/colors_utils.dart";
import "package:resident_live/shared/shared.dart";

class CountrySelector extends StatefulWidget {
  const CountrySelector({
    required this.countryCodes,
    required this.onCountrySelected,
    super.key,
    this.focusedCountry,
    this.colors,
  });

  final List<String> countryCodes;
  final Function(String, Color) onCountrySelected;
  final String? focusedCountry;
  final Map<String, Color>? colors;
  @override
  CountrySelectorState createState() => CountrySelectorState();
}

class CountrySelectorState extends State<CountrySelector> with WidgetsBindingObserver {
  late Map<String, Color> countryColors;

  @override
  void initState() {
    super.initState();
    // Assign a unique color to each country
    WidgetsBinding.instance.addObserver(this);
    _updateCountryColors();
  }

  void _updateCountryColors() {
    countryColors = widget.colors ?? getCountryColors(widget.countryCodes);
  }

  @override
  void didChangePlatformBrightness() {
    setState(_updateCountryColors);
    widget.onCountrySelected(widget.focusedCountry!, countryColors[widget.focusedCountry]!);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return Wrap(
      spacing: 8.0, // Adjusts the space between items
      runSpacing: 8.0, // Adjusts the space between lines
      children: widget.countryCodes.map((countryCode) {
        final isSelected = widget.focusedCountry == countryCode;
        final country = CountryCode.fromCountryCode(countryCode).localize(context);

        return GestureDetector(
          onTap: () {
            widget.onCountrySelected(countryCode, countryColors[countryCode]!);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? countryColors[countryCode] : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 0.6,
                color: isSelected
                    ? countryColors[countryCode]!
                    : context.theme.colorScheme.onSurface,
              ),
            ),
            child: Text(
              country.name ?? "",
              style: theme.body14.copyWith(
                color: isSelected
                    ? context.theme.scaffoldBackgroundColor
                    : context.theme.colorScheme.onSurface,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
