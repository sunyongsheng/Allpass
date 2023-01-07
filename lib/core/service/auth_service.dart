import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

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

      BiometricType? type;
      if (availableBiometrics.contains(BiometricType.face)) {
        type = BiometricType.face;
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        type = BiometricType.fingerprint;
      } else if (availableBiometrics.contains(BiometricType.iris)) {
        type = BiometricType.iris;
      }
      var isAuthenticated = await _auth.authenticate(
          localizedReason: '授权以访问账号',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
          androidAuthStrings: _androidAuthMessages(type),
          iOSAuthStrings: _iosAuthMessages(type));
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
        break;
    }
    return IOSAuthMessages(
        cancelButton: "取消",
        goToSettingsButton: "去设置",
        goToSettingsDescription: goToSettingsDescription,
        lockOut: lockOut);
  }

  AndroidAuthMessages _androidAuthMessages(BiometricType? type) {
    String? goToSettingsDescription;
    String? title;
    String? notRecognized;
    switch (type) {
      // Android设备中优先考虑指纹解锁
      case BiometricType.fingerprint:
        title = "请验证指纹";
        notRecognized = "指纹识别失败，请重试";
        goToSettingsDescription = "指纹解锁暂未启用，请去设置中开启指纹解锁后重试";
        break;
      case BiometricType.face:
        title = "请验证面部";
        notRecognized = "面部识别失败，请重试";
        goToSettingsDescription = "面部解锁暂未启用，请去设置中开启面部解锁后重试";
        break;
      case BiometricType.iris:
        title = "请验证";
        notRecognized = "生物识别失败，请重试";
        goToSettingsDescription = "生物识别暂未启用，请去设置中开启后重试";
        break;
      default:
        break;
    }
    return AndroidAuthMessages(
        cancelButton: "取消",
        goToSettingsButton: "去设置",
        biometricRequiredTitle: "暂未开启生物识别",
        goToSettingsDescription: goToSettingsDescription,
        signInTitle: title,
        biometricHint: "验证以解锁Allpass",
        biometricNotRecognized: notRecognized);
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
