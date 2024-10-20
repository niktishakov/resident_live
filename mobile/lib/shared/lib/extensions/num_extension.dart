extension NumExtension on num {
  String toCurrencyString({
    String? suffix,
    String decimalSeparator = ',',
  }) {
    String recursive(num num, bool pad) {
      if (num < 1000.0) {
        if (num is int) {
          if (pad) {
            return num.toString().padLeft(3, '0');
          } else {
            return num.toString();
          }
        }

        final fixed = num.toStringAsFixed(2);
        final whole = fixed.substring(0, fixed.length - 3);
        if (fixed.endsWith('.0')) {
          if (pad) {
            return whole.padLeft(3, '0');
          } else {
            return whole;
          }
        } else {
          final rest = fixed
              .substring(fixed.length - 2, fixed.length)
              .replaceAll('.', decimalSeparator);
          if (pad) {
            return '${whole.padLeft(3, '0')}$rest';
          } else {
            return '$whole$rest';
          }
        }
      }

      final left = num ~/ 1000;
      final right = num % 1000;
      return '${recursive(left, false)} ${recursive(right, true)}';
    }

    final rec = recursive(this, false);
    if (suffix == null) return rec;
    return '$rec $suffix';
  }
}
