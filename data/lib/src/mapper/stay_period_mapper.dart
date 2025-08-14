import "package:data/data.dart";
import "package:domain/domain.dart";

extension StayPeriodMapper on StayPeriodValueObject {
  StayPeriodHiveValueObject toHiveValueObject() =>
      StayPeriodHiveValueObject(startDate: startDate, endDate: endDate, countryCode: countryCode);
}

extension StayPeriodHiveValueObjectMapper on StayPeriodHiveValueObject {
  StayPeriodValueObject toValueObject() =>
      StayPeriodValueObject(startDate: startDate, endDate: endDate, countryCode: countryCode);
}
