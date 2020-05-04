import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluro/fluro.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:allpass/params/config.dart';
import 'package:allpass/params/param.dart';
import 'package:allpass/params/runtime_data.dart';
import 'package:allpass/utils/csv_util.dart';
import 'package:allpass/dao/password_dao.dart';
import 'package:allpass/model/password_bean.dart';
import 'package:allpass/services/navigate_service.dart';
import 'package:allpass/services/authentication_service.dart';

class Application {
  static Router router;
  static GlobalKey<NavigatorState> key = GlobalKey();
  static SharedPreferences sp;
  static GetIt getIt = GetIt.instance;
  static const platform = const MethodChannel("allpass.aengus.top/share");

  static String version = "1.1.7";

  static Future<Null> initSp() async {
    sp = await SharedPreferences.getInstance();
  }

  static void setupLocator() {
    getIt.registerSingleton(NavigateService());
    getIt.registerSingleton(AuthenticationService());
  }

  static void initChannelAndHandle() {
    platform.setMethodCallHandler((call) {
      if (call.method == "getChromeData") {
        Future<List<PasswordBean>> res = CsvUtil().passwordImportFromCsv(toParseText: call.arguments);
        _importPasswordFromFutureList(res);
        return res;
      } else {
        return null;
      }
    });
  }

  static void _importPasswordFromFutureList(Future<List<PasswordBean>> list) async {
    PasswordDao _dao = PasswordDao();
    List<PasswordBean> passwordList = await list;
    if (passwordList != null) {
      for (var bean in passwordList) {
        await _dao.insert(bean);
        RuntimeData.labelListAdd(bean.label);
        RuntimeData.folderListAdd(bean.folder);
      }
      Fluttertoast.showToast(msg: "导入 ${passwordList.length}条记录");
      SystemNavigator.pop();
    } else {
      Fluttertoast.showToast(msg: "导入了0条记录，可能是文件格式不正确");
      SystemNavigator.pop();
    }
  }
  /// 更新上次使用密码的时间
  static void updateLatestUsePasswordTime() {
    Application.sp.setString(SharedPreferencesKeys.latestUsePassword, DateTime.now().toIso8601String());
  }
}

/// 软件第一次运行，用户点击“同意并继续”后，对软件进行初始化，仅会调用一次
Future<Null> initAppFirstRun() async {
  // 对8个key进行设置，label、latestUsePassword、WebDav配置相关不在其中
  Application.sp.setBool(SharedPreferencesKeys.firstRun, false);
  Application.sp.setBool(SharedPreferencesKeys.needRegister, true);
  Application.sp.setString(SharedPreferencesKeys.username, "");
  Application.sp.setString(SharedPreferencesKeys.password, "");
  Application.sp.setBool(SharedPreferencesKeys.biometrics, false);
  Application.sp.setBool(SharedPreferencesKeys.longPressCopy, true);
  Application.sp.setBool(SharedPreferencesKeys.webDavAuthSuccess, false);
  Application.sp.setString(SharedPreferencesKeys.theme, "blue");
  Application.sp.setString(SharedPreferencesKeys.folder, "默认~娱乐~办公~论坛~教育~社交");
  await Config.configInit();
}
