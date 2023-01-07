import 'dart:convert';

import 'package:allpass/card/data/card_dao.dart';
import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/core/route/routes.dart';
import 'package:allpass/core/service/allpass_service.dart';
import 'package:allpass/core/service/auth_service.dart';
import 'package:allpass/password/data/password_dao.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/password/data/password_repository.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/password/model/simple_user.dart';
import 'package:allpass/setting/theme/theme_mode.dart';
import 'package:allpass/util/csv_util.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/webdav/service/webdav_sync_service.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllpassApplication {
  AllpassApplication._();

  static GlobalKey<NavigatorState> navigationKey = GlobalKey();

  static late GetIt getIt;
  static late FluroRouter router;
  static late SharedPreferences sp;
  static late MethodChannel methodChannel;

  static String version = "1.6.4";

  static int systemSdkInt = -1;
  static bool isAndroid = true;
  static String identification = "";

  static Future<Null> initSp() async {
    sp = await SharedPreferences.getInstance();
  }

  static void initLocator() {
    getIt = GetIt.instance;

    getIt.registerSingleton<AuthService>(AuthServiceImpl());
    getIt.registerSingleton<AllpassService>(AllpassServiceImpl());
    getIt.registerSingleton<WebDavSyncService>(WebDavSyncServiceImpl());

    getIt.registerSingleton(PasswordRepository());

    getIt.registerSingleton(PasswordDao());
    getIt.registerSingleton(CardDao());
  }

  static void initRouter() {
    FluroRouter router = FluroRouter();
    Routes.configureRoutes(router);
    AllpassApplication.router = router;
  }

  static void initAndroidChannel() {
    methodChannel = MethodChannel(ChannelConstants.channel);

    // 查询自动填充Channel
    var queryAutofillMessageChannel = BasicMessageChannel(ChannelConstants.channelQueryAutofillPassword, StringCodec());
    queryAutofillMessageChannel.setMessageHandler((message) => Future<String>(() {
      if (message != null) {
        var queryParam = message.split(",");
        return _queryPasswordForAutofill(queryParam[0], queryParam[1]);
      }
      return "[]";
    }));

    // 保存密码Channel
    var savePasswordChannel = BasicMessageChannel(ChannelConstants.channelSaveForAutofill, StringCodec());
    savePasswordChannel.setMessageHandler((jsonStr) => Future<String>(() async {
      return _savePasswordForAutofill(jsonStr!);
    }));

    // 导入密码Channel
    var importCsvMessageChannel = BasicMessageChannel(ChannelConstants.channelImportCsv, StringCodec());
    importCsvMessageChannel.setMessageHandler((message) => Future<String>(() {
      Future<List<PasswordBean>?> res = CsvUtil.passwordImportFromCsv(toParseText: message);
      return _importPasswordFromFutureList(res);
    }));
  }

  static Future<String> _importPasswordFromFutureList(Future<List<PasswordBean>?> list) async {
    List<PasswordBean>? passwordList = await list;
    if (passwordList != null) {
      PasswordDao dao = getIt.get();
      for (var bean in passwordList) {
        await dao.insert(bean);
        RuntimeData.labelListAdd(bean.label);
        RuntimeData.folderListAdd(bean.folder);
      }
      return passwordList.length.toString();
    } else {
      return "0";
    }
  }

  static Future<String> _savePasswordForAutofill(String jsonStr) async {
    SimpleUser userData = SimpleUser.fromJson(json.decode(jsonStr));
    if (userData.username != null && userData.password != null && userData.appId != null) {
      userData.password = EncryptUtil.encrypt(userData.password!);
      PasswordDao passwordDao = getIt.get();
      // 如果同AppId下有相同的username则更新；否则创建
      var existList = await passwordDao.findByAppIdAndUsername(userData.appId!, userData.username!);
      if (existList.isEmpty) {
        passwordDao.insertUserData(userData);
      } else {
        passwordDao.updateUserData(userData);
      }
    }
    return "";
  }

  static Future<String> _queryPasswordForAutofill(String appId, String? appName) async {
    PasswordDao dao = getIt.get();
    var passwordList = await dao.findByAppIdOrAppName(appId, appName);
    List<SimpleUser> list = passwordList.map((password) => SimpleUser(
        password.name,
        password.username,
        EncryptUtil.decrypt(password.password),
        password.appName,
        password.appId
    )).toList(growable: false);
    return json.encode(list);
  }

  static Future<Null> clearAll(BuildContext context) async {
    await context.read<PasswordProvider>().clear();
    await context.read<CardProvider>().clear();
    await EncryptUtil.clearEncrypt();
    await AllpassApplication.sp.clear();
    Config.configClear();

    await EncryptUtil.initEncrypt();
  }
}

/// 软件第一次运行，用户点击“同意并继续”后，对软件进行初始化，仅会调用一次
Future<Null> initAppFirstRun() async {
  // 对10个key进行设置，label、latestUsePassword、WebDav配置相关不在其中
  AllpassApplication.sp.setBool(SPKeys.firstRun, false);
  AllpassApplication.sp.setString(SPKeys.allpassVersion, AllpassApplication.version);
  AllpassApplication.sp.setBool(SPKeys.needRegister, true);
  AllpassApplication.sp.setString(SPKeys.username, "");
  AllpassApplication.sp.setString(SPKeys.password, "");
  AllpassApplication.sp.setBool(SPKeys.biometrics, false);
  AllpassApplication.sp.setBool(SPKeys.longPressCopy, true);
  AllpassApplication.sp.setBool(SPKeys.webDavAuthSuccess, false);
  AllpassApplication.sp.setString(SPKeys.primaryColor, PrimaryColor.blue.name);
  AllpassApplication.sp.setString(SPKeys.themeMode, ThemeMode.system.name);
  AllpassApplication.sp.setString(SPKeys.folder, "默认~娱乐~办公~论坛~教育~社交");
  Config.initConfig();
}
