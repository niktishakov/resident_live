import 'package:flutter/material.dart';

extension Parsing on String {
  num parseToNum() {
    return num.parse(replaceAll(',', '').replaceAll(' ', ''));
  }

  /// Parse timezone offset to String: '+6'
  String parseTimeZoneOffset() {
    // Regular expression to match the time zone offset format
    final regex = RegExp(r'^([+-]?)(\d{2}):?(\d{2})?$');

    // Match the input string against the regex
    final match = regex.firstMatch(this);

    if (match != null) {
      // Extract the sign, hours, and optional minutes from the match groups
      final sign = match.group(1) == '-' ? '-' : '+';
      var hours = int.parse(match.group(2)!);
      final minutes = match.group(3) != null ? int.parse(match.group(3)!) : 0;

      // Adjust hours based on the minutes value
      if (minutes >= 30) {
        hours += 1;
      }

      // Combine the sign and adjusted hours
      final parsedOffset = (sign == '-' ? -hours : hours).toString();

      return "${sign == '-' ? '' : "+"}$parsedOffset";
    } else {
      return this;
    }
  }

  /// String is in the format "#aabbcc" or "#ffaabbcc" with an optional leading "#".
  Color fromHexToColor() {
    try {
      final buffer = StringBuffer();
      if (length == 6 || length == 7) buffer.write('ff');
      buffer.write(replaceFirst('#', ''));

      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  /// String to lowcase and snake case
  String toSnakeCase() {
    return toLowerCase().replaceAll(' ', '_');
  }
}
