import 'package:allpass/application.dart';
import 'package:allpass/core/enums/encrypt_level.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/webdav/merge/merge_method.dart';

/// 存储系统参数
class Config {
  Config._();

  static late String username; // 当前使用者用户名
  static late String password; // 使用者密码
  static late bool enabledBiometrics; // 是否启用生物识别
  static late bool longPressCopy; // 是否开启长按复制，否则为长按多选
  static late String lightTheme; // 浅色主题名
  static late String themeMode; // 主题模式
  static late bool webDavAuthSuccess; // WebDAV是否验证成功
  static late String? webDavUrl; // WebDAV地址
  static late String? webDavUsername; // WebDAV用户名
  static late String? webDavPassword; // WebDAV密码
  static late int? webDavPort; // WebDAV端口号
  static late EncryptLevel webDavEncryptLevel; // WebDAV备份加密等级 EncryptLevel.index
  static late MergeMethod webDavMergeMethod; // WebDAV恢复数据合并方式
  static late String? webDavUploadTime; // WebDAV上次上传时间
  static late String? webDavDownloadTime; // WebDAV上次下载时间
  static late int timingInMainPassword; // 定期输入主密码天数

  /// 参数初始化
  static void initConfig() {
    var sp = AllpassApplication.sp;
    // 初始化当前用户名与密码
    username = sp.getString(SPKeys.username) ?? "";
    password = sp.getString(SPKeys.password) ?? "";
    // 判断是否开启生物识别
    enabledBiometrics = sp.getBool(SPKeys.biometrics) ?? false;
    // 判断长按功能
    longPressCopy = sp.getBool(SPKeys.longPressCopy) ?? true;
    // 初始化主题
    lightTheme = sp.getString(SPKeys.lightTheme) ?? "blue";
    themeMode = sp.getString(SPKeys.themeMode) ?? "system";
    // 初始化WebDAV
    webDavAuthSuccess = sp.getBool(SPKeys.webDavAuthSuccess) ?? false;
    webDavUrl = sp.getString(SPKeys.webDavUrl) ?? "";
    webDavUsername = sp.getString(SPKeys.webDavUsername) ?? "";
    webDavPassword = sp.getString(SPKeys.webDavPassword) ?? "";
    webDavPort = sp.getInt(SPKeys.webDavPort) ?? 443;
    webDavEncryptLevel = EncryptLevels.parse(sp.getInt(SPKeys.webDavEncryptLevel) ?? EncryptLevel.OnlyPassword.index);
    webDavMergeMethod = MergeMethods.parse(sp.getInt(SPKeys.webDavMergeMethod) ?? MergeMethod.localFirst.index);
    webDavUploadTime = sp.getString(SPKeys.webDavUploadTime);
    webDavDownloadTime = sp.getString(SPKeys.webDavDownloadTime);
    // 定期输入主密码天数
    timingInMainPassword = sp.getInt(SPKeys.timingInputMainPassword) ?? 10;
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
    webDavEncryptLevel = EncryptLevel.OnlyPassword;
    webDavMergeMethod = MergeMethod.localFirst;
    timingInMainPassword = 10;
    RuntimeData.clearData();
  }

  /// 更新上次使用密码的时间
  static void updateLatestUsePasswordTime() {
    AllpassApplication.sp.setString(SPKeys.latestUsePassword, DateTime.now().toIso8601String());
  }

  static void setUsername(String value) {
    username = value;
    AllpassApplication.sp.setString(SPKeys.username, value);
  }

  static void setPassword(String encryptedValue) {
    password = encryptedValue;
    AllpassApplication.sp.setString(SPKeys.password, encryptedValue);
  }

  static void setEnabledBiometrics(bool value) {
    enabledBiometrics = value;
    AllpassApplication.sp.setBool(SPKeys.biometrics, value);
  }

  static void setLongPressCopy(bool value) {
    longPressCopy = value;
    AllpassApplication.sp.setBool(SPKeys.longPressCopy, value);
  }

  static void setLightTheme(String value) {
    lightTheme = value;
    AllpassApplication.sp.setString(SPKeys.lightTheme, value);
  }

  static void setThemeMode(String value) {
    themeMode = value;
    AllpassApplication.sp.setString(SPKeys.themeMode, value);
  }

  static void setWebDavAuthSuccess(bool value) {
    webDavAuthSuccess = value;
    AllpassApplication.sp.setBool(SPKeys.webDavAuthSuccess, value);
  }

  static void setWebDavUrl(String? value) {
    webDavUrl = value;
    if (value == null) {
      AllpassApplication.sp.remove(SPKeys.webDavUrl);
    } else {
      AllpassApplication.sp.setString(SPKeys.webDavUrl, value);
    }
  }

  static void setWebDavUsername(String? value) {
    webDavUsername = value;
    if (value == null) {
      AllpassApplication.sp.remove(SPKeys.webDavUsername);
    } else {
      AllpassApplication.sp.setString(SPKeys.webDavUsername, value);
    }
  }

  static void setWebDavPassword(String? encryptedValue) {
    webDavPassword = encryptedValue;
    if (encryptedValue == null) {
      AllpassApplication.sp.remove(SPKeys.webDavPassword);
    } else {
      AllpassApplication.sp.setString(SPKeys.webDavPassword, encryptedValue);
    }
  }

  static void setWebDavPort(int? value) {
    webDavPort = value;
    if (value == null) {
      AllpassApplication.sp.remove(SPKeys.webDavPort);
    } else {
      AllpassApplication.sp.setInt(SPKeys.webDavPort, value);
    }
  }

  static void setWevDavEncryptLevel(EncryptLevel level) {
    webDavEncryptLevel = level;
    AllpassApplication.sp.setInt(SPKeys.webDavEncryptLevel, level.index);
  }

  static void setWebDavMergeMethod(MergeMethod method) {
    webDavMergeMethod = method;
    AllpassApplication.sp.setInt(SPKeys.webDavMergeMethod, method.index);
  }

  static void setWebDavUploadTime(String value) {
    webDavUploadTime = value;
    AllpassApplication.sp.setString(SPKeys.webDavUploadTime, value);
  }

  static void setWebDavDownloadTime(String value) {
    webDavDownloadTime = value;
    AllpassApplication.sp.setString(SPKeys.webDavDownloadTime, value);
  }

  static void setTimingInMainPassDays(int value) {
    timingInMainPassword = value;
    AllpassApplication.sp.setInt(SPKeys.timingInputMainPassword, value);
  }
}
