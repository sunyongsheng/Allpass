import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

enum AuthResult {
  Success,
  Failed,
  Exception,
  NotAvailable
}

abstract class AuthService {

  /// 授权，返回[true]代表授权成功
  Future<AuthResult> authenticate();

  /// 取消授权，返回[true]代表成功
  Future<bool> stopAuthenticate();

  /// 是否支持生物识别
  Future<bool> canAuthenticate();

}

class AuthServiceImpl implements AuthService {

  final _auth = LocalAuthentication();

  final androidString = const AndroidAuthMessages(
      cancelButton: "取消",
      goToSettingsButton: "设置",
      goToSettingsDescription: "请设置你的指纹",
      biometricRequiredTitle: "请验证指纹",
      biometricNotRecognized: "指纹识别失败，请重新验证"
  );

  final iosString = const IOSAuthMessages(
      cancelButton: "取消",
      goToSettingsButton: "设置",
      goToSettingsDescription: "请设置你的指纹",
      lockOut: "指纹识别失败，请重新验证"
  );

  @override
  Future<AuthResult> authenticate() async {
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
      var isAuthenticated = await _auth.authenticate(
          localizedReason: '授权以访问账号',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
          androidAuthStrings: androidString,
          iOSAuthStrings: iosString
      );
      if (isAuthenticated) {
        return AuthResult.Success;
      } else {
        return AuthResult.Failed;
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == "NotAvailable") {
        return AuthResult.NotAvailable;
      } else {
        return AuthResult.Exception;
      }
    }
  }

  @override
  Future<bool> stopAuthenticate() async {
    return await _auth.stopAuthentication();
  }

  @override
  Future<bool> canAuthenticate() {
    return _auth.canCheckBiometrics;
  }
}