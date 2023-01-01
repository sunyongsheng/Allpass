import 'package:allpass/core/error/app_error.dart';

/// 加密等級
enum EncryptLevel { None, OnlyPassword, All }

class EncryptLevels {
  static EncryptLevel parse(int levelCode) {
    for (var level in EncryptLevel.values) {
      if (level.index == levelCode) {
        return level;
      }
    }
    throw UnsupportedArgumentException("Unsupported EncryptLevel code=$levelCode");
  }
}

extension EncryptLevelExt on EncryptLevel {
  String get desc {
    switch (this) {
      case EncryptLevel.None:
        return "不加密";
      case EncryptLevel.OnlyPassword:
        return "仅加密密码字段";
      case EncryptLevel.All:
        return "全部加密";
    }
  }
}
