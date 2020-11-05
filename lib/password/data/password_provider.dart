import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/password/data/password_dao.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';


/// 保存程序中的所有的Password
class PasswordProvider with ChangeNotifier {
  List<PasswordBean> _passwordList = [];
  PasswordDao _dao = PasswordDao();
  /// 按字母表顺序进行排序后，记录每个字母前面有多少元素的Map，符号或数字的key=#，value=0
  /// 例如{'#': 0, 'A': 5, 'C': 9} 代表第一个以数字或字母开头的元素索引为0，第一个为'A'
  /// 或'a'为首字母的元素索引为5，第一个以'C'或'c'为首字母的元素索引为9
  Map<String, int> _letterCountIndex = Map();

  final List<String> letters = ['A','B','C','D','E','F','G','H','I','J','K','L',
    'M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];

  List<PasswordBean> get passwordList => _passwordList??[];
  Map<String, int> get letterCountIndex => _letterCountIndex;

  Future<Null> init() async {
    _passwordList = await _dao.getAllPasswordBeanList()??[];
    sortByAlphabeticalOrder();
    refreshLetterCountIndex();
    notifyListeners();
  }

  Future<Null> refresh() async {
    _passwordList?.clear();
    _passwordList = await _dao.getAllPasswordBeanList()??[];
    sortByAlphabeticalOrder();
    refreshLetterCountIndex();
    RuntimeData.newPasswordOrCardCount = 0;
    notifyListeners();
  }

  /// 刷新首字母索引，基于[_passwordList]已按首字母排好序的情况下
  void refreshLetterCountIndex() {
    int amount = 0;
    _letterCountIndex.clear();
    for (PasswordBean bean in _passwordList) {
      String firstLetter = PinyinHelper.getFirstWordPinyin(bean.name).substring(0, 1).toUpperCase();
      if (letters.contains(firstLetter)) {
        if (!_letterCountIndex.containsKey(firstLetter)) {
          _letterCountIndex[firstLetter] = amount;
        }
      } else {
        _letterCountIndex['#'] = 0;
      }
      amount++;
    }
  }

  void sortByAlphabeticalOrder() {
    _passwordList.sort((one, two) {
      return PinyinHelper.getShortPinyin(one.name, defPinyin: one.name).toLowerCase()
          .compareTo(PinyinHelper.getShortPinyin(two.name, defPinyin: two.name).toLowerCase());
    });
  }

  Future<Null> insertPassword(PasswordBean bean) async {
    int key = await _dao.insert(bean);
    bean.uniqueKey = key;
    bean.color = getRandomColor(seed: key);
    _passwordList.add(bean);
    sortByAlphabeticalOrder();
    refreshLetterCountIndex();
    RuntimeData.newPasswordOrCardCount++;
    notifyListeners();
  }

  Future<Null> deletePassword(PasswordBean bean) async {
    _passwordList.remove(bean);
    await _dao.deletePasswordBeanById(bean.uniqueKey);
    refreshLetterCountIndex();
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
      sortByAlphabeticalOrder();
      refreshLetterCountIndex();
    }
    await _dao.updatePasswordBeanById(bean);
    notifyListeners();
  }

  Future<Null> clear() async {
    _passwordList?.clear();
    _letterCountIndex.clear();
    await _dao.deleteContent();
    notifyListeners();
  }
}