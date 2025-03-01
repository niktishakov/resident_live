import 'package:easy_localization/easy_localization.dart';

String getCountryName(String countryCode) {
  return 'countries.$countryCode'.tr();
}
