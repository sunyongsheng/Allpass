import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/widgets.dart';

enum AutoLock {
  immediate,
  in30s,
  disabled;

  static AutoLock? tryParse(int? value) {
    if (value == -1) {
      return AutoLock.immediate;
    } else if (value == 30) {
      return AutoLock.in30s;
    } else if (value == 0) {
      return AutoLock.disabled;
    } else {
      return null;
    }
  }
}

extension AutoLockExt on AutoLock {
  
  int get value {
    switch (this) {
      case AutoLock.immediate:
        return -1;
      case AutoLock.in30s:
        return 30;
      case AutoLock.disabled:
        return 0;
    }
  }
  
  String l10nStr(BuildContext ctx) {
    switch (this) {
      case AutoLock.immediate:
        return ctx.l10n.autoLockImmediate;
      case AutoLock.in30s:
        return ctx.l10n.autoLock30s;
      case AutoLock.disabled:
        return ctx.l10n.autoLockDisable;
    }
  }
}