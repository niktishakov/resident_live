import "package:country_code_picker/country_code_picker.dart";
import "package:flutter/cupertino.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:resident_live/screens/add_trip/cubit/add_trip_cubit.dart";
import "package:resident_live/screens/add_trip/widget/country_dropdown/show_country_modal.dart";
import "package:resident_live/shared/lib/utils/dependency_squirrel.dart";
import "package:resident_live/shared/shared.dart";

class CountryDropdown extends StatelessWidget {
  const CountryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    return BouncingButton(
      onPressed: () async {
        final result = await showCountryModal(context);

        if (result != null && context.mounted) {
          final cubit = find<AddTripCubit>(context);
          cubit.updateTripModel(cubit.state.trip.copyWith(countryCode: result.code ?? ""));
        }
      },
      child: BlocBuilder<AddTripCubit, AddTripState>(
        builder: (context, state) {
          final countryName = state.trip.countryCode.isEmpty
              ? "[Select]"
              : CountryCode.fromCountryCode(state.trip.countryCode).localize(context).name ??
                    "[Select]";

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: RlCard(
              borderRadius: 12,
              child: Row(
                children: [
                  Text("Country", style: theme.body16.copyWith(color: theme.textPrimary)),
                  const Spacer(),
                  Text(countryName, style: theme.body16.copyWith(color: theme.textSecondary)),
                  context.hBox4,
                  Icon(CupertinoIcons.chevron_down, color: theme.iconSecondary),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
