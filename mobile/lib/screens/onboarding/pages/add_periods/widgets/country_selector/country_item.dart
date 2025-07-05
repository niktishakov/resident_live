import "package:country_code_picker/country_code_picker.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:resident_live/shared/shared.dart";

class CountryItem extends StatelessWidget {
  const CountryItem({
    required this.onTap,
    required this.color,
    required this.country,
    required this.isSelected,
    super.key,
  });

  final Color color;
  final CountryCode country;
  final bool isSelected;
  final Function(String, Color) onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return GestureDetector(
      onTap: () {
        onTap(country.code ?? "", color);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 0.6,
            color: isSelected ? color : context.theme.colorScheme.onSurface,
          ),
        ),
        child: Text(
          country.toCountryStringOnly(),
          style: theme.body14.copyWith(
            color: isSelected
                ? context.theme.scaffoldBackgroundColor
                : context.theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
