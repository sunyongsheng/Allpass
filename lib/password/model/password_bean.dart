import 'package:flutter/material.dart';

import 'package:allpass/core/model/data/base_model.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/util/string_util.dart';

/// 存储新建的“密码”
class PasswordBean extends BaseModel {

  static PasswordBean empty = PasswordBean(key: -1, name: "", username: "", password: "", url: "");

  int uniqueKey; // 1 ID
  String name; // 2 账号名称
  String username; // 3 用户名
  String password; // 4 密码
  String url; // 5 地址
  String folder; // 6 文件夹
  String notes; // 7 备注
  List<String> label; // 8 标签
  int fav; // 9 是否标心，0代表否
  String createTime; // 10 创建时间，为了方便存储使用Iso8601String

  PasswordBean(
      {int key,
      String name,
      @required String username,
      @required String password,
      @required String url,
      String folder: "默认",
      String notes: "",
      List<String> label,
      int fav: 0,
      String createTime,
      Color color}) {
    this.username = username;
    this.password = password;
    this.url = url;
    this.folder = folder;
    this.notes = notes;
    this.fav = fav;
    this.uniqueKey = key;
    this.color = color;
    this.createTime = createTime ?? DateTime.now().toIso8601String();

    if ((name?.trim()?.length ?? 0) < 1) {
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
    if (url == BaseModel.noneData) this.url = "";
    if (notes == BaseModel.noneData) this.notes = "";
    this.label = label ?? List();
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

  /// 将Map转化为普通的PasswordBean
  static PasswordBean fromJson(Map<String, dynamic> map, {int encryptLevel = 1}) {
    assert(map["username"] != null);
    assert(map["password"] != null);
    assert(map["url"] != null);
    assert(map["folder"] != null);
    assert(map["uniqueKey"] != null);
    assert(map["fav"] != null);
    assert(map["name"] != null);
    switch (encryptLevel) {
      case 0:
        List<String> newLabel = List();
        if (map['label'] != null) {
          newLabel = StringUtil.waveLineSegStr2List(map['label']);
        }
        return PasswordBean(
            username: map['username'],
            password: EncryptUtil.encrypt(map['password']),
            url: map["url"],
            folder: map["folder"],
            notes: map["notes"],
            fav: map["fav"],
            key: map["uniqueKey"],
            name: map["name"],
            label: newLabel,
            createTime: map['createTime']);
      case 2:
        List<String> newLabel = List();
        if (map['label'] != null) {
          for (String str in StringUtil.waveLineSegStr2List(map['label'])) {
            newLabel.add(EncryptUtil.decrypt(str));
          }
        }
        return PasswordBean(
            username: EncryptUtil.decrypt(map['username']),
            password: map['password'],
            url: EncryptUtil.decrypt(map["url"]),
            folder: EncryptUtil.decrypt(map["folder"]),
            notes: EncryptUtil.decrypt(map["notes"]),
            fav: map["fav"],
            key: map["uniqueKey"],
            name: EncryptUtil.decrypt(map["name"]),
            label: newLabel,
            createTime: EncryptUtil.decrypt(map['createTime']));
      default:
        List<String> newLabel = List();
        if (map['label'] != null) {
          newLabel = StringUtil.waveLineSegStr2List(map['label']);
        }
        return PasswordBean(
            username: map['username'],
            password: map["password"],
            url: map["url"],
            folder: map["folder"],
            notes: map["notes"],
            fav: map["fav"],
            key: map["uniqueKey"],
            name: map["name"],
            label: newLabel,
            createTime: map['createTime']);

    }
  }

  /// 将PasswordBean转化为Map
  Map<String, dynamic> toJson() {
    String labels = StringUtil.list2WaveLineSegStr(this.label);
    Map<String, dynamic> map = {
      "uniqueKey": this.uniqueKey,
      "name": this.name,
      "username": this.username,
      "password": this.password,
      "url": this.url,
      "folder": this.folder,
      "fav": this.fav,
      "notes": this.notes,
      "label": labels,
      "createTime": this.createTime
    };
    return map;
  }

  /// 将PasswordBean转化为csv格式的字符
  static Future<String> toCsv(PasswordBean bean) async {
    // 包含除[uniqueKey]的所有属性
    String labels = StringUtil.list2WaveLineSegStr(bean.label);
    String csv = "${bean.name},"
        "${bean.username},"
        "${EncryptUtil.decrypt(bean.password)},"
        "${bean.url},"
        "${bean.folder},"
        "${bean.notes},"
        "$labels,"
        "${bean.fav},"
        "${bean.createTime}\n";
    return csv;
  }

  /// 将一个普通的PasswordBean转为加密的PasswordBean
  static PasswordBean fromBean(PasswordBean pureBean, {int encryptLevel = 1}) {
    switch (encryptLevel) {
      case 0:
        String _password = EncryptUtil.decrypt(pureBean.password);
        return PasswordBean(
            key: pureBean.uniqueKey,
            name: pureBean.name,
            username: pureBean.username,
            password: _password,
            url: pureBean.url,
            folder: pureBean.folder,
            notes: pureBean.notes,
            label: List()..addAll(pureBean.label),
            fav: pureBean.fav,
            createTime: pureBean.createTime,
            color: pureBean.color);
      case 2:
        String name = EncryptUtil.encrypt(pureBean.name);
        String username = EncryptUtil.encrypt(pureBean.username);
        String url = EncryptUtil.encrypt(BaseModel.isNoneDataOrItSelf(pureBean.url));
        String folder = EncryptUtil.encrypt(pureBean.folder);
        String notes = EncryptUtil.encrypt(BaseModel.isNoneDataOrItSelf(pureBean.notes));
        List<String> label = List();
        for (String l in pureBean.label ?? []) {
          label.add(EncryptUtil.encrypt(l));
        }
        String createTime = EncryptUtil.encrypt(pureBean.createTime);
        return PasswordBean(
            key: pureBean.uniqueKey,
            name: name,
            username: username,
            password: pureBean.password,
            url: url,
            folder: folder,
            notes: notes,
            label: label,
            fav: pureBean.fav,
            createTime: createTime,
            color: pureBean.color);
      default:
        return PasswordBean(
            key: pureBean.uniqueKey,
            name: pureBean.name,
            username: pureBean.username,
            password: pureBean.password,
            url: pureBean.url,
            folder: pureBean.folder,
            notes: pureBean.notes,
            label: List<String>()..addAll(pureBean.label),
            fav: pureBean.fav,
            createTime: pureBean.createTime,
            color: pureBean.color);
    }
  }
}
