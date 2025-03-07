import 'package:allpass/autofill/autofill_save_request.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/password/repository/password_data_source.dart';

class PasswordMemoryDataSource implements PasswordDataSource {
  var _list = <PasswordBean>[];

  Future<void>? _dataFuture;

  PasswordMemoryDataSource({Future<List<PasswordBean>> Function()? dataProvider}) {
    _dataFuture = dataProvider?.call().then((value) {
      _dataFuture = null;
      _list.addAll(value);
    });
  }

  @override
  int deleteAll() {
    var count = _list.length;
    _list.clear();
    return count;
  }

  @override
  int deleteById(int key) {
    var count = _list.length;
    _list.removeWhere((element) => element.uniqueKey == key);
    return count - _list.length;
  }

  @override
  int deleteByIds(List<int> keys) {
    var count = _list.length;
    _list.removeWhere((element) => keys.contains(element.uniqueKey));
    return count - _list.length;
  }

  @override
  void deleteTable() {}

  @override
  Future<List<PasswordBean>> findAll() async {
    if (_dataFuture != null) {
      await _dataFuture!;
    }
    return _list;
  }

  @override
  List<PasswordBean> findByAppIdAndUsername(
    String appId,
    String username,
  ) {
    var result = <PasswordBean>[];
    _list.forEach((element) {
      if (element.appId?.contains(appId) == true &&
          element.username == username) {
        result.add(element);
      }
    });
    return result;
  }

  @override
  List<PasswordBean> findByAppIdOrAppName(
    String appId,
    String? appName, {
    int page = 0,
    int pageSize = 10,
  }) {
    var result = <PasswordBean>[];
    var startIndex = page * pageSize;
    var endIndex = startIndex + pageSize;
    var validIndex = 0;
    for (var password in _list) {
      var valid = false;
      if (appName != null) {
        if (password.appId?.contains(appId) == true ||
            password.appName?.contains(appName) == true ||
            password.name.contains(appName)) {
          valid = true;
          validIndex++;
        }
      } else {
        if (password.appId?.contains(appId) == true) {
          valid = true;
          validIndex++;
        }
      }
      if (valid && validIndex >= startIndex && validIndex < endIndex) {
        result.add(password);
      }
      if (result.length == pageSize) {
        break;
      }
    }
    return result;
  }

  @override
  PasswordBean? findById(int id) {
    for (PasswordBean bean in _list) {
      if (bean.uniqueKey == id) {
        return bean;
      }
    }
    return null;
  }

  @override
  int insert(PasswordBean bean) {
    var key = _list.length;
    if (bean.uniqueKey == null) {
      bean.uniqueKey = key;
    }
    _list.add(bean);
    return key;
  }

  @override
  int updateById(PasswordBean bean) {
    var index =
        _list.indexWhere((element) => element.uniqueKey == bean.uniqueKey);
    if (index >= 0) {
      _list[index] = bean;
      return 1;
    }
    return 0;
  }

  @override
  int updateUserData(AutofillSaveRequest request) {
    return -1;
  }
}
