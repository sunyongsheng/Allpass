import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/password/data/password_data_source.dart';
import 'package:allpass/autofill/autofill_save_request.dart';
import 'package:allpass/password/model/password_bean.dart';

class PasswordRepository {
  late final PasswordDataSource _localDataSource;

  PasswordRepository({PasswordDataSource? passwordDao}) {
    this._localDataSource = passwordDao ?? PasswordDataSource();
  }

  Future<PasswordBean> create(PasswordBean passwordBean) async {
    int key = await _localDataSource.insert(passwordBean);
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
    var key = await _localDataSource.insert(passwordBean);
    passwordBean.uniqueKey = key;
    _assignColor(passwordBean);
    return passwordBean;
  }

  Future<int> updateFromUser(AutofillSaveRequest request) async {
    return await _localDataSource.updateUserData(request);
  }

  Future<List<PasswordBean>> requestAll() async {
    var result = await _localDataSource.findAll();
    result.forEach((element) {
      _assignColor(element);
    });
    return result;
  }

  Future<PasswordBean?> findById(String id) async {
    var result = await _localDataSource.findById(id);
    if (result != null) {
      _assignColor(result);
    }
    return result;
  }

  Future<List<PasswordBean>> findByAppIdAndUsername(
      String appId, String username) async {
    var result = await _localDataSource.findByAppIdAndUsername(appId, username);
    result.forEach((element) {
      _assignColor(element);
    });
    return result;
  }

  Future<List<PasswordBean>> findByAppIdOrAppName(
    String appId,
    String? appName, {
    int page: 0,
    int pageSize: 10,
  }) async {
    var result = await _localDataSource.findByAppIdOrAppName(appId, appName,
        page: page, pageSize: pageSize);
    result.forEach((element) {
      _assignColor(element);
    });
    return result;
  }

  Future<int> updateById(PasswordBean bean) async {
    return await _localDataSource.updateById(bean);
  }

  Future<int> deleteById(int key) async {
    return await _localDataSource.deleteById(key);
  }

  Future<int> deleteAll() async {
    return await _localDataSource.deleteContent();
  }

  Future<void> dropTable() async {
    return await _localDataSource.deleteTable();
  }

  void _assignColor(PasswordBean bean) {
    if (bean.color == null) {
      bean.color = getRandomColor(seed: bean.uniqueKey);
    }
  }
}
