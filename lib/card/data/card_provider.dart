import 'package:allpass/common/arch/lru_cache.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:allpass/application.dart';
import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/card/data/card_dao.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';

final List<CardBean> emptyList = [];

/// 保存程序中所有的Card
class CardProvider with ChangeNotifier {

  List<CardBean> _cardList = emptyList;
  CardDao _dao = Application.getIt.get();
  CardBean _currCard = CardBean.empty;
  SimpleCountCache<String> _mostUsedCache = SimpleCountCache(maxSize: 3);
  List<String> _mostUsedOwnerName = [];

  bool _haveInit = false;

  List<CardBean> get cardList          => _cardList;
  int            get count             => _cardList.length;
  CardBean       get currCard          => _currCard;
  List<String>   get mostUsedOwnerName => _mostUsedOwnerName;

  Future<Null> init() async {
    if (_haveInit) return;
    _cardList = [];
    var res = await _dao.getAllCardBeanList();
    if (res.isNotEmpty) {
      _cardList.addAll(res);
    }
    _sortByAlphabeticalOrder();
    _refreshMostUsedOwnerName();
    notifyListeners();
    _haveInit = true;
  }

  Future<Null> refresh() async {
    if (!_haveInit) return;
    _cardList.clear();
    var res = await _dao.getAllCardBeanList();
    if (res.isNotEmpty) {
      _cardList.addAll(res);
    }
    _sortByAlphabeticalOrder();
    _refreshMostUsedOwnerName();
    RuntimeData.newPasswordOrCardCount = 0;
    notifyListeners();
  }

  void _sortByAlphabeticalOrder() {
    _cardList.sort((one, two) {
      return PinyinHelper.getShortPinyin(one.name).toLowerCase()
          .compareTo(PinyinHelper.getShortPinyin(two.name).toLowerCase());
    });
  }

  void _refreshMostUsedOwnerName() {
    _mostUsedCache.clear();
    _mostUsedOwnerName.clear();
    _cardList.forEach((element) {
      _mostUsedCache.put(element.ownerName);
    });
    _mostUsedOwnerName.addAll(_mostUsedCache.get());
  }

  Future<Null> insertCard(CardBean bean) async {
    int key = await _dao.insert(bean);
    bean.uniqueKey = key;
    bean.color = getRandomColor(seed: key);
    _cardList.add(bean);
    _sortByAlphabeticalOrder();
    _refreshMostUsedOwnerName();
    RuntimeData.newPasswordOrCardCount++;
    notifyListeners();
  }

  Future<Null> deleteCard(CardBean bean) async {
    _cardList.remove(bean);
    await _dao.deleteCardBeanById(bean.uniqueKey!);
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
    String oldOwner = _cardList[index].ownerName;
    _cardList[index] = bean;
    if (oldName[0] != bean.name[0]) {
      _sortByAlphabeticalOrder();
    }
    if (oldOwner != bean.ownerName) {
      _refreshMostUsedOwnerName();
    }
    await _dao.updateCardBeanById(bean);
    _currCard = bean;
    notifyListeners();
  }

  Future<Null> clear() async {
    _cardList.clear();
    _mostUsedCache.clear();
    _mostUsedOwnerName.clear();
    await _dao.deleteContent();
    notifyListeners();
  }

  void previewCard({int? index, CardBean? bean}) {
    if (index != null) {
      _currCard = _cardList[index];
    } else if (bean != null) {
      _currCard = bean;
    } else {
      _currCard = CardBean.empty;
    }
  }
}