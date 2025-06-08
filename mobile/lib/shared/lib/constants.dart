import "package:country_code_picker/country_code_picker.dart";
import "package:flutter/material.dart";
import "package:resident_live/gen/translations.g.dart";

List<CountryCode> get kCountries => codes.map(CountryCode.fromJson).toList();

const kDefaultScreenDelay = Duration(seconds: 2);
const kDefaultDuration = Duration(milliseconds: 300);
const kBorderRadius = 24.0;
const kLargeBorderRadius = 56.0;
List<String> getMonths(BuildContext context) => [
  context.t.monthJanuary,
  context.t.monthFebruary,
  context.t.monthMarch,
  context.t.monthApril,
  context.t.monthMay,
  context.t.monthJune,
  context.t.monthJuly,
  context.t.monthAugust,
  context.t.monthSeptember,
  context.t.monthOctober,
  context.t.monthNovember,
  context.t.monthDecember,
];

const vGradient = LinearGradient(
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  colors: [Color(0xff1B1B1B), Color(0xff282828)],
);

const kMainGradient = LinearGradient(
  colors: [Color(0xff1B1B1B), Color(0xff282828)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const kSuccessGradient = LinearGradient(
  colors: [Color(0xff12BF2D), Color(0xff68B975)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);
