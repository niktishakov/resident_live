import "package:freezed_annotation/freezed_annotation.dart";

import "package:resident_live/domain/entities/entities.dart";

part "user.entity.g.dart";
part "user.entity.freezed.dart";

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String name,
    required String email,
    required DateTime createdAt,
    required Map<String, CountryEntity> countryResidences,
  }) = _UserEntity;

  factory UserEntity.mock() => UserEntity(
        id: "-1",
        name: "",
        email: "",
        createdAt: DateTime.now(),
        countryResidences: {},
      );

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}
