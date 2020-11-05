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
  All,
  OnlyPassword,
  None
}