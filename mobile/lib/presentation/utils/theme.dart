import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Colors.blue,
    secondary: Colors.blueAccent,
    background: Colors.black,
    surface: Color(0xFF121212),
    onBackground: Colors.white,
    onSurface: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  cupertinoOverrideTheme: MaterialBasedCupertinoThemeData(
    materialTheme: ThemeData.dark(),
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
  ),
  iconTheme: IconThemeData(color: Colors.white),
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
    color: Color(0xFF1E1E1E),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: Color(0xFF1E1E1E),
  ),
  dividerColor: Colors.white24,
  useMaterial3: true,
);

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.white,
    secondary: Colors.grey,
    background: Colors.white,
    surface: Colors.white,
    onBackground: Colors.black,
    onSurface: Colors.black,
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
      primaryColor: Colors.white,
      navLargeTitleTextStyle: TextStyle(
          color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
      navTitleTextStyle: TextStyle(color: Colors.white),
      navActionTextStyle: TextStyle(color: Colors.white),
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelTextStyle: MaterialStatePropertyAll(TextStyle(color: Colors.black)),
  ),
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
  ),
  dividerColor: Colors.black12,
  useMaterial3: true,
);
