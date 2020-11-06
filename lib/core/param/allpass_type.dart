/// 存储app中的类型
enum AllpassType {
  Password,
  Card
}

/// 属性类型，包括文件夹与标签
enum CategoryType {
  Folder,
  Label,
  Unknown
}

class Category {
  static String getCategoryName(CategoryType type) {
    if (type == CategoryType.Folder) {
      return "文件夹";
    } else if (type == CategoryType.Label) {
      return "标签";
    } else {
      return "未知";
    }
  }

  static CategoryType getCategoryType(String name) {
    if (name == "文件夹") {
      return CategoryType.Folder;
    } else if (name == "标签") {
      return CategoryType.Label;
    } else {
      return CategoryType.Unknown;
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