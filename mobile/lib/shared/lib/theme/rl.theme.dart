import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

part 'text_styles.dart';

class RlTheme {
  RlTheme()
      : title80Semi = _title80Semi,
        title68Semi = _title68Semi,
        title32Semi = _title32Semi,
        title20 = _title20,
        title20Semi = _title20Semi,
        title16 = _title16,
        title16Semi = _title16Semi,
        body20 = _body20,
        body18 = _body18,
        body18M = _body18M,
        body16 = _body16,
        body16M = _body16M,
        body14 = _body14,
        body12 = _body12,
        body12M = _body12M,
        body12Semi = _body12Semi,
        body12Up = _body12Up,
        button16Semi = _button16Semi,
        button10M = _button10M,
        bgPrimary = const Color(0xFFF9F9F9),
        bgSecondary = const Color(0xFFF2F3F3),
        bgCard = const Color(0xFFFFFFFF),
        bgCardClick = const Color(0xFFF9F9F9),
        bgWhite = const Color(0xFFFFFFFF),
        bgAccent = const Color(0xFF6D7BFA),
        bgAccentClick = const Color(0xFF6876F7),
        bgAccentOpacity = const Color.fromRGBO(109, 123, 250, 0.12),
        bgDanger = const Color(0xFFFF6643),
        bgDangerOpacity = const Color.fromRGBO(255, 102, 67, 0.12),
        bgSuccess = const Color(0xFF8FC754),
        bgSuccessOpacity = const Color.fromRGBO(143, 199, 84, 0.12),
        bgWarning = const Color(0xFFFFB625),
        bgModal = const Color(0xff1f1f1f),
        bgPrimaryInverse = const Color(0xFF08091C),
        textPrimary = const Color(0xFF1E1E1E),
        textSecondary = const Color(0xFF878999),
        textTertiary = const Color(0xFFBBBCC6),
        textAccent = const Color(0xFF6D7BFA),
        textDanger = const Color(0xFFFF6643),
        textSuccess = const Color(0xFF8FC754),
        textPrimaryOnColor = const Color(0xFFFFFFFF),
        textPrimaryInverse = const Color(0xFFFFFFFF),
        textSecondaryInverse = const Color(0xFF9C9DA4),
        borderPrimary = const Color(0xFFE4E5E5),
        borderAccent = const Color(0xFF6D7BFA),
        borderWhite = const Color(0xFFFFFFFF),
        borderPrimaryInverse = const Color(0xFF08091C),
        borderDanger = const Color(0xffFF6643),
        iconPrimary = const Color(0xFF1E1E1E),
        iconSecondary = const Color(0xFF878999),
        iconTertiary = const Color(0xFFBBBCC6),
        iconAccent = const Color(0xFF6D7BFA),
        iconDanger = const Color(0xFFFF6643),
        iconSuccess = const Color(0xFF8FC754),
        iconPrimaryOnColor = const Color(0xFFFFFFFF),
        dividerPrimary = const Color(0xFFE4E5E5),
        shadowBlack = const Color.fromRGBO(0, 0, 0, 0.25),
        shadowGray = const Color(0x336A6D83),
        shadowAccent = const Color.fromRGBO(149, 163, 235, 0.70);

  final TextStyle title80Semi;
  final TextStyle title68Semi;
  final TextStyle title32Semi;
  final TextStyle title20;
  final TextStyle title20Semi;
  final TextStyle title16;
  final TextStyle title16Semi;
  final TextStyle body20;
  final TextStyle body18;
  final TextStyle body18M;
  final TextStyle body16;
  final TextStyle body16M;
  final TextStyle body14;
  final TextStyle body12;
  final TextStyle body12M;
  final TextStyle body12Semi;
  final TextStyle body12Up;
  final TextStyle button16Semi;
  final TextStyle button10M;

  final Color bgPrimary;
  final Color bgSecondary;
  final Color bgCard;
  final Color bgCardClick;
  final Color bgWhite;
  final Color bgAccent;
  final Color bgAccentClick;
  final Color bgAccentOpacity;
  final Color bgDanger;
  final Color bgDangerOpacity;
  final Color bgSuccess;
  final Color bgSuccessOpacity;
  final Color bgWarning;
  final Color bgModal;
  final Color bgPrimaryInverse;

  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textAccent;
  final Color textDanger;
  final Color textSuccess;
  final Color textPrimaryOnColor;
  final Color textPrimaryInverse;
  final Color textSecondaryInverse;

