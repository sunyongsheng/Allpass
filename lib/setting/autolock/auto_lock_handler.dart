import 'package:allpass/core/param/config.dart';
import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/navigation/navigator.dart';
import 'package:flutter/widgets.dart';

import 'auto_lock.dart';

class AutoLockHandler {

  AutoLockHandler._();

  static bool _pendingHandle = false;

  static void pendingHandle() {
    _pendingHandle = true;
  }

  static void handleOnResume(BuildContext context) {
    if (_pendingHandle) {
      _pendingHandle = false;
      return;
    }

    switch (Config.autoLock) {
      case AutoLock.immediate:
        if (Config.enabledBiometrics) {
          AllpassNavigator.goAuthLoginPage(context);
        } else {
          AllpassNavigator.goLoginPage(context);
        }
        break;

      case AutoLock.disabled:
        break;

      default:
        if (RuntimeData.lastResumeTime == 0) {
          break;
        }

        if (DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(RuntimeData.lastResumeTime)).inSeconds > Config.autoLock.value) {
          if (Config.enabledBiometrics) {
            AllpassNavigator.goAuthLoginPage(context);
          } else {
            AllpassNavigator.goLoginPage(context);
          }
        }
        break;
    }
  }
}