import 'dart:async';

import 'package:allpass/card/data/card_repository.dart';
import 'package:allpass/core/di/di.dart';
import 'package:allpass/core/error/app_error.dart';
import 'package:allpass/password/repository/password_repository.dart';
import 'package:flutter/widgets.dart';

import 'package:allpass/core/enums/allpass_type.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/util/string_util.dart';

class SearchProvider with ChangeNotifier {
  
  late List<PasswordBean> _passwordList;
  late List<CardBean> _cardList;
  
  late List<PasswordBean> passwordSearch;
  late List<CardBean> cardSearch;

  bool Function(PasswordBean) _passwordFilter = (_) => true;
  bool Function(CardBean) _cardFilter = (_) => true;

  StreamSubscription<Object>? _streamSubscription;
  
  final AllpassType type;
  
  SearchProvider(this.type) {
    if (type == AllpassType.password) {
      var passwordRepository = inject<PasswordRepository>();
      _streamSubscription = passwordRepository.passwordStream.listen((event) {
        _passwordList = event.list;
        passwordSearch = event.list.takeWhile(_passwordFilter).toList();
        notifyListeners();
      });
      _passwordList = passwordRepository.passwordList;
      passwordSearch = passwordRepository.passwordList;
    } else if (type == AllpassType.card) {
      var cardRepository = inject<CardRepository>();
      _streamSubscription = cardRepository.cardStream.listen((event) {
        _cardList = event.list;
        cardSearch = event.list.takeWhile(_cardFilter).toList();
        notifyListeners();
      });
      _cardList = cardRepository.cardList;
      cardSearch = cardRepository.cardList;
    } else {
      throw UnsupportedArgumentException('Invalid type: $type');
    }
  }
  
  void search(String regex) {
    if (type == AllpassType.password) {
      _passwordFilter = (bean) => _containsKeyword1(bean, regex);
      passwordSearch = _passwordList.takeWhile(_passwordFilter).toList();
    } else if (type == AllpassType.card) {
      _cardFilter = (bean) => _containsKeyword2(bean, regex);
      cardSearch = _cardList.takeWhile(_cardFilter).toList();
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

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel();
  }

}