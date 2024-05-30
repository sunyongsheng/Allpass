import 'dart:convert';

import 'package:allpass/application.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/setting/theme/theme_mode.dart';
import 'package:allpass/webdav/backup/webdav_backup_method.dart';
import 'package:allpass/webdav/encrypt/encrypt_level.dart';
import 'package:allpass/webdav/merge/merge_method.dart';
import 'package:allpass/webdav/backup/custom_backup_filename.dart';
import 'package:flutter/material.dart';

/// 存储系统参数
class Config {
  Config._();

  /// 使用者密码
  static late String password;

  /// 是否启用生物识别
  static late bool enabledBiometrics;

  /// 是否开启长按复制，否则为长按多选
  static late bool longPressCopy;

  /// 浅色主题名
  static late PrimaryColor primaryColor;

  /// 主题模式
  static late ThemeMode themeMode;

  /// WebDAV是否验证成功
  static late bool webDavAuthSuccess;

  /// WebDAV地址，包含端口号
  static late String? webDavUrl;

  /// WebDAV用户名
  static late String? webDavUsername;

  /// WebDAV密码
  static late String? webDavPassword;

  /// WebDAV备份加密等级 EncryptLevel.index
  static late EncryptLevel webDavEncryptLevel;

  /// WebDAV恢复数据合并方式
  static late MergeMethod webDavMergeMethod;

  /// WebDAV备份目录，以 / 开头
  static late String webDavBackupDirectory;

  /// WebDAV上次上传时间
  static late String? webDavUploadTime;

  /// WebDAV上次下载时间
  static late String? webDavDownloadTime;

  /// WebDAV自定义备份方式
  static late WebDavBackupMethod webDavBackupMethod;

  /// WebDAV自定义备份名称
  static late WebDavCustomBackupFilename? webDavBackupFilename;

  /// 定期输入主密码天数
  static late int timingInMainPassword;

  /// 参数初始化
  static void initConfig() {
    var sp = AllpassApplication.sp;
    // 初始化主密码
    password = sp.getString(SPKeys.password) ?? "";
    // 判断是否开启生物识别
    enabledBiometrics = sp.getBool(SPKeys.biometrics) ?? false;
    // 判断长按功能
    longPressCopy = sp.getBool(SPKeys.longPressCopy) ?? true;
    // 初始化主题
    primaryColor = PrimaryColors.tryParse(sp.getString(SPKeys.primaryColor)) ?? PrimaryColor.blue;
    themeMode = ThemeModes.tryParse(sp.getString(SPKeys.themeMode)) ?? ThemeMode.system;
    // 初始化WebDAV
    webDavAuthSuccess = sp.getBool(SPKeys.webDavAuthSuccess) ?? false;
    webDavUrl = sp.getString(SPKeys.webDavUrl) ?? "";
    webDavUsername = sp.getString(SPKeys.webDavUsername) ?? "";
    webDavPassword = sp.getString(SPKeys.webDavPassword) ?? "";
    webDavEncryptLevel = EncryptLevels.tryParse(sp.getInt(SPKeys.webDavEncryptLevel)) ?? EncryptLevel.None;
    webDavMergeMethod = MergeMethods.tryParse(sp.getInt(SPKeys.webDavMergeMethod)) ?? MergeMethod.localFirst;
    webDavBackupDirectory = sp.getString(SPKeys.webDavBackupDirectory) ?? "/Allpass";
    webDavUploadTime = sp.getString(SPKeys.webDavUploadTime);
    webDavBackupMethod = WebDavBackupMethods.tryParse(sp.getString(SPKeys.webDavBackupMethod)) ?? WebDavBackupMethod.createNew;
    webDavBackupFilename = WebDavCustomBackupFilename.tryParse(sp.getString(SPKeys.webDavCustomBackupFilename));
    webDavDownloadTime = sp.getString(SPKeys.webDavDownloadTime);
    // 定期输入主密码天数
    timingInMainPassword = sp.getInt(SPKeys.timingInputMainPassword) ?? 10;
    RuntimeData.initData();
  }

  /// 清空参数
  static void configClear() async {
    password = "";
    enabledBiometrics = false;
    longPressCopy = true;
    primaryColor = PrimaryColor.blue;
    themeMode = ThemeMode.system;
    timingInMainPassword = 10;
    webDavAuthSuccess = false;
    webDavUrl = "";
    webDavUsername = "";
    webDavPassword = "";
    webDavEncryptLevel = EncryptLevel.None;
    webDavMergeMethod = MergeMethod.localFirst;
    webDavBackupMethod = WebDavBackupMethod.createNew;
    webDavBackupFilename = null;
    RuntimeData.clearData();
  }

  /// 更新上次使用密码的时间
  static void updateLatestUsePasswordTime() {
    AllpassApplication.sp.setString(SPKeys.latestUsePassword, DateTime.now().toIso8601String());
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

  static void setPrimaryColor(PrimaryColor color) {
    primaryColor = color;
    AllpassApplication.sp.setString(SPKeys.primaryColor, color.name);
  }

  static void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    AllpassApplication.sp.setString(SPKeys.themeMode, mode.name);
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

  static void setWevDavEncryptLevel(EncryptLevel level) {
    webDavEncryptLevel = level;
    AllpassApplication.sp.setInt(SPKeys.webDavEncryptLevel, level.index);
  }

  static void setWebDavMergeMethod(MergeMethod method) {
    webDavMergeMethod = method;
    AllpassApplication.sp.setInt(SPKeys.webDavMergeMethod, method.index);
  }

  static void setWebDavBackupDirectory(String directory) {
    webDavBackupDirectory = directory;
    AllpassApplication.sp.setString(SPKeys.webDavBackupDirectory, directory);
  }

  static void setWebDavUploadTime(String? value) {
    webDavUploadTime = value;
    if (value == null) {
      AllpassApplication.sp.remove(SPKeys.webDavUploadTime);
    } else {
      AllpassApplication.sp.setString(SPKeys.webDavUploadTime, value);
    }
  }

  static void setWebDavDownloadTime(String? value) {
    webDavDownloadTime = value;
    if (value == null) {
      AllpassApplication.sp.remove(SPKeys.webDavDownloadTime);
    } else {
      AllpassApplication.sp.setString(SPKeys.webDavDownloadTime, value);
    }
  }

  static void setWebDavBackupMethod(WebDavBackupMethod method) {
    webDavBackupMethod = method;
    AllpassApplication.sp.setString(SPKeys.webDavBackupMethod, method.name);
  }

  static void setWebDavCustomBackupFilename(WebDavCustomBackupFilename? filename) {
    webDavBackupFilename = filename;
    if (filename == null) {
      AllpassApplication.sp.remove(SPKeys.webDavCustomBackupFilename);
    } else {
      AllpassApplication.sp.setString(SPKeys.webDavCustomBackupFilename, jsonEncode(filename));
    }
  }

  static void setTimingInMainPassDays(int value) {
    timingInMainPassword = value;
    AllpassApplication.sp.setInt(SPKeys.timingInputMainPassword, value);
  }
}
