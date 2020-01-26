import 'package:flutter/material.dart';

import 'package:allpass/utils/encrypt_util.dart';
import 'package:allpass/utils/string_process.dart';

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
  bool isChanged;  // 是否被修改

  PasswordBean(
      {@required String username,
      @required String password,
      @required String url,
      String folder: "默认",
      String notes: "",
      int fav: 0,
      int key,
      String name,
      List<String> label,
      bool isChanged: false}) {
    this.username = username;
    this.password = password;
    this.url = url;
    this.folder = folder;
    this.notes = notes;
    this.fav = fav;
    this.uniqueKey = key;
    this.isChanged = isChanged;

    if (name.trim().length < 1) {
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

  /// 将Map转化为PasswordBean
  static PasswordBean fromJson(Map<String, dynamic> map) {
    List<String> newLabel = List();
    if (map['label'] != null) {
      newLabel = waveLineSegStr2List(map['label']);
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

  /// 将PasswordBean转化为Map
  static Map<String, dynamic> toJson(PasswordBean bean)  {
    String labels = list2WaveLineSegStr(bean.label);
    Map<String, dynamic> map = {
      "uniqueKey": bean.uniqueKey,
      "name": bean.name,
      "username": bean.username,
      "password": bean.password,
      "url": bean.url,
      "folder": bean.folder,
      "fav": bean.fav,
      "notes": bean.notes,
      "label": labels
    };
    return map;
  }

  /// 将PasswordBean转化为csv格式的字符
  static Future<String> toCsv(PasswordBean bean) async {
    // 包含除[uniqueKey]的所有属性
    String labels = list2WaveLineSegStr(bean.label);
    String csv =
        "${bean.name},"
        "${bean.username},"
        "${EncryptUtil.decrypt(bean.password)},"
        "${bean.url},"
        "${bean.folder},"
        "${bean.notes},"
        "$labels,"
        "${bean.fav}\n";
    return csv;
  }
}
