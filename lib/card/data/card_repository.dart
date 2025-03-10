import 'dart:async';

import 'package:allpass/card/data/card_data_source.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';

sealed class CardListAction {}

class CardActionRequestAll extends CardListAction {}
class CardActionCreate extends CardListAction {}
class CardActionUpdate extends CardListAction {
  final bool nameChanged;
  final bool ownerNameChanged;
  CardActionUpdate(this.nameChanged, this.ownerNameChanged);
}
class CardActionDelete extends CardListAction {}
class CardActionDeleteAll extends CardListAction {}

class CardListEvent {
  final List<CardBean> list;
  final CardListAction action;

  CardListEvent(this.list, this.action);
}

class CardRepository {
  late final CardDataSource _localDataSource;

  List<CardBean> _cardList = [];
  final StreamController<CardListEvent> _cardListStreamController = StreamController.broadcast();

  List<CardBean> get cardList => _cardList;
  Stream<CardListEvent> get cardStream => _cardListStreamController.stream;

  CardRepository({CardDataSource? cardDao}) {
    _localDataSource = cardDao ?? CardDataSource();
  }

  Future<CardBean> create(CardBean param) async {
    var key = await _localDataSource.insert(param);
    param.uniqueKey = key;
    _assignColor(param);
    _cardList.add(param);
    _emitEvent(CardActionCreate());
    return param;
  }

  Future<CardBean?> findById(String id) async {
    var result = await _localDataSource.findById(id);
    if (result != null) {
      _assignColor(result);
    }
    return result;
  }

  Future<List<CardBean>> findAll() async {
    var result = await _localDataSource.findAll();
    result.forEach((element) {
      _assignColor(element);
    });
    _cardList = result;
    _emitEvent(CardActionRequestAll());
    return result;
  }

  Future<int> deleteById(int key) async {
    _cardList.removeWhere((element) => element.uniqueKey == key);
    _emitEvent(CardActionDelete());
    return await _localDataSource.deleteById(key);
  }

  Future<int> deleteByIds(List<int> keys) async {
    _cardList.removeWhere((element) => keys.contains(element.uniqueKey));
    _emitEvent(CardActionDelete());
    return await _localDataSource.deleteByIds(keys);
  }

  Future<int> updateById(CardBean bean) async {
    var index = _cardList.indexWhere(
      (element) => element.uniqueKey == bean.uniqueKey,
    );
    if (index >= 0) {
      var card = _cardList[index];
      var namedChanged = card.name[0] != bean.name[0];
      var ownerNameChanged = card.ownerName != bean.ownerName;
      _cardList[index] = bean;
      _emitEvent(CardActionUpdate(namedChanged, ownerNameChanged));
    }
    return await _localDataSource.updateById(bean);
  }

  Future<int> deleteAll() async {
    _cardList.clear();
    _emitEvent(CardActionDeleteAll());
    return await _localDataSource.deleteAll();
  }

  Future<void> dropTable() async {
    _cardList.clear();
    _emitEvent(CardActionDeleteAll());
    await _localDataSource.deleteTable();
  }

  void _assignColor(CardBean bean) {
    if (bean.gradientColor == null) {
      var gradient = getNextGradient();
      bean.color = getCenterColor(gradient.colors);
      bean.gradientColor = gradient;
    }
  }

  void _emitEvent(CardListAction action) {
    _cardListStreamController.add(CardListEvent(_cardList, action));
  }
}
