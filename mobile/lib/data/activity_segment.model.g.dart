// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_segment.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivitySegmentImpl _$$ActivitySegmentImplFromJson(
        Map<String, dynamic> json) =>
    _$ActivitySegmentImpl(
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      country: json['country'] as String,
    );

Map<String, dynamic> _$$ActivitySegmentImplToJson(
        _$ActivitySegmentImpl instance) =>
    <String, dynamic>{
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'country': instance.country,
    };
