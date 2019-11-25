import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// 存储系统参数
class Params {

  Params._();

  static String appPath;

  static Set<String> folderList = Set.of(<String>['默认', '论坛', '社交', '游戏', '其他']);
  static Set<String> labelList = Set.of(<String>["默认", "论坛", "学习", "娱乐", "游戏", "社交"]);

  paramsInit() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appPath = appDocDir.path;

    final folderFile = File("$appPath/folder.appt"); // all_pass_plain_text
    String folder = await folderFile.readAsString();
    for (String f in folder.split(",")) {
      folderList.add(f);
    }

    final labelFile = File("$appPath/label.appt");
    String label = await labelFile.readAsString();
    for (String l in label.split(",")) {
      labelList.add(l);
    }
  }

}