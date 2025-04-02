import "package:intl/intl.dart";
import "package:json_annotation/json_annotation.dart";

/// See issue https://github.com/dart-lang/sdk/issues/37420
class GhDateTimeConverter implements JsonConverter<DateTime, String> {
  const GhDateTimeConverter();

  @override
  DateTime fromJson(String formattedUtcDate) {
    // Dates coming from the backend are always UTC but they are missing the time-zone offset part.
    // In order to have a UTC DateTime we parse using the parse method which will think the date is
    // local due to missing time-zone offset part and then use the single elements to create a UTC date.
    final local = DateTime.parse(formattedUtcDate);

    return DateTime.utc(
      local.year,
      local.month,
      local.day,
      local.hour,
      local.minute,
      local.second,
      local.millisecond,
      local.microsecond,
    );
  }

  @override
  String toJson(DateTime date) => DateFormat("yyyy-MM-dd").format(date);
}

class GhNullableDateTimeConverter implements JsonConverter<DateTime?, String?> {
  const GhNullableDateTimeConverter();

  @override
  DateTime? fromJson(String? formattedUtcDate) {
    if (formattedUtcDate == null) {
      return null;
    }

    return const GhDateTimeConverter().fromJson(formattedUtcDate);
  }

  @override
  String? toJson(DateTime? date) =>
      date != null ? const GhDateTimeConverter().toJson(date) : null;
}

extension DateHelpers on DateTime {
  static const oneDay = Duration(days: 1);
  static const oneWeek = Duration(days: 7);
  static const thirteenYears = Duration(days: 4748);

  static DateTime get nowUtc => DateTime.now().toUtc();

  static int get utcYear => nowUtc.year;

  static DateTime get twoWeeksAgo => nowUtc.dateOnly.subtract(oneWeek * 2);

  static DateTime get fourWeeksAgo => nowUtc.dateOnly.subtract(oneWeek * 4);

  static DateTime get eightWeeksAgo => nowUtc.dateOnly.subtract(oneWeek * 8);

  DateTime get dateOnly => DateTime.utc(year, month, day);

  /// Returns true if a given date [isToday] taking into account only [day], [month] and [year].
  /// Getters are also available for [isYesterday] or [isTomorrow].
  ///
  /// The following snippet shows why using [inDays] when you need to know if a date is today, yesterday, or tomorrow is incorrect.
  /// 'a' and 'b' represent two different days but since they are not at least 24hrs apart the result is incorrect.
  /// E.g.:   final a = DateTime.utc(2021, 2, 4, 9);
  ///         final b = DateTime.utc(2021, 2, 3, 23);
  ///         print(a.difference(b).inDays); // 0
  bool get isToday {
    final now = nowUtc;
    return now.day == day && now.month == month && now.year == year;
  }

  /// See [isToday]
  bool get isYesterday {
    final yesterday = nowUtc.subtract(oneDay);
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }

  /// See [isToday]
  bool get isTomorrow {
    final tomorrow = nowUtc.add(oneDay);
    return tomorrow.day == day &&
        tomorrow.month == month &&
        tomorrow.year == year;
  }

  bool get isAfterToday => dateOnly.isAfter(nowUtc.dateOnly);

  int get daysUntilToday {
    final from = nowUtc.dateOnly;
    final to = dateOnly;
    return (to.difference(from).inHours / 24).round().abs();
  }

  int get toAge {
    final now = nowUtc;
    var years = now.year - year;

    if (month > now.month) {
      years--;
    } else if (now.month == month) {
      if (day > now.day) {
        years--;
      }
    }
    return years;
  }

  String get dobFormat {
    final _month = "$month".padLeft(2, "0");
    final _day = "$day".padLeft(2, "0");

    return '$year$_month$_day';
  }

  int get secondsSinceEpoch {
    return (millisecondsSinceEpoch / 1000).round();
  }

  int get toUtcTimestamp {
    return toUtc().millisecondsSinceEpoch ~/ 1000;
  }

  bool isWithinXDaysEndingWith(int days, DateTime other) {
    final end = other.dateOnly;
    final start = end.subtract(Duration(days: days));
    final thisDateOnly = dateOnly;

    return (thisDateOnly.isAtSameMomentAs(start) ||
            thisDateOnly.isAfter(start)) &&
        (thisDateOnly.isBefore(end) || thisDateOnly.isAtSameMomentAs(end));
  }

  /// Inclusive of both [start] and [end] by default. Use [includeStart], [includeEnd]
  /// to tweak the boundaries as required. Only compares date and not time.
  ///
  /// For example
  /// ```
  /// final start = DateTime('01/01/2001')
  /// final end = DateTime('03/01/2001');
  ///
  /// final date = DateTime('01/01/2001');
  /// isBetweenDate(start: start, end: end) => true
  /// isBetweenDate(start: start, end: end, includeStart: false) => false
  /// ```
  bool isBetweenDates({
    required DateTime start,
    required DateTime end,
    bool includeStart = true,
    bool includeEnd = true,
  }) {
    final date = dateOnly;

    final startPosition = date.compareTo(start.dateOnly);
    final isAfterStart = includeStart ? startPosition >= 0 : startPosition > 0;

    if (!isAfterStart) {
      return false;
    }

    final endPosition = date.compareTo(end.dateOnly);
    final isBeforeEnd = includeEnd ? endPosition <= 0 : endPosition < 0;

    return isBeforeEnd;
  }

  static DateTime afterToday({
    int years = 0,
    int months = 0,
    int days = 0,
  }) {
    final today = nowUtc.dateOnly;

    return DateTime(
      today.year + years,
      today.month + months,
      today.day + days,
    );
  }

  static DateTime agoFromToday({
    int years = 0,
    int months = 0,
    int days = 0,
  }) {
    return afterToday(
      years: -years,
      months: -months,
      days: -days,
    );
  }

  static int sort(DateTime? a, DateTime? b) {
    if (a == null) {
      return -1;
    } else if (b == null) {
      return 1;
    } else {
      return a.compareTo(b);
    }
  }
}

extension NumDateExt on int {
  /// It picks whichever is closer to the current year
  /// E.g. if the current year is 2021, then
  ///     - 55.toFourDigitYear() is 2055
  ///     - 11.toFourDigitYear() is 2011
  ///     - 99.toFourDigitYear() is 1999
  ///     - 65.toFourDigitYear() is 1965
  int toFourDigitYear() {
    final now = DateTime.now();
    final nowTwoDigitYear = now.year % 100;
    final currentCentury = now.year - nowTwoDigitYear;
    final lastCentury = currentCentury - 100;

    final opt1 = currentCentury + this;
    final opt2 = lastCentury + this;

    return (now.year - opt1).abs() < (now.year - opt2).abs() ? opt1 : opt2;
  }

  DateTime get utcTimestampToDate {
    return DateTime.fromMillisecondsSinceEpoch(this * 1000, isUtc: true);
  }
}
