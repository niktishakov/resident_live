import 'package:freezed_annotation/freezed_annotation.dart';

part 'residence.model.g.dart';
part 'residence.model.freezed.dart';

@freezed
class ResidenceModel with _$ResidenceModel {
  const factory ResidenceModel({
    required String isoCountryCode,
    required String countryName,
    required int daysSpent,
    DateTime? startDate,
    DateTime? endDate,
  }) = _ResidenceModel;
  const ResidenceModel._();

  factory ResidenceModel.initial(String isoCode, String countryName) =>
      _ResidenceModel(
        isoCountryCode: isoCode,
        countryName: countryName,
        daysSpent: 0,
        startDate: DateTime.now(),
        endDate: null,
      );

  factory ResidenceModel.fromJson(Map<String, dynamic> json) =>
      _$ResidenceModelFromJson(json);

  bool get isResident => daysSpent >= 183;
  int get statusToggleIn => (183 - daysSpent).abs();
  DateTime get statusToggleAt =>
      DateTime.now().add(Duration(days: statusToggleIn));
  int get extraDays => isResident ? statusToggleIn : 0;
}
