import 'package:allpass/common/arch/lru_cache.dart';
import 'package:allpass/core/di/di.dart';
import 'package:allpass/password/data/letter_index_provider.dart';
import 'package:allpass/password/data/password_repository.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/password/model/password_bean.dart';

final List<PasswordBean> emptyList = [];

/// 保存程序中的所有的Password
class PasswordProvider extends LetterIndexProvider with ChangeNotifier {
  PasswordRepository _repository = inject();

  List<PasswordBean> _passwordList = emptyList;
  Map<String, int> _letterCountIndexMap = Map();
  PasswordBean _currPassword = PasswordBean.empty;
  SimpleCountCache<String> _mostUsedCache = SimpleCountCache(maxSize: 5);
  List<String> _mostUsedUsername = [];

  bool _haveInit = false;

  @override
  Map<String, int> get letterIndexMap => _letterCountIndexMap;

  List<PasswordBean> get passwordList => _passwordList;

  int get count => _passwordList.length;

  PasswordBean get currPassword => _currPassword;

  List<String> get mostUsedUsername => _mostUsedUsername;

  Future<Null> init() async {
    if (_haveInit) return;
    _passwordList = [];
    var res = await _repository.requestAll();
    if (res.isNotEmpty) {
      _passwordList.addAll(res);
    }
    _sortByAlphabeticalOrder();
    _refreshLetterCountIndex();
    _refreshMostUsedUsername();
    notifyListeners();
    _haveInit = true;
  }

  Future<Null> refresh() async {
    if (!_haveInit) return;
    _passwordList.clear();
    var res = await _repository.requestAll();
    if (res.isNotEmpty) {
      _passwordList.addAll(res);
    }
    _sortByAlphabeticalOrder();
    _refreshLetterCountIndex();
    _refreshMostUsedUsername();
    RuntimeData.newPasswordOrCardCount = 0;
    notifyListeners();
  }

  /// 刷新首字母索引，基于[_passwordList]已按首字母排好序的情况下
  void _refreshLetterCountIndex() {
    int amount = 0;
    _letterCountIndexMap.clear();
    _passwordList.forEach((bean) {
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

  void _sortByAlphabeticalOrder() {
    _passwordList.sort((one, two) {
      return PinyinHelper.getShortPinyin(one.name).toLowerCase()
          .compareTo(PinyinHelper.getShortPinyin(two.name).toLowerCase());
    });
  }

  void _refreshMostUsedUsername() {
    _mostUsedUsername.clear();
    _mostUsedCache.clear();
    _passwordList.forEach((element) {
      _mostUsedCache.put(element.username);
    });
    _mostUsedUsername.addAll(_mostUsedCache.get());
  }

  Future<Null> insertPassword(PasswordBean bean) async {
    var result = await _repository.create(bean);
    _passwordList.add(result);
    _sortByAlphabeticalOrder();
    _refreshLetterCountIndex();
    _refreshMostUsedUsername();
    RuntimeData.newPasswordOrCardCount++;
    notifyListeners();
  }

  Future<Null> deletePassword(PasswordBean bean) async {
    _passwordList.remove(bean);
    await _repository.deleteById(bean.uniqueKey!);
    _refreshLetterCountIndex();
    _refreshMostUsedUsername();
    notifyListeners();
  }

  Future<Null> updatePassword(PasswordBean bean) async {
    int index = -1;
    for (int i = 0; i < _passwordList.length; i++) {
      if (_passwordList[i].uniqueKey == bean.uniqueKey) {
        index = i;
        break;
      }
    }
    String oldName = _passwordList[index].name;
    String oldUsername = _passwordList[index].username;
    _passwordList[index] = bean;
    if (oldName[0] != bean.name[0]) {
      _sortByAlphabeticalOrder();
    }
    if (oldUsername != bean.username) {
      _refreshMostUsedUsername();
    }
    await _repository.updateById(bean);
    _currPassword = bean;
    notifyListeners();
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
    _passwordList.clear();
    _letterCountIndexMap.clear();
    _mostUsedUsername.clear();
    _mostUsedCache.clear();
    await _repository.deleteAll();
    notifyListeners();
  }
}