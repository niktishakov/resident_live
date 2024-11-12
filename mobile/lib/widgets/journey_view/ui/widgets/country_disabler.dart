import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:resident_live/domain/entities/country/country.entity.dart';
import 'package:resident_live/shared/shared.dart';

class CountryDisabler extends StatefulWidget {
  const CountryDisabler({
    required this.countries,
    required this.onCountrySelected,
    this.disabledCountries = const [],
    this.colors,
    this.focusedCountry,
  });

  final List<String> countries;
  final Function(String, bool) onCountrySelected;
  final List<String> disabledCountries;
  final Map<String, Color>? colors;
  final CountryEntity? focusedCountry;

  @override
  _CountryDisablerState createState() => _CountryDisablerState();
}

class _CountryDisablerState extends State<CountryDisabler>
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
    countryColors = widget.colors ?? getCountryColors(widget.countries);
  }

  @override
  void didChangePlatformBrightness() {
    setState(_updateCountryColors);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('focusedCountry: ${widget.focusedCountry}');
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: widget.countries.map((String country) {
        final isDisabled = widget.disabledCountries.contains(country);
        return GestureDetector(
          onTap: () {
            widget.onCountrySelected(country, isDisabled);
          },
          child: Opacity(
            opacity: isDisabled ? 0.5 : 1.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: countryColors[country],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.focusedCountry?.name == country) ...[
                    AppAssetImage(
                      AppAssets.target,
                      color: context.theme.colorScheme.surface,
                      height: 20,
                    ),
                    const Gap(4),
                  ],
                  Text(
                    country,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Poppins",
                      color: context.theme.colorScheme.surface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
