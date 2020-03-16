import 'package:flutter/material.dart';

import 'package:allpass/model/base_model.dart';
import 'package:allpass/utils/string_process.dart';
import 'package:allpass/utils/encrypt_util.dart';

/// 保存“卡片”数据
class CardBean extends BaseModel {
  int uniqueKey; // 1 ID
  String name; // 2 卡片名称
  String ownerName; // 3 卡片拥有者
  String cardId; // 4 卡片ID/卡号
  String password; // 5 URL
  String telephone; // 6 手机号
  String folder; // 7 文件夹
  String notes; // 8 备注
  List<String> label; // 9 标签
  int fav; // 10 是否标心
  bool isChanged;

  CardBean(
      {@required String ownerName,
      @required String cardId,
      String folder: "默认",
      String notes: "",
      int fav: 0,
      String telephone: "",
      int key, //: CARD_MAGIC,
      String password: "",
      String name,
      List<String> label,
      bool isChanged: false}) {
    this.ownerName = ownerName;
    this.cardId = cardId;
    this.folder = folder;
    this.notes = notes;
    this.fav = fav;
    this.telephone = telephone;
    this.uniqueKey = key;
    this.password = password;
    this.isChanged = isChanged;

    if (name.trim().length < 1 && ownerName.length > 0) {
      this.name = this.ownerName + "的卡片";
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
    return "{key:" "$uniqueKey, " +
        "name:" "$name, " +
        "ownerName:" "$ownerName, " +
        "cardId:" "$cardId, " +
        "telephone: " "$telephone, " +
        "password: " "$password, " +
        "fav: " "$fav" +
        "}";
  }

  /// 将Map转化为CardBean
  static CardBean fromJson(Map<String, dynamic> map) {
    List<String> newLabel = List();
    if (map['label'] != null) {
      newLabel = waveLineSegStr2List(map['label']);
    }
    assert(map["name"] != null);
    assert(map["ownerName"] != null);
    assert(map["cardId"] != null);
    assert(map["folder"] != null);
    assert(map["telephone"] != null);
    assert(map["fav"] != null);
    assert(map["password"] != null);
    assert(map['notes'] != null);
    return CardBean(
        ownerName: map['ownerName'],
        cardId: map["cardId"],
        folder: map["folder"],
        notes: map["notes"],
        fav: map["fav"],
        key: map["uniqueKey"],
        name: map["name"],
        telephone: map["telephone"],
        password: map['password'],
        label: newLabel);
  }

  /// 将CardBean转化为Map
  static Map<String, dynamic> toJson(CardBean bean) {
    String labels = list2WaveLineSegStr(bean.label);
    Map<String, dynamic> map = {
      "uniqueKey": bean.uniqueKey,
      "name": bean.name,
      "ownerName": bean.ownerName,
      "cardId": bean.cardId,
      "telephone": bean.telephone,
      "password": bean.password,
      "folder": bean.folder,
      "fav": bean.fav,
      "notes": bean.notes,
      "label": labels
    };
    return map;
  }

  /// 将CardBean转化为csv格式的字符
  static String toCsv(CardBean bean) {
    // 包含除[uniqueKey]的所有属性
    String labels = list2WaveLineSegStr(bean.label);
    String pwd = EncryptUtil.decrypt(bean.password);
    String csv =
        "${bean.name},"
        "${bean.ownerName},"
        "${bean.cardId},"
        "$pwd,"
        "${bean.telephone},"
        "${bean.folder},"
        "${bean.notes},"
        "$labels,"
        "${bean.fav}\n";
    return csv;
  }
}
