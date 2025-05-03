import "package:domain/domain.dart";
import "package:intl/intl.dart";

String getShareResidence(CountryEntity residence) {
  return """
${residence.name}'s Summary:
Has A Residency 🚀
- ${residence.extraDays} Extra Days Available For Travelling
- Your Resident Status will be save until ${DateFormat("MMM dd, yyyy").format(residence.statusToggleAt)}
Resident Live: App Link
""";
}

String getShareNonResidence(CountryEntity residence) {
  return """
${residence.name}'s Summary:
Non-Resident
- You’ll reach a resident status at ${DateFormat("MMM dd, yyyy").format(residence.statusToggleAt)}
- ${residence.statusToggleIn} days left
Resident Live: App Link
""";
}
