import "package:country_code_picker/country_code_picker.dart";
import "package:flutter/material.dart";
import "package:resident_live/screens/onboarding/pages/add_periods/widgets/country_selector/country_item.dart";
import "package:resident_live/shared/lib/theme/export.dart";
import "package:resident_live/shared/lib/utils/colors_utils.dart";

enum ViewMode { list, grid }

class CountrySelector extends StatefulWidget {
  const CountrySelector._({
    required this.countryCodes,
    required this.onCountrySelected,
    required this.mode,
    super.key,
    this.focusedCountry,
    this.colors,
  });

  factory CountrySelector.grid({
    required List<String> countryCodes,
    required Function(String, Color) onCountrySelected,
    Key? key,
    String? focusedCountry,
    Map<String, Color>? colors,
  }) {
    return CountrySelector._(
      countryCodes: countryCodes,
      onCountrySelected: onCountrySelected,
      mode: ViewMode.grid,
      key: key,
      focusedCountry: focusedCountry,
      colors: colors,
    );
  }

  factory CountrySelector.list({
    required List<String> countryCodes,
    required Function(String, Color) onCountrySelected,
    Key? key,
    String? focusedCountry,
    Map<String, Color>? colors,
  }) {
    return CountrySelector._(
      countryCodes: countryCodes,
      onCountrySelected: onCountrySelected,
      mode: ViewMode.list,
      key: key,
      focusedCountry: focusedCountry,
      colors: colors,
    );
  }

  final List<String> countryCodes;
  final Function(String, Color) onCountrySelected;
  final String? focusedCountry;
  final Map<String, Color>? colors;
  final ViewMode mode;

  @override
  CountrySelectorState createState() => CountrySelectorState();
}

class CountrySelectorState extends State<CountrySelector> with WidgetsBindingObserver {
  late Map<String, Color> countryColors;

  @override
  void initState() {
    super.initState();
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
    return switch (widget.mode) {
      ViewMode.list => ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        separatorBuilder: (context, index) => context.hBox8,
        itemCount: widget.countryCodes.length,
        itemBuilder: (context, index) {
          final countryCode = widget.countryCodes[index];
          final isSelected = widget.focusedCountry == countryCode;
          final country = CountryCode.fromCountryCode(countryCode).localize(context);

          return CountryItem(
            onTap: widget.onCountrySelected,
            color: countryColors[countryCode]!,
            country: country,
            isSelected: isSelected,
          );
        },
      ),
      ViewMode.grid => Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: widget.countryCodes.map((countryCode) {
          final isSelected = widget.focusedCountry == countryCode;
          final country = CountryCode.fromCountryCode(countryCode).localize(context);

          return CountryItem(
            onTap: widget.onCountrySelected,
            color: countryColors[countryCode]!,
            country: country,
            isSelected: isSelected,
          );
        }).toList(),
      ),
    };
  }
}
