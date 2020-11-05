import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/card/data/card_dao.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/ui/allpass_ui.dart';

/// 保存程序中所有的Card
class CardProvider with ChangeNotifier {
  List<CardBean> _cardList = [];
  CardDao _dao = CardDao();

  List<CardBean> get cardList =>_cardList??[];

  Future<Null> init() async {
    _cardList = await _dao.getAllCardBeanList()??[];
    sortByAlphabeticalOrder();
  }

  Future<Null> refresh() async {
    _cardList.clear();
    _cardList = await _dao.getAllCardBeanList()??[];
    sortByAlphabeticalOrder();
    RuntimeData.newPasswordOrCardCount = 0;
    notifyListeners();
  }

  void sortByAlphabeticalOrder() {
    _cardList.sort((one, two) {
      return PinyinHelper.getShortPinyin(one.name, defPinyin: one.name).toLowerCase()
          .compareTo(PinyinHelper.getShortPinyin(two.name, defPinyin: two.name).toLowerCase());
    });
  }

  Future<Null> insertCard(CardBean bean) async {
    int key = await _dao.insert(bean);
    bean.uniqueKey = key;
    bean.color = getRandomColor(seed: key);
    _cardList.add(bean);
    sortByAlphabeticalOrder();
    RuntimeData.newPasswordOrCardCount++;
    notifyListeners();
  }

  Future<Null> deleteCard(CardBean bean) async {
    _cardList?.remove(bean);
    await _dao.deleteCardBeanById(bean.uniqueKey);
    notifyListeners();
  }

  Future<Null> updateCard(CardBean bean) async {
    int index = -1;
    for (int i = 0; i < _cardList.length; i++) {
      if (_cardList[i].uniqueKey == bean.uniqueKey) {
        index = i;
        break;
      }
    }
    String oldName = _cardList[index].name;
    _cardList[index] = bean;
    if (oldName[0] != bean.name[0]) {
      sortByAlphabeticalOrder();
    }
    await _dao.updateCardBeanById(bean);
    notifyListeners();
  }

  Future<Null> clear() async {
    _cardList?.clear();
    await _dao.deleteContent();
    notifyListeners();
  }
}