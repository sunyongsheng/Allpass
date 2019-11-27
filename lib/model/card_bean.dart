import 'package:flutter/material.dart';

/// 保存“卡片”数据
class CardBean {
  int uniqueKey; // 1 ID
  String name; // 2 卡片名称
  String ownerName; // 3 卡片拥有者
  String cardId; // 4 卡片ID/卡号
  String url; // 5 URL
  String telephone; // 6 手机号
  String folder; // 7 文件夹
  String notes; // 8 备注
  List<String> label; // 9 标签
  int fav; // 10 是否标心

  CardBean(
      {@required String ownerName,
      @required String cardId,
      String folder: "默认",
      String notes: "",
      int fav: 0,
      String telephone: "",
      int key, //: CARD_MAGIC,
      String url: "",
      String name,
      List<String> label}) {
    this.ownerName = ownerName;
    this.cardId = cardId;
    this.folder = folder;
    this.notes = notes;
    this.fav = fav;
    this.telephone = telephone;
    this.uniqueKey = key;
    this.url = url;

    if (name == null) {
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
        "url: " "$url, " +
        "fav: " "$fav" +
        "}";
  }

  // 将Map转化为CardBean
  static CardBean fromJson(Map<String, dynamic> map) {
    List<String> newLabel = List();
    if (map['label'] != null) {
      List<String> labels = map["label"].split("~");
      if (labels != null) {
        for (String la in labels) {
          if (la != "" && la != "~" && la != " " && la != ",") newLabel.add(la);
        }
      }
    }
    assert(map["name"] != null);
    assert(map["ownerName"] != null);
    assert(map["cardId"] != null);
    assert(map["folder"] != null);
    assert(map["telephone"] != null);
    assert(map["fav"] != null);
    assert(map["url"] != null);
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
        url: map['url'],
        label: newLabel);
  }
}

void copyCardBean(CardBean old, CardBean now) {
  // 复制除key以外的所有属性
  old.name = now.name;
  old.ownerName = now.ownerName;
  old.cardId = now.cardId;
  old.telephone = now.telephone;
  old.folder = now.folder;
  old.notes = now.notes;
  old.label = now.label;
  old.fav = now.fav;
  old.url = now.url;
}
