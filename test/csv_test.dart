import 'package:flutter_test/flutter_test.dart';

import 'package:allpass/utils/csv_util.dart';
import 'package:allpass/model/password_bean.dart';

void main() {
  test("CSV测试", () async {
    CsvUtil helper = CsvUtil();
    List<PasswordBean> res = await helper.passwordImportFromCsv(path: "D:/Chrome 密码.csv");
    print(res);
  });
}