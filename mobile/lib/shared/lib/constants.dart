import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:resident_live/generated/codegen_loader.g.dart';

const kDefaultScreenDelay = Duration(seconds: 2);
const kDefaultDuration = Duration(milliseconds: 300);
final kBorderRadius = BorderRadius.circular(24);
final kLargeBorderRadius = BorderRadius.circular(56);
final kMonths = [
  LocaleKeys.months_january.tr(),
  LocaleKeys.months_february.tr(),
  LocaleKeys.months_march.tr(),
  LocaleKeys.months_april.tr(),
  LocaleKeys.months_may.tr(),
  LocaleKeys.months_june.tr(),
  LocaleKeys.months_july.tr(),
  LocaleKeys.months_august.tr(),
  LocaleKeys.months_september.tr(),
  LocaleKeys.months_october.tr(),
  LocaleKeys.months_november.tr(),
  LocaleKeys.months_december.tr(),
];

final vGradient = LinearGradient(
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  colors: [
    Color(0xff1B1B1B),
    Color(0xff282828),
  ],
);

final kMainGradient = LinearGradient(
  colors: [
    Color(0xff1B1B1B),
    Color(0xff282828),
  ],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

final kSuccessGradient = LinearGradient(
  colors: [
    Color(0xff12BF2D),
    Color(0xff68B975),
  ],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

final modeEmojis = {
  'TRACE': '🔎',
  'DEBUG': '💬',
  'INFO': '💡',
  'WARN': '⚠️',
  'ERROR': '⛔',
};
