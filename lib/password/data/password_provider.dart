import 'package:allpass/common/arch/lru_cache.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/password/data/password_dao.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';

final List<PasswordBean> emptyList = List();

/// 保存程序中的所有的Password
class PasswordProvider with ChangeNotifier {
  List<PasswordBean> _passwordList = emptyList;
  PasswordDao _dao = PasswordDao();
  /// 按字母表顺序进行排序后，记录每个字母前面有多少元素的Map，符号或数字的key=#，value=0
  /// 例如{'#': 0, 'A': 5, 'C': 9} 代表第一个以数字或字母开头的元素索引为0，第一个为'A'
  /// 或'a'为首字母的元素索引为5，第一个以'C'或'c'为首字母的元素索引为9
  Map<String, int> _letterCountIndex = Map();
  PasswordBean _currPassword = PasswordBean.empty;
  SimpleCountCache<String> _mostUsedCache = SimpleCountCache(maxSize: 3);
  List<String> _mostUsedUsername = List();

  bool _haveInit = false;

  final List<String> letters = ['A','B','C','D','E','F','G','H','I','J','K','L',
    'M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];

  List<PasswordBean> get passwordList     => _passwordList;
  Map<String, int>   get letterCountIndex => _letterCountIndex;
  int                get count            => _passwordList.length;
  PasswordBean       get currPassword     => _currPassword;
  List<String>       get mostUsedUsername => _mostUsedUsername;

  Future<Null> init() async {
    if (_haveInit) return;
    _passwordList = List();
    var res = await _dao.getAllPasswordBeanList();
    if (res != null) {
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
    _passwordList?.clear();
    var res = await _dao.getAllPasswordBeanList();
    if (res != null) {
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
    _letterCountIndex.clear();
    _passwordList.forEach((bean) {
      String firstLetter = PinyinHelper.getFirstWordPinyin(bean.name).substring(0, 1).toUpperCase();
      if (letters.contains(firstLetter)) {
        if (!_letterCountIndex.containsKey(firstLetter)) {
          _letterCountIndex[firstLetter] = amount;
        }
      } else {
        _letterCountIndex['#'] = 0;
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
    int key = await _dao.insert(bean);
    bean.uniqueKey = key;
    bean.color = getRandomColor(seed: key);
    _passwordList.add(bean);
    _sortByAlphabeticalOrder();
    _refreshLetterCountIndex();
    _refreshMostUsedUsername();
    RuntimeData.newPasswordOrCardCount++;
    notifyListeners();
  }

  Future<Null> deletePassword(PasswordBean bean) async {
    _passwordList.remove(bean);
    await _dao.deletePasswordBeanById(bean.uniqueKey);
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
    _passwordList[index] = bean;
    if (oldName[0] != bean.name[0]) {
      _sortByAlphabeticalOrder();
      _refreshLetterCountIndex();
    }
    await _dao.updatePasswordBeanById(bean);
    _currPassword = bean;
    notifyListeners();
  }

  void previewPassword({int index, PasswordBean bean}) {
    if (index != null) {
      _currPassword = _passwordList[index];
    } else if (bean != null) {
      _currPassword = bean;
    } else {
      _currPassword = PasswordBean.empty;
    }
  }

  Future<Null> clear() async {
    _passwordList?.clear();
    _letterCountIndex.clear();
    _mostUsedUsername.clear();
    _mostUsedCache.clear();
    await _dao.deleteContent();
    notifyListeners();
  }
}