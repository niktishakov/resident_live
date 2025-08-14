import "package:hive/hive.dart";

part "trip_model.g.dart";

@HiveType(typeId: 4)
class TripHiveModel extends HiveObject {
  TripHiveModel({
    required this.id,
    required this.countryCode,
    required this.fromDate,
    required this.toDate,
    this.backgroundUrl,
  });

  @HiveField(0)
  String id;

  @HiveField(2)
  String countryCode;

  @HiveField(3)
  DateTime fromDate;

  @HiveField(4)
  DateTime toDate;

  @HiveField(5)
  String? backgroundUrl;
}