  final Color borderPrimary;
  final Color borderAccent;
  final Color borderWhite;
  final Color borderPrimaryInverse;
  final Color borderDanger;

  final Color iconPrimary;
  final Color iconSecondary;
  final Color iconTertiary;
  final Color iconAccent;
  final Color iconDanger;
  final Color iconSuccess;
  final Color iconPrimaryOnColor;

  final Color dividerPrimary;

  final Color shadowBlack;
  final Color shadowGray;
  final Color shadowAccent;

  final data = ThemeData(
    primaryColor: Color(0xff50B5FF),
    disabledColor: Colors.white.withOpacity(0.38),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStatePropertyAll(Color(0xff50B5FF)),
      thumbColor: WidgetStatePropertyAll(Colors.white.withOpacity(0.87)),
    ),
    colorScheme: ColorScheme.dark(
      primary: Color(0xff50B5FF),
      secondary: Colors.white.withOpacity(0.87),
      tertiary: Colors.grey[300],
      onTertiary: Color(0xff121212),
      surface: Color(0xff111111),
      onSurface: Colors.white.withOpacity(0.87),
    ),
    cardColor: Color(0xff2b2b2b),
    progressIndicatorTheme: ProgressIndicatorThemeData(
        circularTrackColor: Color(0xffD9D9D9),
        color: Color(
          0xff8E8E8E,
        )),
    scaffoldBackgroundColor: Color(0xff121212),
    dialogBackgroundColor: Color(0xff191919),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
      scaffoldBackgroundColor: Color(0xff121212),
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
      bodySmall: GoogleFonts.poppins().copyWith(color: Colors.white),
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
    dividerColor: Color(0xff343434),
    useMaterial3: true,
  );
}

ThemeData lightTheme = ThemeData(
  disabledColor: Colors.grey[200]!,
  colorScheme: ColorScheme.light(
    primary: Color(0xff50B5FF),
    secondary: Colors.black.withOpacity(0.87),
    surface: Colors.white,
    onSurface: Colors.grey,
    tertiary: Colors.grey[200],
    onTertiary: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.white,
  cardColor: Colors.grey[100],
  progressIndicatorTheme: ProgressIndicatorThemeData(
      circularTrackColor: Color(0xffD9D9D9),
      color: Color(
        0xff8E8E8E,
      )),
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
  dialogBackgroundColor: Color(0xfff5f5f5),
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.poppins().copyWith(color: Colors.black),
    headlineMedium: GoogleFonts.poppins().copyWith(color: Colors.black),
    headlineSmall: GoogleFonts.poppins().copyWith(color: Colors.black),
    bodyLarge: GoogleFonts.poppins().copyWith(color: Colors.black),
    bodyMedium: GoogleFonts.poppins().copyWith(color: Colors.black),
    bodySmall: GoogleFonts.poppins().copyWith(color: Colors.white),
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
    rangeSelectionBackgroundColor: Color(0xff50B5FF),
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

const kBrightOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Color(0x00000000),
  systemNavigationBarColor: Colors.transparent,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarIconBrightness: Brightness.light,
  systemStatusBarContrastEnforced: false,
  systemNavigationBarContrastEnforced: true,
);

const kDarkOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.white,
  systemNavigationBarColor: Colors.transparent,
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.light,
  systemNavigationBarIconBrightness: Brightness.light,
  systemStatusBarContrastEnforced: false,
  systemNavigationBarContrastEnforced: true,
);

void setBrightOverlayStyle() =>
    SystemChrome.setSystemUIOverlayStyle(kBrightOverlayStyle);
void setDarkOverlayStyle() =>
    SystemChrome.setSystemUIOverlayStyle(kDarkOverlayStyle);

void setSystemOverlayStyle() {
  final brightness = PlatformDispatcher.instance.platformBrightness;
  if (brightness == Brightness.dark) {
    setDarkOverlayStyle();
  } else {
    setBrightOverlayStyle();
  }
}

SystemUiOverlayStyle get getSystemOverlayStyle =>
    PlatformDispatcher.instance.platformBrightness == Brightness.dark
        ? kDarkOverlayStyle
        : kBrightOverlayStyle;
