import "package:intl/intl.dart";

String getShareResidence(String countryName, DateTime statusToggleAt, int statusToggleIn) {
  return """
$countryName's Summary:
Has A Residency 🚀
- $statusToggleIn days left
- Your Resident Status will be save until ${DateFormat("MMM dd, yyyy").format(statusToggleAt)}
Resident Live: App Link
""";
}

String getShareNonResidence(String countryName, DateTime statusToggleAt, int statusToggleIn) {
  return """
$countryName's Summary:
Non-Resident
- You’ll reach a resident status at ${DateFormat("MMM dd, yyyy").format(statusToggleAt)}
- $statusToggleIn days left
Resident Live: App Link
""";
}
