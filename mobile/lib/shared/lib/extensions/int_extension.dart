extension IntExtension on int {
  roundToNearestTen() {
    if (this == 0) {
      return 0;
    }
    return ((this - 1) ~/ 10 + 1) * 10;
  }

  roundToNearestFive() {
    if (this == 0) {
      return 0;
    }
    return ((this - 1) ~/ 5 + 1) * 5;
  }

  String toTimeZoneOffset() {
    return this >= 0 ? "+$this" : "-$this";
  }
}
