import 'dart:io' show Platform;
import 'package:flutter/services.dart';

import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

import 'package:allpass/params/params.dart';

class LocalAuthenticationService {
  final _auth = LocalAuthentication();

  bool isAuthenticated = false;

  final androidString = const AndroidAuthMessages(
    cancelButton: "取消",
    goToSettingsButton: "设置",
    goToSettingsDescription: "请设置你的指纹",
    fingerprintRequiredTitle: "请验证指纹",
    fingerprintNotRecognized: "指纹识别失败，请重新验证"
  );

  final iosString = const IOSAuthMessages(
      cancelButton: "取消",
      goToSettingsButton: "设置",
      goToSettingsDescription: "请设置你的指纹",
      lockOut: "指纹识别失败，请重新验证"
  );

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
          androidAuthStrings: androidString,
          iOSAuthStrings: iosString
        );
        return isAuthenticated;
      } on PlatformException catch (e) {
        print(e);
      }
    }
    return false;
  }
}