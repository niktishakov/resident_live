import "package:hive/hive.dart";

part "stay_period_model.g.dart";

@HiveType(typeId: 2)
class StayPeriodHiveValueObject extends HiveObject {
  StayPeriodHiveValueObject({
    required this.startDate,
    required this.endDate,
    required this.countryCode,
  });
  @HiveField(0)
  DateTime startDate;

  @HiveField(1)
  DateTime endDate;

  @HiveField(2)
  String countryCode;
}
