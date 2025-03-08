import 'dart:async';

import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/autofill/autofill_save_request.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/password/repository/password_data_source.dart';
import 'package:allpass/password/repository/password_local_data_source.dart';

sealed class PasswordListAction {}

class PasswordActionRequestAll extends PasswordListAction {}

class PasswordActionCreate extends PasswordListAction {}

class PasswordActionUpdate extends PasswordListAction {
  final bool nameChanged;
  final bool usernameChanged;
  PasswordActionUpdate(this.nameChanged, this.usernameChanged);
}

class PasswordActionDelete extends PasswordListAction {}

class PasswordActionDeleteAll extends PasswordListAction {}

class PasswordListEvent {
  final List<PasswordBean> list;
  final PasswordListAction action;

  PasswordListEvent(this.list, this.action);
}

class PasswordRepository {
  late final PasswordDataSource _dataSource;

  List<PasswordBean> _passwordList = [];
  final StreamController<PasswordListEvent> _passwordListStreamController = StreamController.broadcast();

  List<PasswordBean> get passwordList => _passwordList;
  Stream<PasswordListEvent> get passwordStream => _passwordListStreamController.stream;

  PasswordRepository({PasswordDataSource? dataSource}) {
    this._dataSource = dataSource ?? PasswordLocalDataSource();
  }

  Future<PasswordBean> create(PasswordBean passwordBean) async {
    int key = await _dataSource.insert(passwordBean);
    passwordBean.uniqueKey = key;
    _assignColor(passwordBean);
    _passwordList.add(passwordBean);
    _emitEvent(PasswordActionCreate());
    return passwordBean;
  }

  Future<PasswordBean> createFromUser(AutofillSaveRequest request) async {
    PasswordBean passwordBean = PasswordBean(
      name: request.name ?? request.username,
      username: request.username,
      password: request.password,
      appName: request.appName,
      appId: request.appId,
      url: "",
      createTime: DateTime.now().toIso8601String(),
      notes: "",
      folder: "",
      label: [],
    );
    var key = await _dataSource.insert(passwordBean);
    passwordBean.uniqueKey = key;
    _assignColor(passwordBean);
    _passwordList.add(passwordBean);
    _emitEvent(PasswordActionCreate());
    return passwordBean;
  }

  Future<int> updateFromUser(AutofillSaveRequest request) async {
    var index = _passwordList.indexWhere(
      (element) =>
          element.username == request.username &&
          element.appId == request.appId,
    );
    if (index >= 0) {
      var password = _passwordList[index];
      var newName = request.name ?? request.username;
      var nameChanged = password.name[0] != newName[0];
      password.name = newName;
      password.password = request.password;
      password.appName = request.appName;
      _passwordList[index] = password;
      _emitEvent(PasswordActionUpdate(nameChanged, false));
    }
    return await _dataSource.updateUserData(request);
  }

  Future<List<PasswordBean>> findAll() async {
    var result = await _dataSource.findAll();
    result.forEach((element) {
      _assignColor(element);
    });
    _passwordList = result;
    _emitEvent(PasswordActionRequestAll());
    return result;
  }

  Future<PasswordBean?> findById(int id) async {
    var result = await _dataSource.findById(id);
    if (result != null) {
      _assignColor(result);
    }
    return result;
  }

  Future<List<PasswordBean>> findByAppIdAndUsername(
    String appId,
    String username,
  ) async {
    var result = await _dataSource.findByAppIdAndUsername(appId, username);
    result.forEach((element) {
      _assignColor(element);
    });
    return result;
  }

  Future<List<PasswordBean>> findByAppIdOrAppName(
    String appId,
    String? appName, {
    int page = 0,
    int pageSize = 10,
  }) async {
    var result = await _dataSource.findByAppIdOrAppName(
      appId,
      appName,
      page: page,
      pageSize: pageSize,
    );
    result.forEach((element) {
      _assignColor(element);
    });
    return result;
  }

  Future<int> updateById(PasswordBean bean) async {
    var index = _passwordList.indexWhere(
      (element) => element.uniqueKey == bean.uniqueKey,
    );
    if (index >= 0) {
      var password = _passwordList[index];
      var nameChanged = password.name[0] != bean.name[0];
      var usernameChanged = password.username != bean.username;
      _passwordList[index] = bean;
      _emitEvent(PasswordActionUpdate(nameChanged, usernameChanged));
    }
    return await _dataSource.updateById(bean);
  }

  Future<int> deleteById(int key) async {
    _passwordList.removeWhere((element) => element.uniqueKey == key);
    _emitEvent(PasswordActionDelete());
    return await _dataSource.deleteById(key);
  }

  Future<int> deleteByIds(List<int> keys) async {
    _passwordList.removeWhere((element) => keys.contains(element.uniqueKey));
    _emitEvent(PasswordActionDelete());
    return await _dataSource.deleteByIds(keys);
  }

  Future<int> deleteAll() async {
    _passwordList.clear();
    _emitEvent(PasswordActionDeleteAll());
    return await _dataSource.deleteAll();
  }

  Future<void> dropTable() async {
    _passwordList.clear();
    _emitEvent(PasswordActionDeleteAll());
    return await _dataSource.deleteTable();
  }

  void _emitEvent(PasswordListAction action) {
    _passwordListStreamController.add(PasswordListEvent(_passwordList, action));
  }

  void _assignColor(PasswordBean bean) {
    if (bean.color == null) {
      bean.color = getRandomColor(seed: bean.uniqueKey);
    }
  }
}
