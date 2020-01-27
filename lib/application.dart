import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluro/fluro.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:allpass/params/params.dart';
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

  static String version = "0.9.90";

  static initSp() async {
    sp = await SharedPreferences.getInstance();
  }

  static setupLocator() {
    getIt.registerSingleton(NavigateService());
    getIt.registerSingleton(AuthenticationService());
  }

  static initChannelAndHandle() {
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

  static _importPasswordFromFutureList(Future<List<PasswordBean>> list) async {
    PasswordDao _dao = PasswordDao();
    List<PasswordBean> passwordList = await list;
    if (passwordList != null) {
      for (var bean in passwordList) {
        await _dao.insert(bean);
        Params.labelListAdd(bean.label);
        Params.folderListAdd(bean.folder);
      }
      Fluttertoast.showToast(msg: "导入 ${passwordList.length}条记录");
      SystemNavigator.pop();
    } else {
      Fluttertoast.showToast(msg: "导入了0条记录，可能是文件格式不正确");
      SystemNavigator.pop();
    }
  }
}

void initApp() {
  Application.sp?.setString("folder", "默认~娱乐~办公~论坛~教育~社交");
  Application.sp?.setBool("FIRST_RUN", false);
}
