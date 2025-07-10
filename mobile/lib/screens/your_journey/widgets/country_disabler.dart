import "package:country_code_picker/country_code_picker.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:gap/gap.dart";
import "package:resident_live/shared/lib/utils/colors_utils.dart";
import "package:resident_live/shared/shared.dart";

class CountryDisabler extends StatefulWidget {
  const CountryDisabler({
    required this.countryCodes,
    required this.toggleCountry,
    required this.currentMonth,
    required this.countryPeriods,
    super.key,
    this.disabledCountries = const [],
    this.colors,
    this.focusedCountryCode,
  });

  final Map<String, Color>? colors;
  final List<String> countryCodes;

  final Function({required String countryCode, required bool isDisabled}) toggleCountry;
  final List<String> disabledCountries;

  final String? focusedCountryCode;
  final DateTime currentMonth;

  final Map<String, List<DateTimeRange>> countryPeriods;

  @override
  CountryDisablerState createState() => CountryDisablerState();
}

class CountryDisablerState extends State<CountryDisabler> with WidgetsBindingObserver {
  late Map<String, Color> countryColors;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateCountryColors();
  }

  @override
  void didUpdateWidget(CountryDisabler oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentMonth != widget.currentMonth) {}
  }

  bool _isDateRangeVisible(DateTimeRange period, DateTime currentMonth) {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);

    return !(period.end.isBefore(firstDayOfMonth) || period.start.isAfter(lastDayOfMonth));
  }

  void _updateCountryColors() {
    countryColors = widget.colors ?? getCountryColors(widget.countryCodes);
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
    final visibleItems = widget.countryCodes.where((countryCode) {
      final periods = widget.countryPeriods[countryCode] ?? [];
      return periods.any((period) => _isDateRangeVisible(period, widget.currentMonth));
    }).toList();

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: visibleItems.map((countryCode) {
        final country = CountryCode.fromCountryCode(countryCode);
        final isDisabled = widget.disabledCountries.contains(countryCode);

        return CupertinoButton(
              key: ValueKey(country),
              padding: EdgeInsets.zero,
              onPressed: () {
                widget.toggleCountry(countryCode: countryCode, isDisabled: isDisabled);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: countryColors[countryCode]?.withValues(alpha: isDisabled ? 0.5 : 1.0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.focusedCountryCode == countryCode) ...[
                      AppAssetImage(
                        AppAssets.target,
                        color: context.theme.colorScheme.surface,
                        height: 20,
                      ),
                      const Gap(4),
                    ],
                    Text(
                      country.localize(context).toCountryStringOnly(),
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
            )
            .animate()
            .fadeIn(duration: 300.ms, curve: Curves.easeInOut)
            .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.0, 1.0),
              duration: 300.ms,
              curve: Curves.easeInOut,
            );
      }).toList(),
    );
  }
}
