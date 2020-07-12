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
  String createTime;  // 11 创建时间，为了方便数据库存储使用Iso8601String

  CardBean({
    int key,
    String name,
    @required String ownerName,
    @required String cardId,
    String password: "",
    String telephone: "",
    String folder: "默认",
    String notes: "",
    List<String> label,
    int fav: 0,
    String createTime,
    Color color,
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
    this.color = color;
    this.createTime = createTime ?? DateTime.now().toIso8601String();

    if (name.trim().length < 1 && ownerName.length > 0) {
      this.name = this.ownerName + "的卡片";
    } else {
      this.name = name;
    } //name
    this.label = label??List();
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
        label: newLabel,
        createTime: map['createTime']
    );
  }

  /// 将CardBean转化为Map
  Map<String, dynamic> toJson() {
    String labels = list2WaveLineSegStr(this.label);
    Map<String, dynamic> map = {
      "uniqueKey": this.uniqueKey,
      "name": this.name,
      "ownerName": this.ownerName,
      "cardId": this.cardId,
      "telephone": this.telephone,
      "password": this.password,
      "folder": this.folder,
      "fav": this.fav,
      "notes": this.notes,
      "label": labels,
      "createTime": this.createTime
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
        "${bean.fav},"
        "${bean.createTime}\n";
    return csv;
  }
}
