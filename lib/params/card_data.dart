import 'package:allpass/bean/card_bean.dart';

/// 用于存储所有“卡片”数据
/// @author Aengus Sun
class CardData {
  // 保存所有卡片数据
  static List<CardBean> cardData = List();
  // 保存卡片唯一Key
  static Set<int> cardKeySet = Set();

}

/// 更新特定key的CardBean
void updateCardBean(CardBean res, int currKey) {
  int index = -1;
  for (int i = 0; i < CardData.cardData.length; i++) {
    if (currKey == CardData.cardData[i].uniqueKey) {
      index = i;
      break;
    }
  }
  copyCardBean(CardData.cardData[index], res);
}