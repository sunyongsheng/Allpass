import 'package:allpass/application.dart';
import 'package:allpass/model/card_bean.dart';
import 'package:allpass/model/password_bean.dart';
import 'package:allpass/utils/string_process.dart';

class RuntimeData {
  RuntimeData._();

  static List<PasswordBean> multiPasswordList = List(); // 多选的密码
  static List<CardBean> multiCardList = List();         // 多选的卡片

  static List<String> folderList = List();
  static List<String> labelList = List();

  static int newPasswordOrCardCount;  // 每次打开软件新增的密码或卡片数量

  static void initData() {
    folderList.clear();
    labelList.clear();
    newPasswordOrCardCount = 0;
    if (Application.sp.containsKey("folder")) {
      String folder = Application.sp.getString("folder");
      folderList = waveLineSegStr2List(folder);
    }
    if (Application.sp.containsKey("label")) {
      String label = Application.sp.getString("label");
      labelList = waveLineSegStr2List(label);
    }
  }

  static void clearData() {
    folderList.clear();
    labelList.clear();
  }

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
    } else
      return false;
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

  /// 标签参数持久化
  static void labelParamsPersistence() {
    Application.sp.setString("label", list2WaveLineSegStr(labelList));
  }

  /// 文件夹参数持久化
  static void folderParamsPersistence() {
    Application.sp.setString("folder", list2WaveLineSegStr(folderList));
  }
}