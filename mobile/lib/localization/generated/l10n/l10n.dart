// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Resident Live`
  String get appName {
    return Intl.message(
      'Resident Live',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Common`
  String get common {
    return Intl.message(
      'Common',
      name: 'common',
      desc: '',
      args: [],
    );
  }

  /// `On`
  String get commonOn {
    return Intl.message(
      'On',
      name: 'commonOn',
      desc: '',
      args: [],
    );
  }

  /// `Off`
  String get commonOff {
    return Intl.message(
      'Off',
      name: 'commonOff',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get commonCancel {
    return Intl.message(
      'Cancel',
      name: 'commonCancel',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get commonRemove {
    return Intl.message(
      'Remove',
      name: 'commonRemove',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get commonDelete {
    return Intl.message(
      'Delete',
      name: 'commonDelete',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get commonEdit {
    return Intl.message(
      'Edit',
      name: 'commonEdit',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get commonDone {
    return Intl.message(
      'Done',
      name: 'commonDone',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get commonContinue {
    return Intl.message(
      'Continue',
      name: 'commonContinue',
      desc: '',
      args: [],
    );
  }

  /// `Progress`
  String get commonProgress {
    return Intl.message(
      'Progress',
      name: 'commonProgress',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get commonOk {
    return Intl.message(
      'OK',
      name: 'commonOk',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get commonApply {
    return Intl.message(
      'Apply',
      name: 'commonApply',
      desc: '',
      args: [],
    );
  }

  /// `Focus`
  String get commonFocusTab {
    return Intl.message(
      'Focus',
      name: 'commonFocusTab',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get commonSettingsTab {
    return Intl.message(
      'Settings',
      name: 'commonSettingsTab',
      desc: '',
      args: [],
    );
  }

  /// `Good Night`
  String get homeGoodNight {
    return Intl.message(
      'Good Night',
      name: 'homeGoodNight',
      desc: '',
      args: [],
    );
  }

  /// `Good Morning`
  String get homeGoodMorning {
    return Intl.message(
      'Good Morning',
      name: 'homeGoodMorning',
      desc: '',
      args: [],
    );
  }

  /// `Good Afternoon`
  String get homeGoodAfternoon {
    return Intl.message(
      'Good Afternoon',
      name: 'homeGoodAfternoon',
      desc: '',
      args: [],
    );
  }

  /// `Good Evening`
  String get homeGoodEvening {
    return Intl.message(
      'Good Evening',
      name: 'homeGoodEvening',
      desc: '',
      args: [],
    );
  }

  /// `Your Focus`
  String get homeYourFocus {
    return Intl.message(
      'Your Focus',
      name: 'homeYourFocus',
      desc: '',
      args: [],
    );
  }

  /// `Set Focus`
  String get homeSetFocus {
    return Intl.message(
      'Set Focus',
      name: 'homeSetFocus',
      desc: '',
      args: [],
    );
  }

  /// `Days`
  String get homeDays {
    return Intl.message(
      'Days',
      name: 'homeDays',
      desc: '',
      args: [],
    );
  }

  /// `Tracking Residences`
  String get homeTrackingResidences {
    return Intl.message(
      'Tracking Residences',
      name: 'homeTrackingResidences',
      desc: '',
      args: [],
    );
  }

  /// `see all`
  String get homeSeeAll {
    return Intl.message(
      'see all',
      name: 'homeSeeAll',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsTitle {
    return Intl.message(
      'Settings',
      name: 'settingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Biometric Access`
  String get settingsBiometricAuth {
    return Intl.message(
      'Biometric Access',
      name: 'settingsBiometricAuth',
      desc: '',
      args: [],
    );
  }

  /// `Face ID Access`
  String get settingsFaceIdAccess {
    return Intl.message(
      'Face ID Access',
      name: 'settingsFaceIdAccess',
      desc: '',
      args: [],
    );
  }

  /// `Touch ID Access`
  String get settingsTouchIdAccess {
    return Intl.message(
      'Touch ID Access',
      name: 'settingsTouchIdAccess',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get settingsLanguage {
    return Intl.message(
      'Language',
      name: 'settingsLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get settingsNotifications {
    return Intl.message(
      'Notifications',
      name: 'settingsNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Share with friends`
  String get settingsShareWithFriends {
    return Intl.message(
      'Share with friends',
      name: 'settingsShareWithFriends',
      desc: '',
      args: [],
    );
  }

  /// `Rate Us`
  String get settingsRateUs {
    return Intl.message(
      'Rate Us',
      name: 'settingsRateUs',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get settingsPrivacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'settingsPrivacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Use`
  String get settingsTermsOfUse {
    return Intl.message(
      'Terms of Use',
      name: 'settingsTermsOfUse',
      desc: '',
      args: [],
    );
  }

  /// `About App`
  String get settingsAboutApp {
    return Intl.message(
      'About App',
      name: 'settingsAboutApp',
      desc: '',
      args: [],
    );
  }

  /// `Report a Bug`
  String get settingsReportBug {
    return Intl.message(
      'Report a Bug',
      name: 'settingsReportBug',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get languageTitle {
    return Intl.message(
      'Select Language',
      name: 'languageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Language updated`
  String get languageUpdated {
    return Intl.message(
      'Language updated',
      name: 'languageUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Residency Progress`
  String get detailsResidencyProgress {
    return Intl.message(
      'Residency Progress',
      name: 'detailsResidencyProgress',
      desc: '',
      args: [],
    );
  }

  /// `You are a resident!`
  String get detailsYouAreAResident {
    return Intl.message(
      'You are a resident!',
      name: 'detailsYouAreAResident',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get detailsOpen {
    return Intl.message(
      'Open',
      name: 'detailsOpen',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get detailsCalendar {
    return Intl.message(
      'Calendar',
      name: 'detailsCalendar',
      desc: '',
      args: [],
    );
  }

  /// `Move to this country to reach status in`
  String get detailsMoveToReachStatus {
    return Intl.message(
      'Move to this country to reach status in',
      name: 'detailsMoveToReachStatus',
      desc: '',
      args: [],
    );
  }

  /// `Status may be updated at`
  String get detailsStatusMayBeUpdated {
    return Intl.message(
      'Status may be updated at',
      name: 'detailsStatusMayBeUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Notify me for status updates`
  String get detailsNotifyMe {
    return Intl.message(
      'Notify me for status updates',
      name: 'detailsNotifyMe',
      desc: '',
      args: [],
    );
  }

  /// `Focus on this country`
  String get detailsFocusOnThisCountry {
    return Intl.message(
      'Focus on this country',
      name: 'detailsFocusOnThisCountry',
      desc: '',
      args: [],
    );
  }

  /// `Read a residency rules`
  String get detailsReadRules {
    return Intl.message(
      'Read a residency rules',
      name: 'detailsReadRules',
      desc: '',
      args: [],
    );
  }

  /// `Remove country`
  String get detailsRemoveCountry {
    return Intl.message(
      'Remove country',
      name: 'detailsRemoveCountry',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove this country from tracking?`
  String get detailsRemoveCountryConfirmation {
    return Intl.message(
      'Are you sure you want to remove this country from tracking?',
      name: 'detailsRemoveCountryConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Read a residence rules`
  String get detailsResidencyRulesResources {
    return Intl.message(
      'Read a residence rules',
      name: 'detailsResidencyRulesResources',
      desc: '',
      args: [],
    );
  }

  /// `Read on`
  String get detailsReadOn {
    return Intl.message(
      'Read on',
      name: 'detailsReadOn',
      desc: '',
      args: [],
    );
  }

  /// `You're free to travel about`
  String get statusesFreeToTravel {
    return Intl.message(
      'You\'re free to travel about',
      name: 'statusesFreeToTravel',
      desc: '',
      args: [],
    );
  }

  /// `You can travel until`
  String get statusesTravelUntil {
    return Intl.message(
      'You can travel until',
      name: 'statusesTravelUntil',
      desc: '',
      args: [],
    );
  }

  /// `Status update in`
  String get statusesStatusUpdateIn {
    return Intl.message(
      'Status update in',
      name: 'statusesStatusUpdateIn',
      desc: '',
      args: [],
    );
  }

  /// `Status will update at`
  String get statusesStatusWillUpdateAt {
    return Intl.message(
      'Status will update at',
      name: 'statusesStatusWillUpdateAt',
      desc: '',
      args: [],
    );
  }

  /// `You will lose your status in`
  String get statusesYouWillLoseYourStatusIn {
    return Intl.message(
      'You will lose your status in',
      name: 'statusesYouWillLoseYourStatusIn',
      desc: '',
      args: [],
    );
  }

  /// `Status is safe until`
  String get statusesStatusIsSafeUntil {
    return Intl.message(
      'Status is safe until',
      name: 'statusesStatusIsSafeUntil',
      desc: '',
      args: [],
    );
  }

  /// `Move to this country to reach status in`
  String get statusesMoveToThisCountryToReachStatusIn {
    return Intl.message(
      'Move to this country to reach status in',
      name: 'statusesMoveToThisCountryToReachStatusIn',
      desc: '',
      args: [],
    );
  }

  /// `Status may be updated at`
  String get statusesStatusMayBeUpdatedAt {
    return Intl.message(
      'Status may be updated at',
      name: 'statusesStatusMayBeUpdatedAt',
      desc: '',
      args: [],
    );
  }

  /// `Your Journey Over the`
  String get calendarYourJourney {
    return Intl.message(
      'Your Journey Over the',
      name: 'calendarYourJourney',
      desc: '',
      args: [],
    );
  }

  /// `Last 12 Months`
  String get calendarLast12Months {
    return Intl.message(
      'Last 12 Months',
      name: 'calendarLast12Months',
      desc: '',
      args: [],
    );
  }

  /// `All Tracking Residences`
  String get allCountriesAllTrackingResidences {
    return Intl.message(
      'All Tracking Residences',
      name: 'allCountriesAllTrackingResidences',
      desc: '',
      args: [],
    );
  }

  /// `of`
  String get allCountriesOf {
    return Intl.message(
      'of',
      name: 'allCountriesOf',
      desc: '',
      args: [],
    );
  }

  /// `days`
  String get allCountriesDays {
    return Intl.message(
      'days',
      name: 'allCountriesDays',
      desc: '',
      args: [],
    );
  }

  /// `Where have you been?`
  String get whereHaveYouBeenTitle {
    return Intl.message(
      'Where have you been?',
      name: 'whereHaveYouBeenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Search countries`
  String get whereHaveYouBeenSearchCountries {
    return Intl.message(
      'Search countries',
      name: 'whereHaveYouBeenSearchCountries',
      desc: '',
      args: [],
    );
  }

  /// `No results found`
  String get whereHaveYouBeenNoResultsFound {
    return Intl.message(
      'No results found',
      name: 'whereHaveYouBeenNoResultsFound',
      desc: '',
      args: [],
    );
  }

  /// `Select the countries you've visited in the last 12 months.`
  String get whereHaveYouBeenSelectCountries {
    return Intl.message(
      'Select the countries you\'ve visited in the last 12 months.',
      name: 'whereHaveYouBeenSelectCountries',
      desc: '',
      args: [],
    );
  }

  /// `Manage Your Residences`
  String get whereHaveYouBeenManageYourResidences {
    return Intl.message(
      'Manage Your Residences',
      name: 'whereHaveYouBeenManageYourResidences',
      desc: '',
      args: [],
    );
  }

  /// `Add Your Stay Periods`
  String get addStayPeriodTitle {
    return Intl.message(
      'Add Your Stay Periods',
      name: 'addStayPeriodTitle',
      desc: '',
      args: [],
    );
  }

  /// `For each country you visited, let us know how many days you stayed.`
  String get addStayPeriodDescription {
    return Intl.message(
      'For each country you visited, let us know how many days you stayed.',
      name: 'addStayPeriodDescription',
      desc: '',
      args: [],
    );
  }

  /// `Click to get started`
  String get addStayPeriodClickToGetStarted {
    return Intl.message(
      'Click to get started',
      name: 'addStayPeriodClickToGetStarted',
      desc: '',
      args: [],
    );
  }

  /// `Add Stay Period`
  String get addStayPeriodAddStayPeriod {
    return Intl.message(
      'Add Stay Period',
      name: 'addStayPeriodAddStayPeriod',
      desc: '',
      args: [],
    );
  }

  /// `How To Add Stay Periods`
  String get addStayPeriodHowToAddStayPeriods {
    return Intl.message(
      'How To Add Stay Periods',
      name: 'addStayPeriodHowToAddStayPeriods',
      desc: '',
      args: [],
    );
  }

  /// `Add Stay Periods`
  String get addStayPeriodAddStayPeriods {
    return Intl.message(
      'Add Stay Periods',
      name: 'addStayPeriodAddStayPeriods',
      desc: '',
      args: [],
    );
  }

  /// `1. Select a country\n2. Adjust dates on timeline\n3. Tap Add Period button`
  String get addStayPeriodPoints {
    return Intl.message(
      '1. Select a country\n2. Adjust dates on timeline\n3. Tap Add Period button',
      name: 'addStayPeriodPoints',
      desc: '',
      args: [],
    );
  }

  /// `You can add multiple periods\nto your timeline.`
  String get addStayPeriodYouCanAddMorePeriods {
    return Intl.message(
      'You can add multiple periods\nto your timeline.',
      name: 'addStayPeriodYouCanAddMorePeriods',
      desc: '',
      args: [],
    );
  }

  /// `Period from`
  String get addStayPeriodPeriodFrom {
    return Intl.message(
      'Period from',
      name: 'addStayPeriodPeriodFrom',
      desc: '',
      args: [],
    );
  }

  /// `Period to`
  String get addStayPeriodPeriodTo {
    return Intl.message(
      'Period to',
      name: 'addStayPeriodPeriodTo',
      desc: '',
      args: [],
    );
  }

  /// `Monday`
  String get weekdayMonday {
    return Intl.message(
      'Monday',
      name: 'weekdayMonday',
      desc: '',
      args: [],
    );
  }

  /// `Tuesday`
  String get weekdayTuesday {
    return Intl.message(
      'Tuesday',
      name: 'weekdayTuesday',
      desc: '',
      args: [],
    );
  }

  /// `Wednesday`
  String get weekdayWednesday {
    return Intl.message(
      'Wednesday',
      name: 'weekdayWednesday',
      desc: '',
      args: [],
    );
  }

  /// `Thursday`
  String get weekdayThursday {
    return Intl.message(
      'Thursday',
      name: 'weekdayThursday',
      desc: '',
      args: [],
    );
  }

  /// `Friday`
  String get weekdayFriday {
    return Intl.message(
      'Friday',
      name: 'weekdayFriday',
      desc: '',
      args: [],
    );
  }

  /// `Saturday`
  String get weekdaySaturday {
    return Intl.message(
      'Saturday',
      name: 'weekdaySaturday',
      desc: '',
      args: [],
    );
  }

  /// `Sunday`
  String get weekdaySunday {
    return Intl.message(
      'Sunday',
      name: 'weekdaySunday',
      desc: '',
      args: [],
    );
  }

  /// `January`
  String get monthJanuary {
    return Intl.message(
      'January',
      name: 'monthJanuary',
      desc: '',
      args: [],
    );
  }

  /// `February`
  String get monthFebruary {
    return Intl.message(
      'February',
      name: 'monthFebruary',
      desc: '',
      args: [],
    );
  }

  /// `March`
  String get monthMarch {
    return Intl.message(
      'March',
      name: 'monthMarch',
      desc: '',
      args: [],
    );
  }

  /// `April`
  String get monthApril {
    return Intl.message(
      'April',
      name: 'monthApril',
      desc: '',
      args: [],
    );
  }

  /// `May`
  String get monthMay {
    return Intl.message(
      'May',
      name: 'monthMay',
      desc: '',
      args: [],
    );
  }

  /// `June`
  String get monthJune {
    return Intl.message(
      'June',
      name: 'monthJune',
      desc: '',
      args: [],
    );
  }

  /// `July`
  String get monthJuly {
    return Intl.message(
      'July',
      name: 'monthJuly',
      desc: '',
      args: [],
    );
  }

  /// `August`
  String get monthAugust {
    return Intl.message(
      'August',
      name: 'monthAugust',
      desc: '',
      args: [],
    );
  }

  /// `September`
  String get monthSeptember {
    return Intl.message(
      'September',
      name: 'monthSeptember',
      desc: '',
      args: [],
    );
  }

  /// `October`
  String get monthOctober {
    return Intl.message(
      'October',
      name: 'monthOctober',
      desc: '',
      args: [],
    );
  }

  /// `November`
  String get monthNovember {
    return Intl.message(
      'November',
      name: 'monthNovember',
      desc: '',
      args: [],
    );
  }

  /// `December`
  String get monthDecember {
    return Intl.message(
      'December',
      name: 'monthDecember',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
