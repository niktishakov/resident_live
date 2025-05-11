import 'package:hive/hive.dart';

part 'coordinates_model.g.dart';

@HiveType(typeId: 3)
class CoordinatesHiveModel extends HiveObject {
  @HiveField(0)
  double latitude;

  @HiveField(1)
  double longitude;

  CoordinatesHiveModel({
    required this.latitude,
    required this.longitude,
  });
}
