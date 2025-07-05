import "package:country_code_picker/country_code_picker.dart";
import "package:resident_live/shared/shared.dart";

class CountryHelper {
  /// Get country code by country name
  static String getCountryCodeByName(String countryName) {
    // Try to find the country code that matches this name
    for (final country in kCountries) {
      if (CountryCode.fromCountryCode(country.code ?? "").name == countryName) {
        return country.code ?? "";
      }
    }
    return "";
  }

  /// Get maximum allowed days per year for a country
  /// This is simplified - in reality would come from a database or API
  static int getCountryMaxDays(String countryCode) {
    // Common tax residency threshold is 183 days
    // Some countries have different limits for visa-free stay

    return 183; // Default tax residency threshold
  }
}
