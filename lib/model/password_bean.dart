import 'package:flutter/material.dart';

/// 存储新建的“密码”
class PasswordBean {
  int uniqueKey; // 1 ID
  String name; // 2 账号名称
  String username; // 3 用户名
  String password; // 4 密码
  String url; // 5 地址
  String folder; // 6 文件夹
  String notes; // 7 备注
  List<String> label; // 8 标签
  int fav; // 9 是否标心，0代表否

  PasswordBean(
      {@required String username,
      @required String password,
      @required String url,
      String folder: "默认",
      String notes: "",
      int fav: 0,
      int key, //: PASS_MAGIC,
      String name,
      List<String> label}) {
    this.username = username;
    this.password = password;
    this.url = url;
    this.folder = folder;
    this.notes = notes;
    this.fav = fav;
    this.uniqueKey = key;

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
  }

  // 将map转化为PasswordBean
  static PasswordBean fromJson(Map<String, dynamic> map) {
    List<String> newLabel = List();
    if (map['label'] != null) {
      List<String> labels = map["label"].split("~");
      if (labels != null) {
        for (String la in labels) {
          if (la != "" && la != "~" && la != " " && la != ",") newLabel.add(la);
        }
      }
    }
    assert(map["username"] != null);
    assert(map["password"] != null);
    assert(map["url"] != null);
    assert(map["folder"] != null);
    assert(map["uniqueKey"] != null);
    assert(map["fav"] != null);
    assert(map["name"] != null);
    return PasswordBean(
        username: map['username'],
        password: map["password"],
        url: map["url"],
        folder: map["folder"],
        notes: map["notes"],
        fav: map["fav"],
        key: map["uniqueKey"],
        name: map["name"],
        label: newLabel);
  }

  @override
  String toString() {
    return "{uniqueKey:" +
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
