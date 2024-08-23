class ActivitySegment {
  ActivitySegment({
    required this.startDate,
    required this.endDate,
    required this.country,
  });

  DateTime startDate;
  DateTime endDate;
  String country;

  int getDays() {
    return endDate.difference(startDate).inDays + 1;
  }

  @override
  int get hashCode => Object.hash(startDate, endDate, country);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return super == other;
  }
}
