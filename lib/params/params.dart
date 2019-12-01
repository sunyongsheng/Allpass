import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// 存储系统参数
class Params {
  Params._();

  static String appPath;

  static List<String> folderList = List();
  static List<String> labelList = List();

  /// 添加Bean的label
  static bool labelListAdd(List<String> labels) {
    int oldLen = labelList.length;
    for (var label in labels) {
      if (!labelList.contains(label)) {
        labelList.add(label);
      }
    }
    if (labelList.length > oldLen) {
      labelParamsPersistence();
      return true;
    }
    else return false;

  }
  /// 添加folder
  static bool folderListAdd(String folder) {
    if (!folderList.contains(folder)) {
      folderList.add(folder);
      folderParamsPersistence();
      return true;
    }
    return false;
  }

  /// 参数初始化
  static paramsInit() async {
    folderList.clear();
    labelList.clear();

    Directory appDocDir = await getApplicationDocumentsDirectory();
    appPath = appDocDir.path;

    final folderFile = File("$appPath/folder.appt"); // all_pass_plain_text
    if (!folderFile.existsSync()) {
      folderFile.createSync();
    }
    String folder = folderFile.readAsStringSync();
    for (String f in folder.split(",")) {
      if (f != "" && f != '~' && f != ',' && f != " ") folderList.add(f);
    }

    final labelFile = File("$appPath/label.appt");
    if (!labelFile.existsSync()) {
      labelFile.createSync();
    }
    String label = labelFile.readAsStringSync();
    for (String l in label.split(",")) {
      if (l != "" && l != '~' && l != ',' && l != " ") labelList.add(l);
    }
  }

  /// 标签参数持久化
  static labelParamsPersistence() {
    final labelFile = File("$appPath/label.appt");
    String label = "";
    for (var s in labelList) {
      label += s;
      if (s != labelList.last) label += ",";
    }
    labelFile.writeAsStringSync(label, flush: true);
  }

  /// 文件夹参数持久化
  static folderParamsPersistence() {
    final folderFile = File("$appPath/folder.appt");
    String folder = "";
    for (var s in folderList) {
      folder += s;
      if (s != folderList.last) folder += ",";
    }
    folderFile.writeAsStringSync(folder, flush: true);
  }
}
