import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:resident_live/core/ai.logger.dart';
import 'package:resident_live/data/residence.model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:collection/collection.dart';

import 'residency_tracking_state.dart';

class ResidencyTrackingCubit extends HydratedCubit<ResidencyTrackingState> {
  ResidencyTrackingCubit()
      : super(
          ResidencyTrackingState(countryResidences: {}),
        );

  static final AiLogger _logger = AiLogger('ResidencyTrackingCubit');

  void updateResidencyByLocation(Placemark placemark) {
    final countryResidence = getResidenceByPlacemark(placemark);
    final updatedResidence = _updateResidenceDays(countryResidence);

    emit(state.copyWith(
      countryResidences: {
        ...state.countryResidences,
        updatedResidence.isoCountryCode: updatedResidence,
      },
      currentResidence: updatedResidence,
    ));
  }

  void updateResidencyManually(String isoCountryCode, String countryName) {
    final countryResidence = getResidencyByName(countryName);
    final updatedResidence = _updateResidenceDays(countryResidence);

    emit(state.copyWith(
      countryResidences: {
        ...state.countryResidences,
        isoCountryCode: updatedResidence,
      },
      currentResidence: updatedResidence,
    ));
  }

  ResidenceModel _updateResidenceDays(ResidenceModel residence) {
    final now = DateTime.now();
    final lastUpdate = residence.periods.lastOrNull?.endDate ??
        residence.periods.lastOrNull?.startDate ??
        now;
    final daysSinceLastUpdate = now.difference(lastUpdate).inDays;

    return residence.copyWith(
      daysSpent: residence.daysSpent + daysSinceLastUpdate,
      periods: residence.periods, // TODO: update the last period
    );
  }

  ResidenceModel getResidencyByName(String countryName) {
    final countryResidence = state.countryResidences.values
        .firstWhereOrNull((e) => e.countryName == countryName);

    if (countryResidence != null) {
      return countryResidence;
    }

    return ResidenceModel.initial(countryName, 'Unknown');
  }

  ResidenceModel getResidenceByPlacemark(Placemark country) {
    final countryResidence = state.countryResidences[country.isoCountryCode];
    if (countryResidence != null) {
      return countryResidence;
    }

    return ResidenceModel.initial(
      country.isoCountryCode ?? 'Unknown',
      country.country ?? 'Unknown',
    );
  }

  void addResidency(ResidenceModel countryResidence) {
    emit(state.copyWith(
      countryResidences: {
        ...state.countryResidences,
        countryResidence.isoCountryCode: countryResidence,
      },
    ));
  }

  void removeResidence(String isoCountryCode) {
    final countryResidences =
        Map<String, ResidenceModel>.from(state.countryResidences);
    countryResidences.remove(isoCountryCode);
    emit(state.copyWith(countryResidences: countryResidences));
  }

  @override
  ResidencyTrackingState? fromJson(Map<String, dynamic> json) {
    try {
      return ResidencyTrackingState.fromJson(json);
    } catch (e) {
      _logger.error('Error deserializing ResidencyTrackingState: $e');
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ResidencyTrackingState state) {
    try {
      return state.toJson();
    } catch (e) {
      _logger.error('Error serializing ResidencyTrackingState: $e');
      return null;
    }
  }
}
