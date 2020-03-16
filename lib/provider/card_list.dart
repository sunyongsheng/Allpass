import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';

import 'package:allpass/dao/card_dao.dart';
import 'package:allpass/model/card_bean.dart';

/// 保存程序中所有的Card
class CardList with ChangeNotifier {
  List<CardBean> _cardList = [];

  CardDao _dao = CardDao();

  List<CardBean> get cardList =>_cardList??[];

  CardList() {
    init();
  }

  Future<Null> init() async {
    _cardList = await _dao.getAllCardBeanList()??[];
    sortByAlphabeticalOrder();
  }

  void sortByAlphabeticalOrder() {
    _cardList.sort((one, two) {
      return PinyinHelper.getShortPinyin(one.name, defPinyin: one.name).toLowerCase()
          .compareTo(PinyinHelper.getShortPinyin(two.name, defPinyin: two.name).toLowerCase());
    });
  }

  void insertCard(CardBean bean) async {
    _cardList?.add(bean);
    await _dao.insert(bean);
    sortByAlphabeticalOrder();
    notifyListeners();
  }

  void deleteCard(CardBean bean) async {
    _cardList?.remove(bean);
    await _dao.deleteCardBeanById(bean.uniqueKey);
    notifyListeners();
  }

  void updateCard(CardBean bean) async {
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
    await _dao.updatePasswordBean(bean);
    notifyListeners();
  }

  void clear() async {
    _cardList?.clear();
    await _dao.deleteContent();
    notifyListeners();
  }
}