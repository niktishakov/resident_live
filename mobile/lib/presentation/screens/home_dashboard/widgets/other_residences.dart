import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/shared_state/shared_state_cubit.dart';
import '../../../../data/country_residence.model.dart';

class OtherResidencesView extends StatelessWidget {
  final List<CountryResidenceModel> residences;

  const OtherResidencesView({
    Key? key,
    required this.residences,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "Other Residences",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: residences.length,
          itemBuilder: (context, index) {
            final residence = residences[index];
            final daysLeft = 183 - residence.daysSpent;
            final isWarning = residence.daysSpent >= 183;

            return Dismissible(
              key: ValueKey(residence),
              background: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onDismissed: (direction) {
                // Remove the item from the data source.
                context.read<SharedStateCubit>().removeResidence(
                      residence.isoCountryCode,
                    );

                // Then show a snackbar.
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('${residence.countryName} removed')));
              },
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  dense: false,
                  visualDensity: VisualDensity.comfortable,
                  enableFeedback: true,
                  onTap: () {},
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  title: Text(residence.countryName),
                  subtitle: Text("Days left until residence status: $daysLeft"),
                  trailing: Icon(
                    isWarning ? Icons.warning : Icons.check_circle,
                    color: residence.isResident ? Colors.green : Colors.red,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
