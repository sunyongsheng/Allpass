import 'package:allpass/application.dart';
import 'package:allpass/params/param.dart';
import 'package:allpass/params/runtime_data.dart';

/// 存储系统参数
class Config {
  Config._();

  static String username;            // 当前使用者用户名
  static String password;            // 使用者密码
  static bool enabledBiometrics;     // 是否启用生物识别
  static bool longPressCopy;         // 是否开启长按复制，否则为长按多选
  static String lightTheme;          // 浅色主题名
  static String themeMode;           // 主题模式
  static bool webDavAuthSuccess;     // WebDAV是否验证成功
  static String webDavUrl;           // WebDAV地址
  static String webDavUsername;      // WebDAV用户名
  static String webDavPassword;      // WebDAV密码
  static int webDavPort;             // WebDAV端口号
  static String webDavPasswordName;  // WebDAV备份密码文件名
  static String webDavCardName;      // WebDAV备份卡片文件名
  static int timingInMainPassword;   // 定期输入主密码天数


  /// 参数初始化
  static void initConfig() {
    // 初始化当前用户名与密码
    username = Application.sp.getString(SharedPreferencesKeys.username)??"";
    password = Application.sp.getString(SharedPreferencesKeys.password)??"";
    // 判断是否开启生物识别
    enabledBiometrics = Application.sp.getBool(SharedPreferencesKeys.biometrics)??false;
    // 判断长按功能
    longPressCopy = Application.sp.getBool(SharedPreferencesKeys.longPressCopy)??true;
    // 初始化主题
    lightTheme = Application.sp.getString(SharedPreferencesKeys.lightTheme)??"blue";
    themeMode = Application.sp.getString(SharedPreferencesKeys.themeMode)??"system";
    // 初始化WebDAV
    webDavAuthSuccess = Application.sp.getBool(SharedPreferencesKeys.webDavAuthSuccess)??false;
    webDavUrl = Application.sp.getString(SharedPreferencesKeys.webDavUrl)??"";
    webDavUsername = Application.sp.getString(SharedPreferencesKeys.webDavUsername)??"";
    webDavPassword = Application.sp.getString(SharedPreferencesKeys.webDavPassword)??"";
    webDavPort = Application.sp.getInt(SharedPreferencesKeys.webDavPort)??443;
    webDavPasswordName = Application.sp.getString(SharedPreferencesKeys.webDavPasswordName)??"allpass_password";
    webDavCardName = Application.sp.getString(SharedPreferencesKeys.webDavCardName)??"allpass_card";
    // 定期输入主密码天数
    timingInMainPassword = Application.sp.getInt(SharedPreferencesKeys.timingInputMainPassword)??10;
    RuntimeData.initData();
  }

  /// 清空参数
  static void configClear() async {
    username = "";
    password = "";
    enabledBiometrics = false;
    longPressCopy = true;
    lightTheme = "blue";
    themeMode = "system";
    webDavAuthSuccess = false;
    webDavUrl = "";
    webDavUsername = "";
    webDavPassword = "";
    webDavPort = 443;
    webDavPasswordName = "allpass_password";
    webDavCardName = "allpass_card";
    timingInMainPassword = 10;
    RuntimeData.clearData();
  }

  static void setUsername(String value) {
    username = value;
    Application.sp.setString(SharedPreferencesKeys.username, value);
  }
  static void setPassword(String encryptedValue) {
    password = encryptedValue;
    Application.sp.setString(SharedPreferencesKeys.password, encryptedValue);
  }
  static void setEnabledBiometrics(bool value) {
    enabledBiometrics = value;
    Application.sp.setBool(SharedPreferencesKeys.biometrics, value);
  }
  static void setLongPressCopy(bool value) {
    longPressCopy = value;
    Application.sp.setBool(SharedPreferencesKeys.longPressCopy, value);
  }
  static void setLightTheme(String value) {
    lightTheme = value;
    Application.sp.setString(SharedPreferencesKeys.lightTheme, value);
  }
  static void setThemeMode(String value) {
    themeMode = value;
    Application.sp.setString(SharedPreferencesKeys.themeMode, value);
  }
  static void setWebDavAuthSuccess(bool value) {
    webDavAuthSuccess = value;
    Application.sp.setBool(SharedPreferencesKeys.webDavAuthSuccess, value);
  }
  static void setWebDavUrl(String value) {
    webDavUrl = value;
    Application.sp.setString(SharedPreferencesKeys.webDavUrl, value);
  }
  static void setWebDavUsername(String value) {
    webDavUsername = value;
    Application.sp.setString(SharedPreferencesKeys.webDavUsername, value);
  }
  static void setWebDavPassword(String encryptedValue) {
    webDavPassword = encryptedValue;
    Application.sp.setString(SharedPreferencesKeys.webDavPassword, encryptedValue);
  }
  static void setWebDavPort(int value) {
    webDavPort = value;
    Application.sp.setInt(SharedPreferencesKeys.webDavPort, value);
  }
  static void setPasswordFileName(String value) {
    webDavPasswordName = value;
    Application.sp.setString(SharedPreferencesKeys.webDavPasswordName, value);
  }
  static void setCardFileName(String value) {
    webDavCardName = value;
    Application.sp.setString(SharedPreferencesKeys.webDavCardName, value);
  }
  static void setTimingInMainPassDays(int value) {
    timingInMainPassword = value;
    Application.sp.setInt(SharedPreferencesKeys.timingInputMainPassword, value);
  }

}
