import 'package:allpass/core/enums/encrypt_level.dart';

class EncryptItem {
  final EncryptLevel level;
  final String desc;

  EncryptItem(this.level, this.desc);
}

List<EncryptItem> encryptLevels =
    EncryptLevel.values.map((e) => EncryptItem(e, e.desc)).toList();
