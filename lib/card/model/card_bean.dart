import 'package:allpass/core/model/data/base_model.dart';
import 'package:allpass/core/model/identifiable.dart';
import 'package:allpass/encrypt/encrypt_util.dart';
import 'package:allpass/util/string_util.dart';
import 'package:flutter/material.dart';

/// 保存“卡片”数据
class CardBean extends BaseModel implements Identifiable<CardBean> {
  static CardBean empty =
      CardBean(key: -1, name: "", ownerName: "", cardId: "");

  late int? uniqueKey; // 1 ID
  late String name; // 2 卡片名称
  late String ownerName; // 3 卡片拥有者
  late String cardId; // 4 卡片ID/卡号
  late String password; // 5 URL
  late String telephone; // 6 手机号
  late String folder; // 7 文件夹
  late String notes; // 8 备注
  late List<String> label; // 9 标签
  late int fav; // 10 是否标心
  late String createTime; // 11 创建时间，为了方便数据库存储使用Iso8601String
  late int sortNumber; // 12 排序号
  Gradient? gradientColor;

  CardBean({
    int? key,
    String? name,
    required String ownerName,
    required String cardId,
    String password = "",
    String telephone = "",
    String folder = "默认",
    String notes = "",
    List<String>? label,
    int fav = 0,
    String? createTime,
    int sortNumber = -1,
    Color? color,
    Gradient? gradientColor,
  }) {
    this.ownerName = ownerName;
    this.cardId = cardId;
    this.folder = folder;
    this.notes = notes;
    this.fav = fav;
    this.telephone = telephone;
    this.uniqueKey = key;
    this.password = password;
    this.color = color;
    this.gradientColor = gradientColor;
    this.createTime = createTime ?? DateTime.now().toIso8601String();
    this.sortNumber = sortNumber;

    if ((name?.trim().length ?? 0) < 1 && ownerName.length > 0) {
      this.name = this.ownerName + "的卡片";
    } else {
      this.name = name!;
    } //name
    if (notes == noneData) this.notes = "";
    if (telephone == noneData) this.telephone = "";
    this.label = label ?? [];
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

  CardBean copy() {
    return CardBean(
      key: this.uniqueKey,
      name: this.name,
      ownerName: this.ownerName,
      cardId: this.cardId,
      password: this.password,
      telephone: this.telephone,
      folder: this.folder,
      notes: this.notes,
      label: this.label,
      fav: this.fav,
      createTime: this.createTime,
      sortNumber: this.sortNumber,
      color: this.color,
      gradientColor: this.gradientColor,
    );
  }

  /// 将Map转化为普通的CardBean
  static CardBean fromJson(Map<String, dynamic> map) {
    assert(map["name"] != null);
    assert(map["ownerName"] != null);
    assert(map["cardId"] != null);
    assert(map["folder"] != null);
    assert(map["telephone"] != null);
    assert(map["fav"] != null);
    assert(map["password"] != null);
    assert(map['notes'] != null);

    List<String> newLabel = [];
    if (map['label'] != null) {
      newLabel = StringUtil.waveLineSegStr2List(map['label']);
    }
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
        createTime: map['createTime'],
        sortNumber: map['sortNumber']);
  }

  /// 将CardBean转化为Map
  Map<String, dynamic> toJson() {
    String labels = StringUtil.list2WaveLineSegStr(this.label);
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
      "createTime": this.createTime,
      "sortNumber": this.sortNumber
    };
    return map;
  }

  /// 将CardBean转化为csv格式的字符
  static String toCsv(CardBean bean) {
    // 包含除[uniqueKey]的所有属性
    String labels = StringUtil.list2WaveLineSegStr(bean.label);
    String pwd = EncryptUtil.decrypt(bean.password);
    String csv = "${bean.name},"
        "${bean.ownerName},"
        "${bean.cardId},"
        "$pwd,"
        "${bean.telephone},"
        "${bean.folder},"
        "${bean.notes},"
        "$labels,"
        "${bean.fav},"
        "${bean.createTime},"
        "${bean.sortNumber}\n";
    return csv;
  }

  @override
  int get hashCode => uniqueKey ?? -1;

  @override
  bool operator ==(Object another) {
    if (another is CardBean) {
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
  bool identify(CardBean other) {
    return this.name == other.name &&
        this.ownerName == other.ownerName &&
        this.cardId == other.cardId;
  }
}
