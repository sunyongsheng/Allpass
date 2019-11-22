import 'package:allpass/params/card_data.dart';

/// “卡片”基类
class CardBase {
  int key; // ID
  String name; // 卡片名称
  String ownerName; // 卡片拥有者
  String cardId; // 卡片ID/卡号
  String telephone; // 手机号
  String folder; // 文件夹
  String notes; // 备注
  List<String> label = List(); // 标签
  int fav; // 是否标心
}

/// 保存“卡片”数据
class CardBean extends CardBase {
  final int uniqueKey = getUniqueCardKey(CardData.cardKeySet); // ID

  CardBean(String ownerName, String cardId,
      {String folder: "默认",
      String notes: "",
      int fav: 0,
      String telephone: "",
      String name,
      List<String> label}) {
    this.key = uniqueKey;
    this.ownerName = ownerName;
    this.cardId = cardId;
    this.folder = folder;
    this.notes = notes;
    this.fav = fav;
    this.telephone = telephone;

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

    CardData.cardData.add(this);
    CardData.cardKeySet.add(this.uniqueKey);
  }

  static int getUniqueCardKey(Set<int> list) {
    // TODO 找到int的最大值
    int key = 100000000;
    while (true) {
      if (list.contains(key))
        --key;
      else
        break;
    }
    return key;
  }

  @override
  String toString() {
    return "{key:" "$key, " +
        "name:" "$name, " +
        "ownerName:" "$ownerName, " +
        "cardId:" "$cardId}";
  }
}

/// 暂存修改页面的“卡片”数据
/// 相比CardBean的不同之处在于uniqueKey的初始化在构造函数中
class CardTempBean extends CardBase {
  final int uniqueKey;

  CardTempBean(this.uniqueKey, String ownerName, String cardId,
      {String folder: "默认",
      String notes: "",
      int fav: 0,
      String telephone: "",
      String name,
      List<String> label}) {
    this.key = uniqueKey;
    this.ownerName = ownerName;
    this.cardId = cardId;
    this.folder = folder;
    this.notes = notes;
    this.fav = fav;
    this.telephone = telephone;

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
    return "{key:" "$key, " +
        "name:" "$name, " +
        "ownerName:" "$ownerName, " +
        "cardId:" "$cardId}";
  }
}
