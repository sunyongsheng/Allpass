import 'package:allpass/params/password_data.dart';

const int PASS_MAGIC = -12474; // 随便输的

/// 存储新建的“密码”
class PasswordBean {
  int uniqueKey;       // 1 ID
  String name;         // 2 账号名称
  String username;     // 3 用户名
  String password;     // 4 密码
  String url;          // 5 地址
  String folder;       // 6 文件夹
  String notes;        // 7 备注
  List<String> label;  // 8 标签
  int fav;             // 9 是否标心，0代表否

  PasswordBean(String username, String password, String url,
      {bool isNew: true,
      String folder: "默认",
      String notes: "",
      int fav: 0,
      int key: PASS_MAGIC,
      String name,
      List<String> label}) {
    this.username = username;
    this.password = password;
    this.url = url;
    this.folder = folder;
    this.notes = notes;
    this.fav = fav;
    this.uniqueKey = key;

    if (this.uniqueKey == PASS_MAGIC) {
      this.uniqueKey = getUniquePassKey(PasswordData.passwordKeySet);
    }

    if (name == null) {
      if (url.contains("weibo")) {
        this.name = "微博";
      } else if (url.contains("zhihu")) {
        this.name = "知乎";
      } else if (url.contains("gmail")) {
        this.name = "Gmail";
      } else if (url.contains("126")) {
        this.name = "126邮箱";
      } else {
        this.name = this.username;
      }
    } else {
      this.name = name;
    } //name

    if (label == null) {
      this.label = List();
    } else {
      this.label = label;
    } //label

    // 如果没有isNew参数，那么在编辑页面的暂存数据tempData就会新建一个Bean添加到List中，这样主页面中没有刷新就会报错
    if (isNew) {
      PasswordData.passwordData.add(this);
      PasswordData.passwordKeySet.add(this.uniqueKey);
    }
  }

  static int getUniquePassKey(Set<int> list) {
    int key = 1;
    while (true) {
      if (list.contains(key))
        ++key;
      else
        break;
    }
    return key;
  }

  @override
  String toString() {
    return "{key:" +
        this.uniqueKey.toString() +
        ", name:" +
        this.name +
        ", username:" +
        this.username +
        ", password:" +
        this.password +
        ", url:" +
        this.url +
        ", folder:" +
        this.folder +
        ", label:" +
        this.label.toString() +
        "}";
  }
}

void copyPasswordBean(PasswordBean old, PasswordBean now) {
  // 复制除key以外的所有属性
  old.name = now.name;
  old.username = now.username;
  old.password = now.password;
  old.url = now.url;
  old.label = now.label;
  old.folder = now.folder;
  old.notes = now.notes;
  old.fav = now.fav;
}
