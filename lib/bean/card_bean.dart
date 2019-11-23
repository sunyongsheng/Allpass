import 'package:allpass/params/card_data.dart';

const int CARD_MAGIC = -12342; // 随便输的
const int MAX_INT = 2 ^ 53 - 1;

/// 保存“卡片”数据
class CardBean {
  int uniqueKey; // ID
  String name; // 卡片名称
  String ownerName; // 卡片拥有者
  String cardId; // 卡片ID/卡号
  String telephone; // 手机号
  String folder; // 文件夹
  String notes; // 备注
  List<String> label; // 标签
  int fav; // 是否标心

  CardBean(String ownerName, String cardId,
      {bool isNew: true,
      String folder: "默认",
      String notes: "",
      int fav: 0,
      String telephone: "",
      int key: CARD_MAGIC,
      String name,
      List<String> label}) {
    this.ownerName = ownerName;
    this.cardId = cardId;
    this.folder = folder;
    this.notes = notes;
    this.fav = fav;
    this.telephone = telephone;
    this.uniqueKey = key;

    if (uniqueKey == CARD_MAGIC) {
      this.uniqueKey = getUniqueCardKey(CardData.cardKeySet);
    } //uniqueKey

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

    if (isNew) {
      CardData.cardData.add(this);
      CardData.cardKeySet.add(this.uniqueKey);
    }
  }

  static int getUniqueCardKey(Set<int> list) {
    int key = MAX_INT;
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
    return "{key:" "$uniqueKey, " +
        "name:" "$name, " +
        "ownerName:" "$ownerName, " +
        "cardId:" "$cardId}";
  }
}
