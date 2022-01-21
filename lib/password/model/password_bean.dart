import 'package:flutter/material.dart';

import 'package:allpass/core/model/data/base_model.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/util/string_util.dart';

/// 存储新建的“密码”
class PasswordBean extends BaseModel {

  static PasswordBean empty = PasswordBean(key: -1, name: "", username: "", password: "", url: "");

  late int? uniqueKey; // 1 ID
  late String name; // 2 账号名称
  late String username; // 3 用户名
  late String password; // 4 密码
  late String url; // 5 地址
  late String folder; // 6 文件夹
  late String notes; // 7 备注
  late List<String>? label; // 8 标签
  late int fav; // 9 是否标心，0代表否
  late String createTime; // 10 创建时间，为了方便存储使用Iso8601String
  late int sortNumber;  // 12 排序号
  late String? appId; // 所属App包名

  PasswordBean(
      {int? key,
      required String name,
      required String username,
      required String password,
      String url: "",
      String folder: "默认",
      String notes: "",
      List<String>? label,
      int fav: 0,
      String? createTime,
      Color? color,
      int sortNumber: -1,
      String? appId}) {
    this.uniqueKey = key;
    this.name = name;
    this.username = username;
    this.password = password;
    this.url = url;
    this.folder = folder;
    this.notes = notes;
    this.label = label ?? [];
    this.fav = fav;
    this.createTime = createTime ?? DateTime.now().toIso8601String();
    this.sortNumber = sortNumber;
    this.color = color;
    this.appId = appId;

    if (url == BaseModel.noneData) this.url = "";
    if (notes == BaseModel.noneData) this.notes = "";
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
        this.url.toString() +
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
        List<String> newLabel = [];
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
            createTime: map['createTime'],
            sortNumber: map['sortNumber'],
            appId: map['appId']
        );
      case 2:
        List<String> newLabel = [];
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
            createTime: EncryptUtil.decrypt(map['createTime']),
            sortNumber: map['sortNumber'],
            appId: EncryptUtil.decrypt(map['appId'])
        );
      default:
        List<String> newLabel = [];
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
            createTime: map['createTime'],
            sortNumber: map['sortNumber'],
            appId: map['appId']
        );

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
      "createTime": this.createTime,
      "sortNumber": this.sortNumber,
      "appId": this.appId
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
        "${bean.createTime},"
        "${bean.sortNumber},"
        "${bean.appId}\n";
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
            label: List.from(pureBean.label ?? []),
            fav: pureBean.fav,
            createTime: pureBean.createTime,
            color: pureBean.color,
            sortNumber: pureBean.sortNumber,
            appId: pureBean.appId
        );
      case 2:
        String name = EncryptUtil.encrypt(pureBean.name);
        String username = EncryptUtil.encrypt(pureBean.username);
        String url = EncryptUtil.encrypt(BaseModel.isNoneDataOrItSelf(pureBean.url));
        String folder = EncryptUtil.encrypt(pureBean.folder);
        String notes = EncryptUtil.encrypt(BaseModel.isNoneDataOrItSelf(pureBean.notes));
        List<String> label = [];
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
            sortNumber: pureBean.sortNumber,
            color: pureBean.color,
            appId: pureBean.appId
        );
      default:
        return PasswordBean(
            key: pureBean.uniqueKey,
            name: pureBean.name,
            username: pureBean.username,
            password: pureBean.password,
            url: pureBean.url,
            folder: pureBean.folder,
            notes: pureBean.notes,
            label: List.from(pureBean.label ?? []),
            fav: pureBean.fav,
            createTime: pureBean.createTime,
            sortNumber: pureBean.sortNumber,
            color: pureBean.color,
            appId: pureBean.appId
        );
    }
  }

  @override
  int get hashCode => uniqueKey ?? -1;

  @override
  bool operator ==(Object another) {
    if (another is PasswordBean) {
      if (identical(this, another)) {
        return true;
      }
      if (this.uniqueKey == another.uniqueKey) {
        return true;
      }
    }
    return false;
  }
}
