import 'package:intl/intl.dart';

extension Formatting on DateTime {
  String toFormattedString() {
    return DateFormat('MMMM d, yyyy \'at\' h:mm a').format(this);
  }

  /// Parse DateTime object to String
  /// for ex. 'December 12'
  String toMMMMddString() {
    return DateFormat("MMMM dd").format(this);
  }

  // Format DateTime object to String: '2023-09-25T06:00:02.000000+0000'
  String formatDateTimeToString() {
    String value = this.toIso8601String();
    value = value.substring(0, value.length - 4);
    return "${value}000000+0000";
  }

  /// Format DateTime object to String: '2023-09-25T06:00:02Z'
  String formatDateTimeToString2() {
    String value = this.toIso8601String();
    value = value.substring(0, value.length - 4);
    return "${value}Z";
  }

  String formatTimeToSecString() {
    return DateFormat('h:mm:ss a').format(this);
  }

  String toDDMMYYString() {
    return DateFormat('dd.MM.yy').format(toLocal());
  }

  String toTimeString() {
    return DateFormat('h:mm a').format(toLocal());
  }

  String toTimeAndMMMMDDString() {
    return DateFormat('h:mm a, MMMM dd').format(toLocal());
  }

  String toMMMDDString() {
    return DateFormat('MMM dd').format(toLocal());
  }
}
