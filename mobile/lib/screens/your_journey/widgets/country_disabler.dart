import "package:domain/domain.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:gap/gap.dart";
import "package:resident_live/shared/lib/utils/colors_utils.dart";
import "package:resident_live/shared/shared.dart";

class CountryDisabler extends StatefulWidget {
  const CountryDisabler({
    required this.countries,
    required this.onCountrySelected,
    required this.currentMonth,
    required this.countryPeriods,
    super.key,
    this.disabledCountries = const [],
    this.colors,
    this.focusedCountry,
  });

  final List<String> countries;
  final Function({required String country, required bool isDisabled}) onCountrySelected;
  final List<String> disabledCountries;
  final Map<String, Color>? colors;
  final CountryEntity? focusedCountry;
  final DateTime currentMonth;
  final Map<String, List<DateTimeRange>> countryPeriods;

  @override
  CountryDisablerState createState() => CountryDisablerState();
}

class CountryDisablerState extends State<CountryDisabler> with WidgetsBindingObserver {
  late Map<String, Color> countryColors;
  List<String> _visibleCountries = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateCountryColors();
    _updateVisibleCountries();
  }

  @override
  void didUpdateWidget(CountryDisabler oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentMonth != widget.currentMonth) {
      setState(_updateVisibleCountries);
    }
  }

  void _updateVisibleCountries() {
    _visibleCountries = widget.countries.where((country) {
      final periods = widget.countryPeriods[country] ?? [];
      return periods.any((period) => _isDateRangeVisible(period, widget.currentMonth));
    }).toList();
  }

  bool _isDateRangeVisible(DateTimeRange period, DateTime currentMonth) {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);

    return !(period.end.isBefore(firstDayOfMonth) || period.start.isAfter(lastDayOfMonth));
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
    // Filter countries first
    final visibleItems = widget.countries.where((country) => _visibleCountries.contains(country)).toList();

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: visibleItems.map((country) {
        final isDisabled = widget.disabledCountries.contains(country);

        return GestureDetector(
          key: ValueKey(country),
          onTap: () {
            widget.onCountrySelected(country: country, isDisabled: isDisabled);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: countryColors[country]?.withValues(alpha: isDisabled ? 0.5 : 1.0),
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
        ).animate().fadeIn(duration: 300.ms, curve: Curves.easeInOut).scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.0, 1.0),
              duration: 300.ms,
              curve: Curves.easeInOut,
            );
      }).toList(),
    );
  }
}
