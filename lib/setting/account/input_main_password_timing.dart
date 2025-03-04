import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/widgets.dart';

enum InputMainPasswordTiming {
  sevenDays,
  tenDays,
  fifteenDays,
  thirtyDays,
  never;
}

class InputMainPasswordTimings {
  InputMainPasswordTimings._();

  static InputMainPasswordTiming? tryParse(int? value) {
    if (value == null) {
      return null;
    }

    if (value <= 0) {
      return InputMainPasswordTiming.never;
    } else if (value == 7) {
      return InputMainPasswordTiming.sevenDays;
    } else if (value == 10) {
      return InputMainPasswordTiming.tenDays;
    } else if (value == 15) {
      return InputMainPasswordTiming.fifteenDays;
    } else if (value == 30) {
      return InputMainPasswordTiming.thirtyDays;
    } else {
      return null;
    }
  }
}

extension InputMainPasswordTimingExt on InputMainPasswordTiming {
  String l10n(BuildContext context) {
    switch (this) {
      case InputMainPasswordTiming.sevenDays:
        return context.l10n.sevenDays;
      case InputMainPasswordTiming.tenDays:
        return context.l10n.tenDays;
      case InputMainPasswordTiming.fifteenDays:
        return context.l10n.fifteenDays;
      case InputMainPasswordTiming.thirtyDays:
        return context.l10n.thirtyDays;
      case InputMainPasswordTiming.never:
        return context.l10n.never;
    }
  }

  int get days {
    switch (this) {
      case InputMainPasswordTiming.sevenDays:
        return 7;
      case InputMainPasswordTiming.tenDays:
        return 10;
      case InputMainPasswordTiming.fifteenDays:
        return 15;
      case InputMainPasswordTiming.thirtyDays:
        return 30;
      case InputMainPasswordTiming.never:
        return -1;
    }
  }
}