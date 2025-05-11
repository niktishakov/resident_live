abstract interface class IAuthRepostory {
  Future<bool> isBiometricsSupported();

  Future<bool> authenticateByBiometrics({
    required String localizedReason,
    bool? stickyAuth,
    bool? biometricOnly,
  });

  Future<bool> stopAuthentication();
}
