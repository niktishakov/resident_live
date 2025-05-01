import "package:freezed_annotation/freezed_annotation.dart";
import "package:local_auth/local_auth.dart";

part "auth.state.freezed.dart";
part "auth.state.g.dart";

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isSupported,
    @Default(false) bool isEnabled,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool isAuthenticated,
    @Default(null) BiometricType? biometricType,
    String? error,
  }) = _AuthState;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
}
