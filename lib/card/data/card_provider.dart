import 'dart:async';

import 'package:allpass/card/data/card_repository.dart';
import 'package:allpass/common/arch/lru_cache.dart';
import 'package:allpass/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:allpass/card/model/card_bean.dart';

/// 保存程序中所有的Card
class CardProvider with ChangeNotifier {

  CardRepository _repository = inject();
  StreamSubscription<CardListEvent>? _streamSubscription;

  List<CardBean> _cardList = [];
  CardBean _currCard = CardBean.empty;
  List<String> _mostUsedOwnerName = [];

  bool _haveInit = false;

  List<CardBean> get cardList          => _cardList;
  int            get count             => _cardList.length;
  CardBean       get currCard          => _currCard;
  List<String>   get mostUsedOwnerName => _mostUsedOwnerName;

  CardProvider() {
    _streamSubscription = _repository.cardStream.listen((event) {
      _cardList = event.list;
      switch (event.action) {
        case CardActionRequestAll():
        case CardActionCreate():
          _sortByAlphabeticalOrder(event.list);
          _refreshMostUsedOwnerName(event.list);
          break;

        case CardActionUpdate(nameChanged: var nameChanged, ownerNameChanged: var ownerNameChanged):
          if (nameChanged) _sortByAlphabeticalOrder(event.list);
          if (ownerNameChanged) _refreshMostUsedOwnerName(event.list);
          break;

        case CardActionDelete():
          _refreshMostUsedOwnerName(event.list);
          break;

        case CardActionDeleteAll():
          _mostUsedOwnerName.clear();
          break;
      }
      notifyListeners();
    });
  }

  void _sortByAlphabeticalOrder(List<CardBean> list) {
    list.sort((one, two) {
      return PinyinHelper.getShortPinyin(one.name).toLowerCase()
          .compareTo(PinyinHelper.getShortPinyin(two.name).toLowerCase());
    });
  }

  void _refreshMostUsedOwnerName(List<CardBean> list) {
    SimpleCountCache<String> mostUsedCache = SimpleCountCache(maxSize: 3);
    list.forEach((element) {
      mostUsedCache.put(element.ownerName);
    });
    _mostUsedOwnerName.clear();
    _mostUsedOwnerName.addAll(mostUsedCache.get());
  }

  Future<Null> init() async {
    if (_haveInit) return;
    await _repository.findAll();
    _haveInit = true;
  }

  Future<Null> refresh() async {
    if (!_haveInit) return;
    await _repository.findAll();
  }

  Future<Null> insertCard(CardBean bean) async {
    await _repository.create(bean);
  }

  Future<Null> deleteCard(CardBean bean) async {
    _currCard = CardBean.empty;
    await _repository.deleteById(bean.uniqueKey!);
  }

  Future<Null> updateCard(CardBean bean) async {
    _currCard = bean;
    await _repository.updateById(bean);
  }

  Future<Null> clear() async {
    await _repository.deleteAll();
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

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel();
  }
}