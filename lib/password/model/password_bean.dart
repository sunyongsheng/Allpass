import 'package:allpass/core/model/data/base_model.dart';
import 'package:allpass/core/model/identifiable.dart';
import 'package:allpass/encrypt/encrypt_util.dart';
import 'package:allpass/util/string_util.dart';
import 'package:flutter/material.dart';

/// 存储新建的“密码”
class PasswordBean extends BaseModel implements Identifiable<PasswordBean> {
  static PasswordBean empty =
      PasswordBean(key: -1, name: "", username: "", password: "", url: "");

  bool encrypted = true;

  late int? uniqueKey; // 1 ID
  late String name; // 2 账号名称
  late String username; // 3 用户名
  late String password; // 4 密码
  late String url; // 5 地址
  late String folder; // 6 文件夹
  late String notes; // 7 备注
  late List<String> label; // 8 标签
  late int fav; // 9 是否标心，0代表否
  late String createTime; // 10 创建时间，为了方便存储使用Iso8601String
  late int sortNumber; // 12 排序号
  late String? appId; // 13 所属App包名
  late String? appName; // 14 所属App名称

  PasswordBean({
    int? key,
    required String name,
    required String username,
    required String password,
    String url = "",
    String folder = "默认",
    String notes = "",
    List<String>? label,
    int fav = 0,
    String? createTime,
    Color? color,
    int sortNumber = -1,
    String? appId,
    String? appName,
    bool encrypted = true,
  }) {
    this.encrypted = encrypted;
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
    this.appName = appName;

    if (url == noneData) this.url = "";
    if (notes == noneData) this.notes = "";
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
        ", createTime:" +
        this.createTime +
        ", folder:" +
        this.folder +
        ", label:" +
        this.label.toString() +
        "}";
  }

  PasswordBean copy() {
    return PasswordBean(
      key: uniqueKey,
      name: name,
      username: username,
      password: password,
      url: url,
      folder: folder,
      notes: notes,
      label: label,
      fav: fav,
      createTime: createTime,
      sortNumber: sortNumber,
      appId: appId,
      appName: appName,
      color: color,
    );
  }

  /// 将Map转化为普通的PasswordBean
  static PasswordBean fromJson(Map<String, dynamic> map) {
    assert(map["uniqueKey"] != null);
    assert(map["name"] != null);
    assert(map["username"] != null);
    assert(map["password"] != null);

    List<String> newLabel = [];
    if (map['label'] != null) {
      newLabel = StringUtil.waveLineSegStr2List(map['label']);
    }
    return PasswordBean(
      key: map["uniqueKey"],
      name: map["name"],
      username: map['username'],
      password: map["password"],
      url: map["url"] ?? "",
      folder: map["folder"] ?? "默认",
      notes: map["notes"] ?? "",
      fav: map["fav"] ?? 0,
      label: newLabel,
      createTime: map['createTime'],
      sortNumber: map['sortNumber'] ?? -1,
      appId: map['appId'],
      appName: map['appName'],
    );
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
      "appId": this.appId,
      "appName": this.appName
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
        "${bean.appId ?? ""},"
        "${bean.appName ?? ""}\n";
    return csv;
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

  @override
  bool identify(PasswordBean other) {
    return this.name == other.name &&
        this.username == other.username &&
        this.url == other.url;
  }
}
