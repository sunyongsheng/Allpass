import 'package:flutter_test/flutter_test.dart';

import 'package:allpass/util/csv_util.dart';
import 'package:allpass/password/model/password_bean.dart';

void main() {
  test("CSV测试", () async {
    List<PasswordBean>? res = await CsvUtil.parsePasswordFromCsv(path: "D:/Chrome 密码.csv");
    print(res);
  });
}