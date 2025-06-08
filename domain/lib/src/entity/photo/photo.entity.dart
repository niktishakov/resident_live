import "package:freezed_annotation/freezed_annotation.dart";

part "photo.entity.freezed.dart";

@freezed
class PhotoEntity with _$PhotoEntity {
  const factory PhotoEntity({
    required String id,
    required String description,
    String? altDescription,
    required PhotoUrlsEntity urls,
    required PhotoUserEntity user,
  }) = _PhotoEntity;
}

@freezed
class PhotoUrlsEntity with _$PhotoUrlsEntity {
  const factory PhotoUrlsEntity({
    required String raw,
    required String full,
    required String regular,
    required String small,
    required String thumb,
  }) = _PhotoUrlsEntity;
}

@freezed
class PhotoUserEntity with _$PhotoUserEntity {
  const factory PhotoUserEntity({
    required String username,
    required String name,
    String? location,
  }) = _PhotoUserEntity;
}
