import "package:flutter/material.dart";
import "package:resident_live/generated/l10n/l10n.dart";

const kDefaultScreenDelay = Duration(seconds: 2);
const kDefaultDuration = Duration(milliseconds: 300);
final kBorderRadius = BorderRadius.circular(24);
final kLargeBorderRadius = BorderRadius.circular(56);
List<String> getMonths(BuildContext context) => [
      S.of(context).monthJanuary,
      S.of(context).monthFebruary,
      S.of(context).monthMarch,
      S.of(context).monthApril,
      S.of(context).monthMay,
      S.of(context).monthJune,
      S.of(context).monthJuly,
      S.of(context).monthAugust,
      S.of(context).monthSeptember,
      S.of(context).monthOctober,
      S.of(context).monthNovember,
      S.of(context).monthDecember,
    ];

const vGradient = LinearGradient(
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  colors: [
    Color(0xff1B1B1B),
    Color(0xff282828),
  ],
);

const kMainGradient = LinearGradient(
  colors: [
    Color(0xff1B1B1B),
    Color(0xff282828),
  ],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const kSuccessGradient = LinearGradient(
  colors: [
    Color(0xff12BF2D),
    Color(0xff68B975),
  ],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);
