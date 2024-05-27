import 'dart:async';

import 'package:allpass/common/arch/lru_cache.dart';
import 'package:allpass/core/di/di.dart';
import 'package:allpass/password/data/letter_index_provider.dart';
import 'package:allpass/password/repository/password_repository.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:allpass/password/model/password_bean.dart';

/// 保存程序中的所有的Password
class PasswordProvider with ChangeNotifier implements LetterIndexProvider {

  late final PasswordRepository _repository;
  StreamSubscription<PasswordListEvent>? _streamSubscription;

  List<PasswordBean> _passwordList = [];
  Map<String, int> _letterCountIndexMap = Map();
  PasswordBean _currPassword = PasswordBean.empty;
  List<String> _mostUsedUsername = [];

  bool _haveInit = false;

  PasswordProvider({PasswordRepository? passwordRepository}) {
    _repository = passwordRepository ?? inject();

    _streamSubscription = _repository.passwordStream.listen((event) {
      _passwordList = event.list;
      switch (event.action) {
        case PasswordActionRequestAll():
        case PasswordActionCreate():
          _sortByAlphabeticalOrder(event.list);
          _refreshLetterCountIndex(event.list);
          _refreshMostUsedUsername(event.list);
          break;

        case PasswordActionUpdate(nameChanged: var nameChanged, usernameChanged: var usernameChanged):
          if (nameChanged) _sortByAlphabeticalOrder(event.list);
          if (usernameChanged) _refreshMostUsedUsername(event.list);
          break;

        case PasswordActionDelete():
          _refreshLetterCountIndex(event.list);
          _refreshMostUsedUsername(event.list);
          break;

        case PasswordActionDeleteAll():
          _letterCountIndexMap.clear();
          _mostUsedUsername.clear();
          break;
      }
      notifyListeners();
    });
  }

  @override
  Map<String, int> get letterIndexMap => _letterCountIndexMap;

  List<PasswordBean> get passwordList => _passwordList;

  int get count => _passwordList.length;

  PasswordBean get currPassword => _currPassword;

  List<String> get mostUsedUsername => _mostUsedUsername;

  /// 刷新首字母索引，基于[_passwordList]已按首字母排好序的情况下
  void _refreshLetterCountIndex(List<PasswordBean> list) {
    int amount = 0;
    _letterCountIndexMap.clear();
    list.forEach((bean) {
      String firstLetter = PinyinHelper.getFirstWordPinyin(bean.name).substring(0, 1).toUpperCase();
      if (lettersWithoutHash.contains(firstLetter)) {
        if (!_letterCountIndexMap.containsKey(firstLetter)) {
          _letterCountIndexMap[firstLetter] = amount;
        }
      } else {
        _letterCountIndexMap['#'] = 0;
      }
      amount++;
    });
  }

  void _sortByAlphabeticalOrder(List<PasswordBean> list) {
    list.sort((one, two) {
      return PinyinHelper.getShortPinyin(one.name).toLowerCase()
          .compareTo(PinyinHelper.getShortPinyin(two.name).toLowerCase());
    });
  }

  void _refreshMostUsedUsername(List<PasswordBean> list) {
    SimpleCountCache<String> mostUsedCache = SimpleCountCache(maxSize: 5);
    list.forEach((element) {
      mostUsedCache.put(element.username);
    });
    _mostUsedUsername.clear();
    _mostUsedUsername.addAll(mostUsedCache.get());
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

  Future<Null> insertPassword(PasswordBean bean) async {
    await _repository.create(bean);
  }

  Future<Null> deletePassword(PasswordBean bean) async {
    _currPassword = PasswordBean.empty;
    await _repository.deleteById(bean.uniqueKey!);
  }

  Future<Null> updatePassword(PasswordBean bean) async {
    _currPassword = bean;
    await _repository.updateById(bean);
  }

  void previewPassword({int? index, PasswordBean? bean}) {
    if (index != null) {
      _currPassword = _passwordList[index];
    } else if (bean != null) {
      _currPassword = bean;
    } else {
      _currPassword = PasswordBean.empty;
    }
  }

  Future<Null> clear() async {
    await _repository.deleteAll();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel();
  }
}