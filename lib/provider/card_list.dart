import 'package:flutter/material.dart';

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

  init() async {
    _cardList = await _dao.getAllCardBeanList();
  }

  insertCard(CardBean bean) async {
    _cardList.add(bean);
    await _dao.insert(bean);
    notifyListeners();
  }

  deleteCard(CardBean bean) async {
    _cardList.remove(bean);
    await _dao.deleteCardBeanById(bean.uniqueKey);
    notifyListeners();
  }

  updateCard(CardBean bean) async {
    int index = -1;
    for (int i = 0; i < _cardList.length; i++) {
      if (_cardList[i].uniqueKey == bean.uniqueKey) {
        index = i;
        break;
      }
    }
    _cardList[index] = bean;
    await _dao.updatePasswordBean(bean);
    notifyListeners();
  }

  clear() async {
    _cardList?.clear();
    await _dao.deleteContent();
    notifyListeners();
  }
}