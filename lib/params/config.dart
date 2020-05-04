import 'package:allpass/application.dart';
import 'package:allpass/params/param.dart';
import 'package:allpass/params/runtime_data.dart';

/// 存储系统参数
class Config {
  Config._();

  static String username;         // 当前使用者用户名
  static String password;         // 使用者密码
  static bool enabledBiometrics;  // 是否启用生物识别
  static bool longPressCopy;      // 是否开启长按复制，否则为长按多选
  static String theme;            // 主题名
  static bool webDavAuthSuccess;  // WebDAV是否验证成功
  static String webDavUrl;        // WebDAV地址
  static String webDavUsername;   // WebDAV用户名
  static String webDavPassword;   // WebDAV密码
  static int webDavPort;          // WebDAV端口号


  /// 参数初始化
  static configInit() async {
    if (Application.sp == null) {
      await Application.initSp();
    }
    // 初始化当前用户名与密码
    username = Application.sp.getString(SharedPreferencesKeys.username)??"";
    password = Application.sp.getString(SharedPreferencesKeys.password)??"";
    // 判断是否开启生物识别
    enabledBiometrics = Application.sp.getBool(SharedPreferencesKeys.biometrics)??false;
    // 判断长按功能
    longPressCopy = Application.sp.getBool(SharedPreferencesKeys.longPressCopy)??true;
    // 初始化主题
    theme = Application.sp.getString(SharedPreferencesKeys.theme)??"blue";
    // 初始化WebDAV
    webDavAuthSuccess = Application.sp.getBool(SharedPreferencesKeys.webDavAuthSuccess)??false;
    webDavUrl = Application.sp.getString(SharedPreferencesKeys.webDavUrl)??"";
    webDavUsername = Application.sp.getString(SharedPreferencesKeys.webDavUsername)??"";
    webDavPassword = Application.sp.getString(SharedPreferencesKeys.webDavPassword)??"";
    webDavPort = Application.sp.getInt(SharedPreferencesKeys.webDavPort)??443;
    RuntimeData.initData();
  }

  /// 清空参数
  static configClear() async {
    username = "";
    password = "";
    enabledBiometrics = false;
    longPressCopy = true;
    theme = "blue";
    webDavAuthSuccess = false;
    webDavUrl = "";
    webDavUsername = "";
    webDavPassword = "";
    webDavPort = 443;
    RuntimeData.clearData();
  }

}
