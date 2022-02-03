import 'package:allpass/core/enums/encrypt_level.dart';
import 'package:flutter/material.dart';

import 'package:allpass/core/model/data/base_model.dart';
import 'package:allpass/util/string_util.dart';
import 'package:allpass/util/encrypt_util.dart';

/// 保存“卡片”数据
class CardBean extends BaseModel {

  static CardBean empty = CardBean(key: -1, name: "", ownerName: "", cardId: "");

  late int? uniqueKey; // 1 ID
  late String name; // 2 卡片名称
  late String ownerName; // 3 卡片拥有者
  late String cardId; // 4 卡片ID/卡号
  late String password; // 5 URL
  late String telephone; // 6 手机号
  late String folder; // 7 文件夹
  late String notes; // 8 备注
  late List<String>? label; // 9 标签
  late int fav; // 10 是否标心
  late String createTime; // 11 创建时间，为了方便数据库存储使用Iso8601String
  late int sortNumber;  // 12 排序号

  CardBean(
      {int? key,
      String? name,
      required String ownerName,
      required String cardId,
      String password: "",
      String telephone: "",
      String folder: "默认",
      String notes: "",
      List<String>? label,
      int fav: 0,
      String? createTime,
      int sortNumber: -1,
      Color? color}) {
    this.ownerName = ownerName;
    this.cardId = cardId;
    this.folder = folder;
    this.notes = notes;
    this.fav = fav;
    this.telephone = telephone;
    this.uniqueKey = key;
    this.password = password;
    this.color = color;
    this.createTime = createTime ?? DateTime.now().toIso8601String();
    this.sortNumber = sortNumber;

    if ((name?.trim().length ?? 0) < 1 && ownerName.length > 0) {
      this.name = this.ownerName + "的卡片";
    } else {
      this.name = name!;
    } //name
    if (notes == BaseModel.noneData) this.notes = "";
    if (telephone == BaseModel.noneData) this.telephone = "";
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

  /// 将Map转化为普通的CardBean
  static CardBean fromJson(Map<String, dynamic> map, {EncryptLevel encryptLevel = EncryptLevel.OnlyPassword}) {
    assert(map["name"] != null);
    assert(map["ownerName"] != null);
    assert(map["cardId"] != null);
    assert(map["folder"] != null);
    assert(map["telephone"] != null);
    assert(map["fav"] != null);
    assert(map["password"] != null);
    assert(map['notes'] != null);
    switch (encryptLevel) {
      case EncryptLevel.None:
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
            password: EncryptUtil.encrypt(map['password']),
            label: newLabel,
            createTime: map['createTime'],
            sortNumber: map['sortNumber']);
      case EncryptLevel.All:
        List<String> newLabel = [];
        if (map['label'] != null) {
          for (String str in StringUtil.waveLineSegStr2List(map['label'])) {
            newLabel.add(EncryptUtil.decrypt(str));
          }
        }
        return CardBean(
            ownerName: EncryptUtil.decrypt(map['ownerName']),
            cardId: EncryptUtil.decrypt(map['cardId']),
            folder: EncryptUtil.decrypt(map["folder"]),
            notes: EncryptUtil.decrypt(map["notes"]),
            fav: map["fav"],
            key: map["uniqueKey"],
            name: EncryptUtil.decrypt(map["name"]),
            telephone: EncryptUtil.decrypt(map["telephone"]),
            password: map['password'],
            label: newLabel,
            createTime: EncryptUtil.decrypt(map['createTime']),
            sortNumber: map['sortNumber']);
      default:
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
            sortNumber: map['sortNumber']
        );
    }
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

  /// 将一个普通的CardBean转为加密的CardBean
  static CardBean fromBean(CardBean pureBean, {EncryptLevel encryptLevel = EncryptLevel.OnlyPassword}) {
    switch (encryptLevel) {
      case EncryptLevel.None:
        return CardBean(
            key: pureBean.uniqueKey,
            name: pureBean.name,
            ownerName: pureBean.ownerName,
            cardId: pureBean.cardId,
            password: pureBean.password,
            telephone: pureBean.telephone,
            folder: pureBean.folder,
            notes: pureBean.notes,
            label: List.from(pureBean.label ?? []),
            fav: pureBean.fav,
            createTime: pureBean.createTime,
            sortNumber: pureBean.sortNumber,
            color: pureBean.color);
      case EncryptLevel.All:
        String name = EncryptUtil.encrypt(pureBean.name);
        String ownerName = EncryptUtil.encrypt(pureBean.ownerName);
        String cardId = EncryptUtil.encrypt(pureBean.cardId);
        String telephone = EncryptUtil.encrypt(BaseModel.isNoneDataOrItSelf(pureBean.telephone));
        String folder = EncryptUtil.encrypt(pureBean.folder);
        String notes = EncryptUtil.encrypt(BaseModel.isNoneDataOrItSelf(pureBean.notes));
        String createTime = EncryptUtil.encrypt(pureBean.createTime);
        List<String> label = [];
        for (String l in pureBean.label ?? []) {
          label.add(EncryptUtil.encrypt(l));
        }
        return CardBean(
            key: pureBean.uniqueKey,
            name: name,
            ownerName: ownerName,
            cardId: cardId,
            password: pureBean.password,
            telephone: telephone,
            folder: folder,
            notes: notes,
            label: label,
            fav: pureBean.fav,
            createTime: createTime,
            sortNumber: pureBean.sortNumber,
            color: pureBean.color);
      default:
        String password = EncryptUtil.decrypt(pureBean.password);
        return CardBean(
            key: pureBean.uniqueKey,
            name: pureBean.name,
            ownerName: pureBean.ownerName,
            cardId: pureBean.cardId,
            password: password,
            telephone: pureBean.telephone,
            folder: pureBean.folder,
            notes: pureBean.notes,
            label: List.from(pureBean.label ?? []),
            fav: pureBean.fav,
            createTime: pureBean.createTime,
            sortNumber: pureBean.sortNumber,
            color: pureBean.color);
    }
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

}
