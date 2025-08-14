import "package:resident_live/screens/validate_trip/widget/stay_limit/stay_limit_data.dart";
import "package:resident_live/shared/shared.dart";

List<StayLimitData> getMockStayLimits(RlTheme theme) {
  // Mock data for demonstration - replace with real calculation logic
  return [
    StayLimitData(countryCode: "KG", usedDays: 162, maxDays: 210, color: theme.textAccent),
    StayLimitData(countryCode: "RU", usedDays: 22, maxDays: 68, color: theme.textAccent),
    StayLimitData(countryCode: "VN", usedDays: 0, maxDays: 45, color: theme.textSecondary),
  ];
}
