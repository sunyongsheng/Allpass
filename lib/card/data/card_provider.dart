import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/card/data/card_dao.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';

final List<CardBean> emptyList = List();

/// 保存程序中所有的Card
class CardProvider with ChangeNotifier {

  List<CardBean> _cardList = emptyList;
  CardDao _dao = CardDao();
  CardBean _currCard = CardBean.empty;

  bool _haveInit = false;

  List<CardBean> get cardList => _cardList;
  int get count => _cardList.length;
  CardBean get currCard => _currCard;

  Future<Null> init() async {
    if (_haveInit) return;
    _cardList = List();
    var res = await _dao.getAllCardBeanList();
    if (res != null) {
      _cardList.addAll(res);
    }
    _sortByAlphabeticalOrder();
    notifyListeners();
    _haveInit = true;
  }

  Future<Null> refresh() async {
    if (!_haveInit) return;
    _cardList?.clear();
    var res = await _dao.getAllCardBeanList();
    if (res != null) {
      _cardList.addAll(res);
    }
    _sortByAlphabeticalOrder();
    RuntimeData.newPasswordOrCardCount = 0;
    notifyListeners();
  }

  void _sortByAlphabeticalOrder() {
    _cardList.sort((one, two) {
      return PinyinHelper.getShortPinyin(one.name).toLowerCase()
          .compareTo(PinyinHelper.getShortPinyin(two.name).toLowerCase());
    });
  }

  Future<Null> insertCard(CardBean bean) async {
    int key = await _dao.insert(bean);
    bean.uniqueKey = key;
    bean.color = getRandomColor(seed: key);
    _cardList.add(bean);
    _sortByAlphabeticalOrder();
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
      _sortByAlphabeticalOrder();
    }
    await _dao.updateCardBeanById(bean);
    _currCard = bean;
    notifyListeners();
  }

  Future<Null> clear() async {
    _cardList?.clear();
    await _dao.deleteContent();
    notifyListeners();
  }

  void previewCard({int index, CardBean bean}) {
    if (index != null) {
      _currCard = _cardList[index];
    } else if (bean != null) {
      _currCard = bean;
    } else {
      _currCard = CardBean.empty;
    }
  }
}