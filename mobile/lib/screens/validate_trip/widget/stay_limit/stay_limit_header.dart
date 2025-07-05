import "package:country_code_picker/country_code_picker.dart";
import "package:flutter/material.dart";
import "package:resident_live/screens/validate_trip/widget/stay_limit/stay_limit_data.dart";
import "package:resident_live/shared/shared.dart";

class StayLimitHeader extends StatelessWidget {
  const StayLimitHeader({required this.limit, super.key});

  final StayLimitData limit;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    final countryName =
        CountryCode.fromCountryCode(limit.countryCode).localize(context).name ?? limit.countryCode;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(countryName, style: theme.body16M.copyWith(color: theme.textPrimary)),
        Text(
          "${limit.futureDays} ← ${limit.usedDays} days",
          style: theme.body14.copyWith(color: theme.textSecondary),
        ),
      ],
    );
  }
}
