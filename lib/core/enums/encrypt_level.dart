/// 加密等級
enum EncryptLevel {
  None,
  OnlyPassword,
  All
}

class EncryptLevels {

  static String getEncryptLevelName(EncryptLevel level) {
    switch (level) {
      case EncryptLevel.All:
        return "全部加密";
      case EncryptLevel.None:
        return "不加密";
      default:
        return "仅加密密码字段";
    }
  }

  static int getEncryptLevelCode(String levelName) {
    switch (levelName) {
      case "不加密":
        return 0;
      case "全部加密":
        return 2;
      default:
        return 1;
    }
  }

  static EncryptLevel getEncryptLevel(int levelCode) {
    switch (levelCode) {
      case 0:
        return EncryptLevel.None;
      case 2:
        return EncryptLevel.All;
      default:
        return EncryptLevel.OnlyPassword;
    }
  }

}