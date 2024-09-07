import 'package:resident_live/data/data.dart';

class ResidencyTrackingState {
  final Map<String, ResidenceModel> countryResidences;
  final ResidenceModel? currentResidence;

  ResidencyTrackingState({
    required this.countryResidences,
    this.currentResidence,
  });

  ResidencyTrackingState copyWith({
    Map<String, ResidenceModel>? countryResidences,
    ResidenceModel? currentResidence,
  }) {
    return ResidencyTrackingState(
      countryResidences: countryResidences ?? this.countryResidences,
      currentResidence: currentResidence ?? this.currentResidence,
    );
  }

  factory ResidencyTrackingState.fromJson(Map<String, dynamic> json) {
    return ResidencyTrackingState(
      countryResidences:
          (json['countryResidences'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, ResidenceModel.fromJson(value)),
      ),
      currentResidence: json['currentResidence'] != null
          ? ResidenceModel.fromJson(json['currentResidence'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'countryResidences':
          countryResidences.map((key, value) => MapEntry(key, value.toJson())),
      'currentResidence': currentResidence?.toJson(),
    };
  }
}
