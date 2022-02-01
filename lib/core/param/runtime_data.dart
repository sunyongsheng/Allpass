import 'package:allpass/application.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/core/param/allpass_type.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/util/string_util.dart';

/// 存储运行时数据
class RuntimeData {
  RuntimeData._();

  static List<PasswordBean> multiPasswordList = []; // 多选的密码
  static List<CardBean> multiCardList = [];         // 多选的卡片
  static bool multiPasswordSelected = false;        // 是否点击了多选按钮
  static bool multiCardSelected = false;

  static List<String> folderList = [];              // 文件夹列表
  static List<String> labelList = [];               // 标签列表

  static int newPasswordOrCardCount = 0;  // 每次打开软件新增的密码或卡片数量

  static void initData() {
    String folder = AllpassApplication.sp.getString(SPKeys.folder) ?? "";
    String label = AllpassApplication.sp.getString(SPKeys.label) ?? "";
    folderList = StringUtil.waveLineSegStr2List(folder);
    labelList = StringUtil.waveLineSegStr2List(label);
  }

  static void clearData() {
    folderList.clear();
    labelList.clear();
  }

  /// 添加Bean的label
  static bool labelListAdd(List<String>? labels) {
    if (labels == null) {
      return false;
    }
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
    AllpassApplication.sp.setString(SPKeys.label, StringUtil.list2WaveLineSegStr(labelList));
  }

  /// 文件夹参数持久化
  static void folderParamsPersistence() {
    AllpassApplication.sp.setString(SPKeys.folder, StringUtil.list2WaveLineSegStr(folderList));
  }

  static void multiSelectClear(AllpassType type) {
    if (type == AllpassType.password) {
      multiPasswordList.clear();
      multiPasswordSelected = !multiPasswordSelected;
    } else if (type == AllpassType.card) {
      multiCardList.clear();
      multiCardSelected = !multiCardSelected;
    }
  }
}