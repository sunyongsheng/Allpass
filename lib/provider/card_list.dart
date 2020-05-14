import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:allpass/params/runtime_data.dart';
import 'package:allpass/dao/card_dao.dart';
import 'package:allpass/model/card_bean.dart';

/// 保存程序中所有的Card
class CardList with ChangeNotifier {
  List<CardBean> _cardList = [];
  int _count = 0;
  CardDao _dao = CardDao();

  List<CardBean> get cardList =>_cardList??[];
  int get count => _count;

  Future<Null> init() async {
    _cardList = await _dao.getAllCardBeanList()??[];
    _count = _cardList.length;
    sortByAlphabeticalOrder();
  }

  Future<Null> refresh() async {
    _cardList.clear();
    _cardList = await _dao.getAllCardBeanList();
    _count = _cardList.length;
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
    _cardList?.add(bean);
    _count++;
    sortByAlphabeticalOrder();
    RuntimeData.newPasswordOrCardCount++;
    notifyListeners();
  }

  Future<Null> deleteCard(CardBean bean) async {
    _cardList?.remove(bean);
    await _dao.deleteCardBeanById(bean.uniqueKey);
    _count--;
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
    await _dao.updatePasswordBean(bean);
    notifyListeners();
  }

  Future<Null> clear() async {
    _cardList?.clear();
    await _dao.deleteContent();
    _count = 0;
    notifyListeners();
  }
}