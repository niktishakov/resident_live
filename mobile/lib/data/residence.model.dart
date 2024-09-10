import 'package:freezed_annotation/freezed_annotation.dart';

import 'activity_segment.model.dart';

part 'residence.model.g.dart';
part 'residence.model.freezed.dart';

@freezed
class ResidenceModel with _$ResidenceModel {
  const factory ResidenceModel({
    required String isoCountryCode,
    required String countryName,
    required int daysSpent,
    required List<ActivitySegment> periods,
  }) = _ResidenceModel;
  const ResidenceModel._();

  factory ResidenceModel.initial(String isoCode, String countryName) =>
      _ResidenceModel(
        isoCountryCode: isoCode,
        countryName: countryName,
        daysSpent: 0,
        periods: [],
      );

  factory ResidenceModel.fromJson(Map<String, dynamic> json) =>
      _$ResidenceModelFromJson(json);

  bool get isResident => daysSpent >= 183;
  int get statusToggleIn => (183 - daysSpent).abs();
  DateTime get statusToggleAt =>
      DateTime.now().add(Duration(days: statusToggleIn));
  int get extraDays => isResident ? statusToggleIn : 0;
}
