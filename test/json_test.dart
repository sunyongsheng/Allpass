import 'dart:convert';

import 'package:allpass/core/enums/allpass_type.dart';
import 'package:allpass/webdav/encrypt/encrypt_level.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/webdav/encrypt/password_extension.dart';
import 'package:allpass/webdav/model/backup_file.dart';
import 'package:allpass/webdav/model/file_metadata.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  List<PasswordBean> testData1 = [
    PasswordBean(
      key: 1,
      username: "test",
      password: "121321321",
      url: "https://www.aengus.top",
      folder: "默认",
      name: "test1",
      fav: 1,
      notes: "hhhhhh",
      label: ["aaa", "bbb"],
    ),
    PasswordBean(
      key: 2,
      username: "testtest",
      password: "121321321",
      url: "https://www.aengus.top",
      folder: "默认",
      name: "test1",
      fav: 1,
      notes: "hhhhhh",
      label: [],
    )
  ];

  test("新备份数据结构测试", () {
    var encryptLevel = EncryptLevel.OnlyPassword;
    BackupFileV2 file = BackupFileV2(
      metadata: FileMetadata(
        type: AllpassType.password,
        appVersion: "2.0.0",
        encryptLevel: encryptLevel,
      ),
      data: jsonEncode(testData1.encrypt(encryptLevel)),
    );
    var fileContent = jsonEncode(file);

    BackupFileV2 recoveryFile = BackupFileV2.fromJson(json.decode(fileContent));
    assert(file.data == recoveryFile.data);
  });
}
