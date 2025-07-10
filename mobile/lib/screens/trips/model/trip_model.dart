import "package:domain/domain.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "trip_model.freezed.dart";

@freezed
class TripModel with _$TripModel {
  const factory TripModel({
    required String countryCode,
    required DateTime fromDate,
    required DateTime toDate,
    String? backgroundUrl,
    String? id,
  }) = _TripModel;

  factory TripModel.fromEntity(TripEntity entity) {
    return TripModel(
      countryCode: entity.countryCode,
      fromDate: entity.fromDate,
      toDate: entity.toDate,
      backgroundUrl: entity.backgroundUrl,
      id: entity.id,
    );
  }
}

extension TripModelMapper on TripModel {
  TripEntity toEntity() => TripEntity(
    countryCode: countryCode,
    fromDate: fromDate,
    toDate: toDate,
    backgroundUrl: backgroundUrl,
    id: id ?? (countryCode + DateTime.now().millisecondsSinceEpoch.toString()),
  );

  int get days {
    final difference = toDate.difference(fromDate).inDays;
    return difference >= 0 ? difference + 1 : 0;
  }

  bool get isValid {
    return countryCode.isNotEmpty && toDate.isAfter(fromDate) && !fromDate.isAtSameMomentAs(toDate);
  }

  String? get validationError {
    if (countryCode.isEmpty) return "Country is required";
    if (toDate.isBefore(fromDate)) return "To date must be after from date";
    if (fromDate.isAtSameMomentAs(toDate)) return "From date and to date must be different";
    return null;
  }
}
