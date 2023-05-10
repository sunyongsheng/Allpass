import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

enum AuthResult { Success, Failed, Exception, NotAvailable }

abstract class AuthService {
  /// 授权，返回[true]代表授权成功
  Future<AuthResult> authenticate(BuildContext context);

  /// 取消授权，返回[true]代表成功
  Future<bool> stopAuthenticate();

  /// 是否支持生物识别
  Future<bool> supportBiometric();
}

class AuthServiceImpl implements AuthService {
  final _auth = LocalAuthentication();

  @override
  Future<AuthResult> authenticate(BuildContext context) async {
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
          localizedReason: context.l10n.authorizeToUnlock,
          authMessages: [
            _iosAuthMessages(context, type),
            _androidAuthMessages(context)
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

  IOSAuthMessages _iosAuthMessages(BuildContext context, BiometricType? type) {
    var l10n = context.l10n;
    String? goToSettingsDescription;
    String? lockOut;
    switch (type) {
      case BiometricType.face:
        goToSettingsDescription = l10n.iosGoToSettingsDescFingerprint;
        lockOut = l10n.iosLogoutFace;
        break;
      case BiometricType.fingerprint:
        goToSettingsDescription = l10n.iosGoToSettingsDescFingerprint;
        lockOut = l10n.iosLogoutFingerprint;
        break;
      case BiometricType.iris:
        goToSettingsDescription = l10n.iosGoToSettingsDescIris;
        lockOut = l10n.iosLogoutIris;
        break;
      default:
        goToSettingsDescription = l10n.iosGoToSettingsDescDefault;
        break;
    }
    return IOSAuthMessages(
        cancelButton: l10n.cancel,
        goToSettingsButton: l10n.gotoSettings,
        goToSettingsDescription: goToSettingsDescription,
        lockOut: lockOut,
    );
  }

  AndroidAuthMessages _androidAuthMessages(BuildContext context) {
    var l10n = context.l10n;
    return AndroidAuthMessages(
        cancelButton: l10n.cancel,
        goToSettingsButton: l10n.gotoSettings,
        biometricRequiredTitle: l10n.biometricRequiredTitle,
        goToSettingsDescription: l10n.androidGoToSettingsDesc,
        signInTitle: l10n.signInTitle,
        biometricHint: l10n.biometricHint,
        biometricNotRecognized: l10n.biometricsRecognizedFailed,
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
