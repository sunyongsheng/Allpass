import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import 'package:allpass/params/params.dart';

class LocalAuthenticationService {
  final _auth = LocalAuthentication();

  bool isAuthenticated = false;

  Future<bool> authenticate() async {
    if (Params.enabledBiometrics) {
      try {
        List<BiometricType> availableBiometrics =
        await _auth.getAvailableBiometrics();

        if (Platform.isIOS) {
          if (availableBiometrics.contains(BiometricType.face)) {
            // Face ID.
          } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
            // Touch ID.
          }
        }
        isAuthenticated = await _auth.authenticateWithBiometrics(
          localizedReason: '授权以访问账号',
          useErrorDialogs: true,
          stickyAuth: true,
        );
        return isAuthenticated;
      } on PlatformException catch (e) {
        print(e);
      }
    }
    return false;
  }
}