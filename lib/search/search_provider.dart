import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:allpass/core/enums/allpass_type.dart';
import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/util/string_util.dart';

class SearchProvider with ChangeNotifier {
  
  late List<PasswordBean> _passwordList;
  late List<CardBean> _cardList;
  
  late List<PasswordBean> passwordSearch;
  late List<CardBean> cardSearch;
  
  final AllpassType type;
  
  SearchProvider(this.type, BuildContext context) {
    if (type == AllpassType.password) {
      _passwordList = [];
      passwordSearch = [];
      _passwordList.addAll(context.read<PasswordProvider>().passwordList);
      passwordSearch.addAll(_passwordList);
    } else if (type == AllpassType.card) {
      _cardList = [];
      cardSearch = [];
      _cardList.addAll(context.read<CardProvider>().cardList);
      cardSearch.addAll(_cardList);
    }
  }
  
  void search(String regex) {
    if (type == AllpassType.password) {
      passwordSearch.clear();
      for (var bean in _passwordList) {
        if (_containsKeyword1(bean, regex)) {
          passwordSearch.add(bean);
        }
      }
    } else if (type == AllpassType.card) {
      cardSearch.clear();
      for (var bean in _cardList) {
        if (_containsKeyword2(bean, regex)) {
          cardSearch.add(bean);
        }
      }
    }
    notifyListeners();
  }

  bool empty() {
    if (type == AllpassType.password) {
      return passwordSearch.isEmpty;
    } else if (type == AllpassType.card) {
      return cardSearch.isEmpty;
    }
    return true;
  }

  int length() {
    if (type == AllpassType.password) {
      return passwordSearch.length;
    } else if (type == AllpassType.card) {
      return cardSearch.length;
    }
    return 0;
  }

  bool _containsKeyword1(PasswordBean passwordBean, String keyword) {
    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write(passwordBean.name.toLowerCase());
    stringBuffer.write(passwordBean.username.toLowerCase());
    stringBuffer.write(passwordBean.notes.toLowerCase());
    stringBuffer.write(StringUtil.list2PureStr(passwordBean.label).toLowerCase());
    return stringBuffer.toString().contains(keyword);
  }
  
  bool _containsKeyword2(CardBean cardBean, String keyword) {
    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write(cardBean.name.toLowerCase());
    stringBuffer.write(cardBean.ownerName.toLowerCase());
    stringBuffer.write(cardBean.notes.toLowerCase());
    stringBuffer.write(StringUtil.list2PureStr(cardBean.label).toLowerCase());
    return stringBuffer.toString().contains(keyword);
  }

}