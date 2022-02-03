/// 属性类型，包括文件夹与标签
enum CategoryType {
  folder,
  label,
  unknown
}

class CategoryTypes {
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
