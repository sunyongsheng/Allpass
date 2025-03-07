import 'package:allpass/core/error/app_error.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/widgets.dart';

/// 加密等級
enum EncryptLevel {
  None, OnlyPassword, All;

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
    return switch (this) {
      EncryptLevel.None => l10n.encryptLevelNone,
      EncryptLevel.OnlyPassword => l10n.encryptLevelOnlyPassword,
      EncryptLevel.All => l10n.encryptLevelAll,
    };
  }

  String desc(BuildContext context) {
    var l10n = context.l10n;
    return switch (this) {
      EncryptLevel.None => l10n.encryptLevelNoneHelp,
      EncryptLevel.OnlyPassword => l10n.encryptLevelOnlyPasswordHelp,
      EncryptLevel.All => l10n.encryptLevelAllHelp,
    };
  }
}

var encryptLevels = [
  EncryptLevel.None,
  EncryptLevel.OnlyPassword,
  EncryptLevel.All,
];
