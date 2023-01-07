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
  String get name {
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

class EncryptItem {
  final EncryptLevel level;
  final String desc;

  const EncryptItem(this.level, this.desc);
}

List<EncryptItem> encryptLevels = [
  const EncryptItem(EncryptLevel.None, "备份文件中的密码将以明文状态进行展示"),
  const EncryptItem(EncryptLevel.OnlyPassword, "默认选项，只加密密码字段"),
  const EncryptItem(EncryptLevel.All, "所有字段均进行加密，无法直接从备份文件中获取信息")
];
