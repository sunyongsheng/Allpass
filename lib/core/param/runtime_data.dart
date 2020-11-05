import 'package:flutter/material.dart';
import 'package:allpass/application.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/util/string_util.dart';

/// 存储运行时数据
class RuntimeData {
  RuntimeData._();

  static List<PasswordBean> multiPasswordList = List(); // 多选的密码
  static List<CardBean> multiCardList = List();         // 多选的卡片
  static bool multiSelected;                            // 是否点击了多选按钮

  static List<String> folderList = List();              // 文件夹列表
  static List<String> labelList = List();               // 标签列表

  static int newPasswordOrCardCount;  // 每次打开软件新增的密码或卡片数量

  static double tapVerticalPosition;  // 取值范围-1到1，0代表中心位置

  static void initData() {
    newPasswordOrCardCount = 0;
    tapVerticalPosition = 0;
    multiSelected = false;

    String folder = Application.sp.getString(SPKeys.folder)??"";
    String label = Application.sp.getString(SPKeys.label)??"";
    folderList = StringUtil.waveLineSegStr2List(folder);
    labelList = StringUtil.waveLineSegStr2List(label);
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
    Application.sp.setString(SPKeys.label, StringUtil.list2WaveLineSegStr(labelList));
  }

  /// 文件夹参数持久化
  static void folderParamsPersistence() {
    Application.sp.setString(SPKeys.folder, StringUtil.list2WaveLineSegStr(folderList));
  }

  /// 更新点击的位置
  static void updateTapPosition(DragDownDetails details) {
    double y = AllpassScreenUtil.screenHighDp / 2;
    RuntimeData.tapVerticalPosition = (details.globalPosition.dy - y) / y;
  }
}