import 'package:freezed_annotation/freezed_annotation.dart';

part 'country_residence.model.g.dart';
part 'country_residence.model.freezed.dart';

@freezed
class CountryResidenceModel with _$CountryResidenceModel {
  const factory CountryResidenceModel({
    required String isoCountryCode,
    required String countryName,
    required int daysSpent,
    DateTime? startDate,
    DateTime? endDate,
    required bool isResident,
  }) = _CountryResidenceModel;

  factory CountryResidenceModel.initial(String isoCode, String countryName) =>
      _CountryResidenceModel(
        isoCountryCode: isoCode,
        countryName: countryName,
        daysSpent: 0,
        startDate: DateTime.now(),
        endDate: null,
        isResident: true,
      );

  factory CountryResidenceModel.fromJson(Map<String, dynamic> json) =>
      _$CountryResidenceModelFromJson(json);
}
