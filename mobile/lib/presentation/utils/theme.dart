import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  primaryColor: Colors.blueAccent,
  disabledColor: Colors.grey[300],
  colorScheme: ColorScheme.dark(
    primary: Colors.blueAccent,
    secondary: Colors.white,
    tertiary: Colors.grey[300],
    onTertiary: Colors.black,
    surface: Colors.black,
    onSurface: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  cupertinoOverrideTheme: CupertinoThemeData(
    scaffoldBackgroundColor: Colors.black,
    barBackgroundColor: Colors.white,
    textTheme: CupertinoTextThemeData(
      primaryColor: Colors.white,
      navLargeTitleTextStyle: TextStyle(
          color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold),
      navTitleTextStyle: TextStyle(color: Colors.black),
      navActionTextStyle: TextStyle(color: Colors.black),
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelTextStyle: MaterialStatePropertyAll(TextStyle(color: Colors.white)),
  ),
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.poppins().copyWith(color: Colors.white),
    headlineMedium: GoogleFonts.poppins().copyWith(color: Colors.white),
    headlineSmall: GoogleFonts.poppins().copyWith(color: Colors.white),
    bodyLarge: GoogleFonts.poppins().copyWith(color: Colors.white),
    bodyMedium: GoogleFonts.poppins().copyWith(color: Colors.white),
    titleLarge: GoogleFonts.poppins().copyWith(color: Colors.white),
    titleMedium: GoogleFonts.poppins().copyWith(color: Colors.white),
    titleSmall: GoogleFonts.poppins().copyWith(color: Colors.white),
    labelLarge: GoogleFonts.poppins()
        .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
    labelMedium: GoogleFonts.poppins()
        .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
    labelSmall: GoogleFonts.poppins()
        .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
  ),
  iconTheme: IconThemeData(color: Colors.white),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue,
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Colors.blue,
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.grey[850],
  ),
  dialogTheme: DialogTheme(
    backgroundColor: Colors.grey[850],
  ),
  dividerColor: Colors.grey[900],
  useMaterial3: true,
);

ThemeData lightTheme = ThemeData(
  disabledColor: Colors.grey[200]!,
  colorScheme: ColorScheme.light(
    primary: Colors.blueAccent,
    secondary: Colors.black,
    surface: Colors.white,
    onSurface: Colors.grey,
    tertiary: Colors.grey[200],
    onTertiary: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0,
  ),
  cupertinoOverrideTheme: CupertinoThemeData(
    scaffoldBackgroundColor: Colors.white,
    barBackgroundColor: Colors.black,
    textTheme: CupertinoTextThemeData(
      primaryColor: Colors.black,
      navLargeTitleTextStyle: TextStyle(
          color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
      navTitleTextStyle: TextStyle(color: Colors.white),
      navActionTextStyle: TextStyle(color: Colors.white),
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelTextStyle: MaterialStatePropertyAll(TextStyle(color: Colors.black)),
  ),
  listTileTheme: ListTileThemeData(
    iconColor: Colors.black,
    textColor: Colors.black,
    selectedColor: Colors.blue,
    tileColor: Colors.white,
  ),
  dialogBackgroundColor: Colors.white,
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.poppins().copyWith(color: Colors.black),
    headlineMedium: GoogleFonts.poppins().copyWith(color: Colors.black),
    headlineSmall: GoogleFonts.poppins().copyWith(color: Colors.black),
    bodyLarge: GoogleFonts.poppins().copyWith(color: Colors.black),
    bodyMedium: GoogleFonts.poppins().copyWith(color: Colors.black),
    titleLarge: GoogleFonts.poppins().copyWith(color: Colors.black),
    titleMedium: GoogleFonts.poppins().copyWith(color: Colors.black),
    titleSmall: GoogleFonts.poppins().copyWith(color: Colors.black),
    labelLarge: GoogleFonts.poppins()
        .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
    labelMedium: GoogleFonts.poppins()
        .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
    labelSmall: GoogleFonts.poppins()
        .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
  ),
  datePickerTheme: DatePickerThemeData(
    backgroundColor: Colors.white,
    rangePickerBackgroundColor: Colors.white,
    rangeSelectionBackgroundColor: Colors.blueAccent,
    headerHeadlineStyle: GoogleFonts.poppins().copyWith(color: Colors.black),
    headerHelpStyle: GoogleFonts.poppins().copyWith(color: Colors.black),
    dayStyle: GoogleFonts.poppins().copyWith(color: Colors.black),
    weekdayStyle: GoogleFonts.poppins().copyWith(color: Colors.black),
    yearStyle: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),
  iconTheme: IconThemeData(color: Colors.black),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue,
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.blue,
    ),
  ),
  cardTheme: CardTheme(
    color: Color(0xFFE5E5E5),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: Color(0xFFE5E5E5),
    elevation: 0,
  ),
  dividerColor: Colors.grey[200],
  useMaterial3: true,
);

void setBrightOverlayStyle() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0x00000000),
    systemNavigationBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.light,
    systemStatusBarContrastEnforced: false,
    systemNavigationBarContrastEnforced: true,
  ));
}

void setDarkOverlayStyle() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    systemNavigationBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
    systemStatusBarContrastEnforced: false,
    systemNavigationBarContrastEnforced: true,
  ));
}
