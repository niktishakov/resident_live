import 'package:resident_live/data/residence.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.model.g.dart';
part 'user.model.freezed.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    required DateTime createdAt,
    required Map<String, ResidenceModel> countryResidences,
  }) = _UserModel;

  factory UserModel.mock() => UserModel(
        id: '-1',
        name: '',
        email: '',
        createdAt: DateTime.now(),
        countryResidences: {},
      );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
