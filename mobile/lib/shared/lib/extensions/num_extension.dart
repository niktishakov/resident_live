extension NumExtension on num {
  String toCurrencyString({
    String? suffix,
    String decimalSeparator = ",",
  }) {
    String recursive({required num number, required bool pad}) {
      if (number < 1000.0) {
        if (number is int) {
          if (pad) {
            return number.toString().padLeft(3, "0");
          } else {
            return number.toString();
          }
        }

        final fixed = number.toStringAsFixed(2);
        final whole = fixed.substring(0, fixed.length - 3);
        if (fixed.endsWith(".0")) {
          if (pad) {
            return whole.padLeft(3, "0");
          } else {
            return whole;
          }
        } else {
          final rest = fixed.substring(fixed.length - 2, fixed.length).replaceAll(".", decimalSeparator);
          if (pad) {
            return '${whole.padLeft(3, '0')}$rest';
          } else {
            return whole + rest;
          }
        }
      }

      final left = number ~/ 1000;
      final right = number % 1000;
      return "${recursive(number: left, pad: false)} ${recursive(number: right, pad: true)}";
    }

    final rec = recursive(number: this, pad: false);
    if (suffix == null) return rec;
    return "$rec $suffix";
  }
}
