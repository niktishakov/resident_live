import 'package:data/src/mapper/stay_period_mapper.dart';
import 'package:data/src/model/user/user_model.dart';
import 'package:domain/domain.dart';

extension UserEntityMapper on UserEntity {
  UserHiveModel toModel() => UserHiveModel(
        id: id,
        createdAt: createdAt,
        stayPeriods: stayPeriods.map((e) => e.toHiveValueObject()).toList(),
        isBiometricsEnabled: isBiometricsEnabled,
        focusedCountryCode: focusedCountryCode,
      );
}

extension UserHiveModelMapper on UserHiveModel {
  UserEntity toEntity() => UserEntity(
        id: id,
        createdAt: createdAt,
        stayPeriods: stayPeriods.map((e) => e.toValueObject()).toList(),
        isBiometricsEnabled: isBiometricsEnabled,
        focusedCountryCode: focusedCountryCode,
      );
}
