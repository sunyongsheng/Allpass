import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// 存储系统参数
class Params {

  Params._();

  static String appPath;

  static Set<String> folderList = Set();
  static Set<String> labelList = Set();

  /// 参数初始化
  static paramsInit() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appPath = appDocDir.path;

    final folderFile = File("$appPath/folder.appt"); // all_pass_plain_text
    if (!folderFile.existsSync()) {
      folderFile.createSync();
    }
    String folder = folderFile.readAsStringSync();
    for (String f in folder.split(",")) {
      if (f != "") folderList.add(f);
    }

    final labelFile = File("$appPath/label.appt");
    if (!labelFile.existsSync()) {
      labelFile.createSync();
    }
    String label = labelFile.readAsStringSync();
    for (String l in label.split(",")) {
      if (l != "") labelList.add(l);
    }
  }

  /// 参数持久化
  static paramsPersistence() {
    final folderFile = File("$appPath/folder.appt");
    String folder = "";
    for (var s in folderList) {
      folder += s;
      folder += ",";
    }
    folderFile.writeAsStringSync(folder, flush: true);

    final labelFile = File("$appPath/label.appt");
    String label = "";
    for (var s in labelList) {
      label += s;
      label += ",";
    }
    labelFile.writeAsStringSync(label, flush: true);
  }

}