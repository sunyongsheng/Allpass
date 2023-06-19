import 'dart:async';

import 'package:allpass/autofill/autofill_save_request.dart';
import 'package:allpass/password/model/password_bean.dart';

abstract interface class PasswordDataSource {

  FutureOr<PasswordBean?> findById(int id);

  FutureOr<List<PasswordBean>> findAll();

  FutureOr<List<PasswordBean>> findByAppIdAndUsername(
    String appId,
    String username,
  );

  FutureOr<List<PasswordBean>> findByAppIdOrAppName(
    String appId,
    String? appName, {
    int page = 0,
    int pageSize = 10,
  });

  FutureOr<int> insert(PasswordBean bean);

  FutureOr<int> updateUserData(AutofillSaveRequest request);

  FutureOr<int> updateById(PasswordBean bean);

  FutureOr<int> deleteById(int key);

  FutureOr<int> deleteAll();

  FutureOr<void> deleteTable();

}
