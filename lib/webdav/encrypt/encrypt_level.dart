import 'package:allpass/core/error/app_error.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/widgets.dart';

/// 加密等級
enum EncryptLevel { None, OnlyPassword, All }

class EncryptLevels {
  static EncryptLevel parse(int levelCode) {
    for (var level in EncryptLevel.values) {
      if (level.index == levelCode) {
        return level;
      }
    }
    throw UnsupportedEnumException("Unsupported EncryptLevel code=$levelCode");
  }

  static EncryptLevel? tryParse(int? levelCode) {
    if (levelCode == null) return null;

    try {
      return parse(levelCode);
    } catch (_) {
      return null;
    }
  }
}

extension EncryptLevelExt on EncryptLevel {
  String title(BuildContext context) {
    var l10n = context.l10n;
    switch (this) {
      case EncryptLevel.None:
        return l10n.encryptLevelNone;
      case EncryptLevel.OnlyPassword:
        return l10n.encryptLevelOnlyPassword;
      case EncryptLevel.All:
        return l10n.encryptLevelAll;
    }
  }

  String desc(BuildContext context) {
    var l10n = context.l10n;
    switch (this) {
      case EncryptLevel.None:
        return l10n.encryptLevelNoneHelp;
      case EncryptLevel.OnlyPassword:
        return l10n.encryptLevelOnlyPasswordHelp;
      case EncryptLevel.All:
        return l10n.encryptLevelAllHelp;
    }
  }
}

class EncryptItem {
  final EncryptLevel level;
  final String desc;

  const EncryptItem(this.level, this.desc);
}

var encryptLevels = [
  EncryptLevel.None,
  EncryptLevel.OnlyPassword,
  EncryptLevel.All,
];
