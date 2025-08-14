import "package:domain/domain.dart";
import "package:injectable/injectable.dart";
import "package:local_auth/local_auth.dart";

@Injectable(as: IAuthRepostory)
class AuthRepository implements IAuthRepostory {
  AuthRepository(this._localAuthService);
  final LocalAuthentication _localAuthService;

  @override
  Future<bool> isBiometricsSupported() {
    return _localAuthService.isDeviceSupported();
  }

  @override
  Future<bool> authenticateByBiometrics({
    required String localizedReason,
    bool? stickyAuth,
    bool? biometricOnly,
  }) {
    return _localAuthService.authenticate(
      localizedReason: localizedReason,
      options: AuthenticationOptions(
        stickyAuth: stickyAuth ?? false,
        biometricOnly: biometricOnly ?? false,
      ),
    );
  }

  @override
  Future<bool> stopAuthentication() {
    return _localAuthService.stopAuthentication();
  }
}
