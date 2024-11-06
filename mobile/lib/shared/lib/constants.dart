import 'package:flutter/material.dart';

const kDefaultScreenDelay = Duration(seconds: 2);
const kDefaultDuration = Duration(milliseconds: 300);
final kBorderRadius = BorderRadius.circular(24);
final kLargeBorderRadius = BorderRadius.circular(60);
final kMonths = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

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
