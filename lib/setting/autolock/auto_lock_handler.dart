import 'package:allpass/core/param/config.dart';
import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/login/page/login_arguments.dart';
import 'package:allpass/navigation/navigator.dart';
import 'package:flutter/widgets.dart';

import 'auto_lock.dart';

class AutoLockHandler {

  AutoLockHandler._();

  static bool _pendingLock = false;
  static bool _hasLocked = false;

  static void pendingLock() {
    _pendingLock = true;
  }

  static void lock(BuildContext context) {
    if (_pendingLock) {
      _pendingLock = false;
      return;
    }

    switch (Config.autoLock) {
      case AutoLock.immediate:
        _lock(context);
        break;

      case AutoLock.disabled:
        break;

      default:
        if (RuntimeData.lastResumeTime == 0) {
          break;
        }

        if (DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(RuntimeData.lastResumeTime)).inSeconds > Config.autoLock.value) {
          _lock(context);
        }
        break;
    }
  }

  static void _lock(BuildContext context) {
    if (_hasLocked) {
      return;
    }

    _hasLocked = true;
    if (Config.enabledBiometrics) {
      AllpassNavigator.goAuthLoginPage(context, arguments: LoginArguments(fromAutoLock: true));
    } else {
      AllpassNavigator.goLoginPage(context, arguments: LoginArguments(fromAutoLock: true));
    }
  }

  static void unlock() {
    _hasLocked = false;
  }
}