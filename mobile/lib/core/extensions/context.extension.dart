import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  NavigatorState get navigator => Navigator.of(this);
}
