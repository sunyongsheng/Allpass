/// 加密等級
enum EncryptLevel {
  None,
  OnlyPassword,
  All
}

class EncryptLevels {

  static EncryptLevel parse(int levelCode) {
    for (var level in EncryptLevel.values) {
      if (level.index == levelCode) {
        return level;
      }
    }
    return EncryptLevel.OnlyPassword;
  }

}