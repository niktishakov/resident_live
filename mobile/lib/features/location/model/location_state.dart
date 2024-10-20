import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

part 'location_state.g.dart';
part 'location_state.freezed.dart';

@freezed
class LocationState with _$LocationState {
  const factory LocationState({
    @JsonKey(includeFromJson: false, includeToJson: false) Position? position,
    @JsonKey(includeFromJson: false, includeToJson: false) Placemark? placemark,
    @Default("") String error,
  }) = _LocationState;

  const LocationState._();

  LocationState reset() => copyWith(position: null, placemark: null);
  LocationState failure(String error) => copyWith(error: error);

  factory LocationState.fromJson(Map<String, dynamic> json) =>
      _$LocationStateFromJson(json);

  bool isCurrentResidence(String isoCode) {
    return placemark?.isoCountryCode == isoCode;
  }
}
