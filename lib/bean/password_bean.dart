import 'package:allpass/params/password_data.dart';
import 'package:allpass/utils/test_data.dart';

/// 基类
class PasswordBase {
  int key;
  String name;          // 账号名称
  String username;      // 用户名
  String password;      // 密码
  String url;           // 地址
  String folder;        // 文件夹
  String notes;         // 备注
  List<String> label;   // 标签
  int fav;              // 是否标心，0代表否
}

/// 存储新建的“密码”
class PasswordBean extends PasswordBase {
  final int uniqueKey = getUniquePassKey(PasswordTestData.passwordList); // ID

  PasswordBean(String username, String password, String url,
      {String folder:"默认", String notes:"", int fav: 0, String name, List<String> label}) {

    this.key = uniqueKey;
    this.username = username;
    this.password = password;
    this.url = url;
    this.folder = folder;
    this.notes = notes;
    this.fav = fav;

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
    }//name

    if (label == null) {
      this.label = List();
    } else {
      this.label = label;
    }//label

    PasswordData.passwordData.add(this);
    PasswordData.passwordKeySet.add(this.key);
  }

  static int getUniquePassKey(List<PasswordBase> list) {
    int key = 1;
    while (true) {
      if (PasswordData.passwordKeySet.contains(key))
        ++key;
      else
        break;
    }
    return key;
  }

  @override
  String toString() {
    return "{key:" +
        this.key.toString() +
        ", name:" +
        this.name +
        ", username:" +
        this.username +
        ",url:" +
        this.url +
        ", folder:" +
        this.folder + "}";
  }
}

/// 将暂存数据复制给原先的数据
void copyPasswordBean(PasswordBean old, PasswordTempBean newData) {
  old.name = newData.name;
  old.username = newData.username;
  old.password = newData.password;
  old.url = newData.url;
  old.folder = newData.folder;
  old.label = newData.label;
  old.notes = newData.notes;
}

/// 存储在修改页面中修改后但未保存的暂存数据
/// 相比PasswordBean的不同之处在于key的初始化在构造函数中
class PasswordTempBean extends PasswordBase {
  final int uniqueKey;      // ID

  PasswordTempBean(this.uniqueKey, String username, String password, String url,
      {String folder:"默认", String notes:"", int fav: 0, String name, List<String> label}) {

    this.key = uniqueKey;
    this.username = username;
    this.password = password;
    this.url = url;
    this.folder = folder;
    this.notes = notes;
    this.fav = fav;

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
    }//name

    if (label == null) {
      this.label = List();
    } else {
      this.label = label;
    }//label
  }

  @override
  String toString() {
    return "{key:" +
        this.key.toString() +
        ", name:" +
        this.name +
        ", username:" +
        this.username +
        ",url:" +
        this.url +
        ", folder:" +
        this.folder + "}";
  }
}
