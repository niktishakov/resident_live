import 'package:data/data.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime createdAt;

  @HiveField(2)
  List<StayPeriodHiveValueObject> stayPeriods;

  @HiveField(3)
  bool isBiometricsEnabled;

  @HiveField(4)
  String focusedCountryCode;

  UserHiveModel({
    required this.id,
    required this.createdAt,
    this.stayPeriods = const [],
    this.isBiometricsEnabled = false,
    this.focusedCountryCode = "",
  });
}
