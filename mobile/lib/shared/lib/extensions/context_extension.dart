import 'package:flutter/material.dart';

/// BuildContext extension

extension BuildContextExtension on BuildContext {
  /// Returns the [MediaQueryData] from the closest [MediaQuery] ancestor.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns the [ThemeData] from the closest [Theme] ancestor.
  ThemeData get theme => Theme.of(this);

  /// Returns the [TextTheme] from the closest [Theme] ancestor.
  TextTheme get textTheme => theme.textTheme;

  /// Returns the [ColorScheme] from the closest [Theme] ancestor.
  ColorScheme get colorScheme => theme.colorScheme;

  /// Returns the [Size] of the screen.
  Size get screenSize => mediaQuery.size;

  /// Returns the [Size] of the screen.
  double get screenWidth => screenSize.width;

  /// Returns the [Size] of the screen.
  double get screenHeight => screenSize.height;

  /// Returns the [Brightness] of the screen.
  Brightness get brightness => mediaQuery.platformBrightness;

  /// Returns the [Locale] of the screen.
  Locale get locale => Localizations.localeOf(this);

  /// Returns the [NavigatorState] of the screen.
  NavigatorState get navigator => Navigator.of(this);

  /// Returns the [OverlayState] of the screen.
  OverlayState get overlay => Overlay.of(this);

  /// Returns the [FocusScopeNode] of the screen.
  FocusScopeNode get focusScope => FocusScope.of(this);

  /// Returns the [FocusNode] of the screen.
  FocusNode get focusNode => Focus.of(this);

  /// Returns the [FocusManager] of the screen.
  FocusManager get focusManager => FocusManager.instance;

  /// Returns the [FocusScopeNode] of the screen.
  FocusScopeNode get rootFocus => FocusManager.instance.rootScope;
}
