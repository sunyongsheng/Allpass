import 'package:flutter_test/flutter_test.dart';

import 'package:allpass/utils/csv_helper.dart';
import 'package:allpass/model/password_bean.dart';

void main() {
  test("CSV测试", () async {
    CsvHelper helper = CsvHelper();
    List<PasswordBean> res = await helper.passwordImportFromCsv("D:/password.csv");
    print(res);
  });
}