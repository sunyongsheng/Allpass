import 'package:allpass/core/enums/encrypt_level.dart';

class EncryptItem {
  final EncryptLevel level;
  final String desc;

  EncryptItem(this.level, this.desc);
}

List<EncryptItem> encryptLevels = [
  EncryptItem(EncryptLevel.None, "备份文件中的密码将以明文状态进行展示"),
  EncryptItem(EncryptLevel.OnlyPassword, "默认选项，只加密密码字段"),
  EncryptItem(EncryptLevel.All, "所有字段均进行加密，无法直接从备份文件中获取信息")
];
