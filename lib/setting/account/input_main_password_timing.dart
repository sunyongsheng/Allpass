import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/util/version_util.dart';
import 'package:flutter/widgets.dart';

abstract interface class InputMainPasswordTiming {
  int get days;

  static InputMainPasswordTiming? tryParse(int? value) {
    if (value == null) {
      return null;
    }

    if (value <= 0) {
      if (VersionUtil.isDebug() && value == 0) {
        return DebugInputMainPasswordTiming.instance;
      }
      return InputMainPasswordTimingEnum.never;
    } else if (value == 7) {
      return InputMainPasswordTimingEnum.sevenDays;
    } else if (value == 10) {
      return InputMainPasswordTimingEnum.tenDays;
    } else if (value == 15) {
      return InputMainPasswordTimingEnum.fifteenDays;
    } else if (value == 30) {
      return InputMainPasswordTimingEnum.thirtyDays;
    } else {
      return null;
    }
  }
}

class DebugInputMainPasswordTiming implements InputMainPasswordTiming {

  DebugInputMainPasswordTiming._();

  static DebugInputMainPasswordTiming instance = DebugInputMainPasswordTiming._();

  @override
  int get days => 0;
}

enum InputMainPasswordTimingEnum implements InputMainPasswordTiming {
  sevenDays,
  tenDays,
  fifteenDays,
  thirtyDays,
  never;

  @override
  int get days {
    switch (this) {
      case InputMainPasswordTimingEnum.sevenDays:
        return 7;
      case InputMainPasswordTimingEnum.tenDays:
        return 10;
      case InputMainPasswordTimingEnum.fifteenDays:
        return 15;
      case InputMainPasswordTimingEnum.thirtyDays:
        return 30;
      case InputMainPasswordTimingEnum.never:
        return -1;
    }
  }
}

extension InputMainPasswordTimingExt on InputMainPasswordTiming {
  String l10n(BuildContext context) {
    switch (this) {
      case InputMainPasswordTimingEnum.sevenDays:
        return context.l10n.sevenDays;
      case InputMainPasswordTimingEnum.tenDays:
        return context.l10n.tenDays;
      case InputMainPasswordTimingEnum.fifteenDays:
        return context.l10n.fifteenDays;
      case InputMainPasswordTimingEnum.thirtyDays:
        return context.l10n.thirtyDays;
      case InputMainPasswordTimingEnum.never:
        return context.l10n.never;
      default:
        return "Now(Debug)";
    }
  }
}