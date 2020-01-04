import 'package:allpass/application.dart';
import 'package:allpass/utils/string_process.dart';

/// 存储系统参数
class Params {
  Params._();

  static String username; // 当前使用者用户名
  static String password; // 使用者密码
  static bool enabledBiometrics = false; // 是否启用生物识别
  static bool longPressCopy = true;     // 是否开启长按复制，否则为长按多选

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

  /// 参数初始化
  static paramsInit() async {
    folderList.clear();
    labelList.clear();

    // 初始化当前用户名与密码
    username = Application.sp?.getString("username")??"";
    password = Application.sp?.getString("password")??"";
    // 判断是否开启生物识别
    enabledBiometrics = Application.sp?.getBool("biometrics")??false;
    // 判断长按功能
    longPressCopy = Application.sp?.getBool("longPressCopy")??true;

    // 采用SharedPreferences初始化数据
    if (Application.sp.containsKey("folder")) {
      String folder = Application.sp.getString("folder");
      folderList = str2List(folder);
    }
    if (Application.sp.containsKey("label")) {
      String label = Application.sp.getString("label");
      labelList = str2List(label);
    }
  }

  /// 清空参数
  static paramsClear() async {
    username = "";
    password = "";
    enabledBiometrics = false;
    folderList.clear();
    labelList.clear();
  }

  /// 标签参数持久化
  static labelParamsPersistence() {
    // 采用SharedPreferences持久化数据
    Application.sp.setString("label", list2Str(labelList));
  }

  /// 文件夹参数持久化
  static folderParamsPersistence() {
    // 采用SharedPreferences持久化数据
    Application.sp.setString("folder", list2Str(folderList));
  }
}
