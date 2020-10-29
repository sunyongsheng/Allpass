import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluro/fluro.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:allpass/route/routes.dart';
import 'package:allpass/param/config.dart';
import 'package:allpass/param/param.dart';
import 'package:allpass/param/runtime_data.dart';
import 'package:allpass/util/csv_util.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/dao/password_dao.dart';
import 'package:allpass/model/data/password_bean.dart';
import 'package:allpass/provider/card_provider.dart';
import 'package:allpass/provider/password_provider.dart';
import 'package:allpass/service/auth_service.dart';
import 'package:allpass/service/allpass_service.dart';
import 'package:allpass/service/webdav_sync_service.dart';
import 'package:allpass/service/impl/auth_service_impl.dart';
import 'package:allpass/service/impl/allpass_service_impl.dart';
import 'package:allpass/service/impl/webdav_sync_service_impl.dart';

class Application {
  static GlobalKey<NavigatorState> key = GlobalKey();

  static GetIt getIt;
  static FluroRouter router;
  static SharedPreferences sp;
  static MethodChannel shareMethodChannel;

  static String version = "1.5.0";

  static Future<Null> initSp() async {
    sp = await SharedPreferences.getInstance();
  }

  static void initLocator() {
    getIt = GetIt.instance;
    getIt.registerSingleton<AuthService>(AuthServiceImpl());
    getIt.registerSingleton<AllpassService>(AllpassServiceImpl());
    getIt.registerSingleton<WebDavSyncService>(WebDavSyncServiceImpl());
  }

  static void initRouter() {
    FluroRouter router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  static void initChannelAndHandle() {
    shareMethodChannel = const MethodChannel("allpass.aengus.top/share");
    shareMethodChannel.setMethodCallHandler((call) {
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
    Application.sp.setString(SPKeys.latestUsePassword, DateTime.now().toIso8601String());
  }

  static Future<Null> clearAll(BuildContext context) async {
    await Provider.of<PasswordProvider>(context).clear();
    await Provider.of<CardProvider>(context).clear();
    await EncryptUtil.clearEncrypt();
    await Application.sp.clear();
    Config.configClear();

    await EncryptUtil.initEncrypt();
  }
}

/// 软件第一次运行，用户点击“同意并继续”后，对软件进行初始化，仅会调用一次
Future<Null> initAppFirstRun() async {
  // 对10个key进行设置，label、latestUsePassword、WebDav配置相关不在其中
  Application.sp.setBool(SPKeys.firstRun, false);
  Application.sp.setString(SPKeys.allpassVersion, Application.version);
  Application.sp.setBool(SPKeys.needRegister, true);
  Application.sp.setString(SPKeys.username, "");
  Application.sp.setString(SPKeys.password, "");
  Application.sp.setBool(SPKeys.biometrics, false);
  Application.sp.setBool(SPKeys.longPressCopy, true);
  Application.sp.setBool(SPKeys.webDavAuthSuccess, false);
  Application.sp.setString(SPKeys.lightTheme, "blue");
  Application.sp.setString(SPKeys.themeMode, "system");
  Application.sp.setString(SPKeys.folder, "默认~娱乐~办公~论坛~教育~社交");
  Config.initConfig();
}
