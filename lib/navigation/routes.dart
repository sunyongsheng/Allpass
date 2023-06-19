import 'package:allpass/core/common_logger.dart';
import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart';

import 'package:allpass/navigation/route_handles.dart';
import 'package:allpass/login/page/login_page.dart';

class Routes {
  static String root = "/";
  static String home = "/home";
  static String login = "/login";
  static String authLogin = "/authLogin";
  static String import = "/import";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<Object>> params) {
          commonLogger.e("ROUTE NOT FOUND params=$params");
          return LoginPage();
        }
    );
    router.define(login, handler: loginHandler);
    router.define(home, handler: homeHandler);
    router.define(authLogin, handler: authLoginHandler);
    router.define(import, handler: importDataHandler);
  }
}