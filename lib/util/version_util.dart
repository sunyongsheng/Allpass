class VersionUtil {

  VersionUtil._();

  static bool twoIsNewerVersion(String? version1, String? version2) {
    if (version1 == null || version2 == null) return false;
    if (version1.length != version2.length) {
      throw ArgumentError("版本号格式不正确");
    }
    List<String> versions1 = version1.split("\.");
    List<String> versions2 = version2.split("\.");
    for (int i = 0; i < versions1.length; i++) {
      if (int.parse(versions2[i]) > int.parse(versions1[i])) {
        return true;
      }
    }
    return false;
  }
}