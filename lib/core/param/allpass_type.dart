/// 存储app中的类型
enum AllpassType {
  password,
  card
}

/// 属性类型，包括文件夹与标签
enum CategoryType {
  folder,
  label,
  unknown
}

class Category {
  static String getCategoryName(CategoryType type) {
    if (type == CategoryType.folder) {
      return "文件夹";
    } else if (type == CategoryType.label) {
      return "标签";
    } else {
      return "未知";
    }
  }

  static CategoryType getCategoryType(String name) {
    if (name == "文件夹") {
      return CategoryType.folder;
    } else if (name == "标签") {
      return CategoryType.label;
    } else {
      return CategoryType.unknown;
    }
  }
}

/// 加密等級
enum EncryptLevel {
  None,
  OnlyPassword,
  All,
  Unknown
}

class Encrypt {

  static String getEncryptLevelName(EncryptLevel level) {
    switch (level) {
      case EncryptLevel.All:
        return "全部加密";
      case EncryptLevel.OnlyPassword:
        return "仅加密密码字段";
      case EncryptLevel.None:
        return "不加密";
      default:
        return "未知";
    }
  }

  static EncryptLevel getEncryptLevel(String levelName) {
    switch (levelName) {
      case "不加密":
        return EncryptLevel.None;
      case "全部加密":
        return EncryptLevel.All;
      case "仅加密密码字段":
        return EncryptLevel.OnlyPassword;
      default:
        return EncryptLevel.Unknown;
    }
  }

}