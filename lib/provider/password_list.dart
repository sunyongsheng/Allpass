import 'package:flutter/material.dart';

import 'package:allpass/dao/password_dao.dart';
import 'package:allpass/model/password_bean.dart';

/// 保存程序中的所有的Password
class PasswordList with ChangeNotifier {
  List<PasswordBean> _passwordList = [];
  PasswordDao _dao = PasswordDao();

  List<PasswordBean> get passwordList => _passwordList??[];

  PasswordList() {
    init();
  }

  init() async {
    _passwordList = await _dao.getAllPasswordBeanList()??[];
  }

  insertPassword(PasswordBean bean) async {
    _passwordList?.add(bean);
    await _dao.insert(bean);
    notifyListeners();
  }

  deletePassword(PasswordBean bean) async {
    _passwordList?.remove(bean);
    await _dao.deletePasswordBeanById(bean.uniqueKey);
    notifyListeners();
  }

  updatePassword(PasswordBean bean) async {
    int index = -1;
    for (int i = 0; i < _passwordList.length; i++) {
      if (_passwordList[i].uniqueKey == bean.uniqueKey) {
        index = i;
        break;
      }
    }
    _passwordList[index] = bean;
    await _dao.updatePasswordBean(bean);
    notifyListeners();
  }

  clear() async {
    _passwordList?.clear();
    await _dao.deleteContent();
    notifyListeners();
  }
}