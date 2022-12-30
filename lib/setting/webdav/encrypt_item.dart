import 'package:allpass/core/enums/encrypt_level.dart';

class EncryptItem {
  final EncryptLevel level;
  final String desc;

  EncryptItem(this.level, this.desc);
}

List<EncryptItem> encryptLevels = [
  EncryptItem(EncryptLevel.None, "不加密"),
  EncryptItem(EncryptLevel.OnlyPassword, "仅加密密码字段"),
  EncryptItem(EncryptLevel.All, "全部加密")
];