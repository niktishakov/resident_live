import "package:freezed_annotation/freezed_annotation.dart";

part "photo_response.freezed.dart";
part "photo_response.g.dart";

@freezed
class PhotoResponse with _$PhotoResponse {
  const factory PhotoResponse({
    required int total,
    @JsonKey(name: "total_pages") required int totalPages,
    required List<PhotoResult> results,
  }) = _PhotoResponse;

  factory PhotoResponse.fromJson(Map<String, dynamic> json) => _$PhotoResponseFromJson(json);
}

@freezed
class PhotoResult with _$PhotoResult {
  const factory PhotoResult({
    required String id,
    required String slug,
    @JsonKey(name: "created_at") required DateTime createdAt,
    required String color,
    @JsonKey(name: "blur_hash") required String blurHash,
    required PhotoUrls urls,
    required PhotoUser user,
    String? description,
    @JsonKey(name: "alt_description") String? altDescription,
  }) = _PhotoResult;

  factory PhotoResult.fromJson(Map<String, dynamic> json) => _$PhotoResultFromJson(json);
}

@freezed
class PhotoUrls with _$PhotoUrls {
  const factory PhotoUrls({
    required String raw,
    required String full,
    required String regular,
    required String small,
    required String thumb,
  }) = _PhotoUrls;

  factory PhotoUrls.fromJson(Map<String, dynamic> json) => _$PhotoUrlsFromJson(json);
}

@freezed
class PhotoUser with _$PhotoUser {
  const factory PhotoUser({required String username, required String name, String? location}) =
      _PhotoUser;

  factory PhotoUser.fromJson(Map<String, dynamic> json) => _$PhotoUserFromJson(json);
}
