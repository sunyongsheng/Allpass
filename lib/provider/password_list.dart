import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:allpass/params/runtime_data.dart';
import 'package:allpass/dao/password_dao.dart';
import 'package:allpass/model/password_bean.dart';

/// 保存程序中的所有的Password
class PasswordList with ChangeNotifier {
  List<PasswordBean> _passwordList = [];
  PasswordDao _dao = PasswordDao();
  int _count = 0;

  List<PasswordBean> get passwordList => _passwordList??[];
  int get count => _count;

  Future<Null> init() async {
    _passwordList = await _dao.getAllPasswordBeanList()??[];
    _count = _passwordList.length;
    sortByAlphabeticalOrder();
    notifyListeners();
  }

  Future<Null> refresh() async {
    _passwordList.clear();
    _passwordList = await _dao.getAllPasswordBeanList();
    _count = _passwordList.length;
    sortByAlphabeticalOrder();
    RuntimeData.newPasswordOrCardCount = 0;
    notifyListeners();
  }

  void sortByAlphabeticalOrder() {
    _passwordList.sort((one, two) {
      return PinyinHelper.getShortPinyin(one.name, defPinyin: one.name).toLowerCase()
          .compareTo(PinyinHelper.getShortPinyin(two.name, defPinyin: two.name).toLowerCase());
    });
  }

  Future<Null> insertPassword(PasswordBean bean) async {
    _passwordList?.add(bean);
    await _dao.insert(bean);
    _count++;
    sortByAlphabeticalOrder();
    RuntimeData.newPasswordOrCardCount++;
    notifyListeners();
  }

  Future<Null> deletePassword(PasswordBean bean) async {
    _passwordList?.remove(bean);
    await _dao.deletePasswordBeanById(bean.uniqueKey);
    _count--;
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
    }
    await _dao.updatePasswordBean(bean);
    notifyListeners();
  }

  Future<Null> clear() async {
    _passwordList?.clear();
    await _dao.deleteContent();
    _count = 0;
    notifyListeners();
  }
}