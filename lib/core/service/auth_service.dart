import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

enum AuthResult { Success, Failed, Exception, NotAvailable }

abstract class AuthService {
  /// 授权，返回[true]代表授权成功
  Future<AuthResult> authenticate();

  /// 取消授权，返回[true]代表成功
  Future<bool> stopAuthenticate();

  /// 是否支持生物识别
  Future<bool> supportBiometric();
}

class AuthServiceImpl implements AuthService {
  final _auth = LocalAuthentication();

  @override
  Future<AuthResult> authenticate() async {
    try {
      var availableBiometrics = await _auth.getAvailableBiometrics();
      print(availableBiometrics);
      BiometricType? type;
      if (availableBiometrics.contains(BiometricType.face)) {
        type = BiometricType.face;
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        type = BiometricType.fingerprint;
      } else if (availableBiometrics.contains(BiometricType.iris)) {
        type = BiometricType.iris;
      }
      var isAuthenticated = await _auth.authenticate(
          localizedReason: '授权以解锁Allpass',
          authMessages: [
            _iosAuthMessages(type),
            _androidAuthMessages()
          ],
          options: AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
            biometricOnly: true,
          ),
      );
      if (isAuthenticated) {
        return AuthResult.Success;
      } else {
        return AuthResult.Failed;
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == auth_error.notAvailable) {
        return AuthResult.NotAvailable;
      } else {
        return AuthResult.Exception;
      }
    }
  }

  IOSAuthMessages _iosAuthMessages(BiometricType? type) {
    String? goToSettingsDescription;
    String? lockOut;
    switch (type) {
      case BiometricType.face:
        goToSettingsDescription = "Face ID暂未启用，请去设置中开启Face ID后重试";
        lockOut = "Face ID被禁用，请锁屏后再解锁以启用Face ID";
        break;
      case BiometricType.fingerprint:
        goToSettingsDescription = "指纹解锁暂未启用，请去设置中开启指纹解锁后重试";
        lockOut = "指纹解锁被禁用，请锁屏后再解锁以启用指纹解锁";
        break;
      case BiometricType.iris:
        goToSettingsDescription = "生物识别暂未启用，请去设置中开启后重试";
        lockOut = "生物识别被禁用，请锁屏后再解锁以启用";
        break;
      default:
        goToSettingsDescription = "生物识别授权暂未启用，请去设置中开启Touch ID或Face ID后重试";
        break;
    }
    return IOSAuthMessages(
        cancelButton: "取消",
        goToSettingsButton: "去设置",
        goToSettingsDescription: goToSettingsDescription,
        lockOut: lockOut,
    );
  }

  AndroidAuthMessages _androidAuthMessages() {
    return AndroidAuthMessages(
        cancelButton: "取消",
        goToSettingsButton: "去设置",
        biometricRequiredTitle: "暂未开启生物识别",
        goToSettingsDescription: "指纹解锁暂未启用，请去设置中开启指纹解锁后重试",
        signInTitle: "请验证",
        biometricHint: "使用指纹解锁",
        biometricNotRecognized: "识别失败，请重试",
    );
  }

  @override
  Future<bool> stopAuthenticate() async {
    return await _auth.stopAuthentication();
  }

  @override
  Future<bool> supportBiometric() async {
    return await _auth.canCheckBiometrics;
  }
}
