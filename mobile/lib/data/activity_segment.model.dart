import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_segment.model.g.dart';
part 'activity_segment.model.freezed.dart';

@freezed
class ActivitySegment with _$ActivitySegment {
  const factory ActivitySegment({
    required DateTime startDate,
    required DateTime endDate,
    required String country,
  }) = _ActivitySegment;
  const ActivitySegment._();

  factory ActivitySegment.fromJson(Map<String, dynamic> json) =>
      _$ActivitySegmentFromJson(json);

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
