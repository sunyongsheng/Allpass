import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/autofill/autofill_save_request.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/password/repository/password_data_source.dart';
import 'package:allpass/password/repository/password_local_data_source.dart';

class PasswordRepository {
  late final PasswordDataSource _dataSource;

  PasswordRepository({PasswordDataSource? dataSource}) {
    this._dataSource = dataSource ?? PasswordLocalDataSource();
  }

  Future<PasswordBean> create(PasswordBean passwordBean) async {
    int key = await _dataSource.insert(passwordBean);
    passwordBean.uniqueKey = key;
    _assignColor(passwordBean);
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
      folder: "默认",
      label: [],
    );
    var key = await _dataSource.insert(passwordBean);
    passwordBean.uniqueKey = key;
    _assignColor(passwordBean);
    return passwordBean;
  }

  Future<int> updateFromUser(AutofillSaveRequest request) async {
    return await _dataSource.updateUserData(request);
  }

  Future<List<PasswordBean>> requestAll() async {
    var result = await _dataSource.findAll();
    result.forEach((element) {
      _assignColor(element);
    });
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
      String appId, String username) async {
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
    return await _dataSource.updateById(bean);
  }

  Future<int> deleteById(int key) async {
    return await _dataSource.deleteById(key);
  }

  Future<int> deleteAll() async {
    return await _dataSource.deleteAll();
  }

  Future<void> dropTable() async {
    return await _dataSource.deleteTable();
  }

  void _assignColor(PasswordBean bean) {
    if (bean.color == null) {
      bean.color = getRandomColor(seed: bean.uniqueKey);
    }
  }
}
