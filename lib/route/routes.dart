import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart';

import 'package:allpass/route/route_handles.dart';
import 'package:allpass/pages/login/login_page.dart';

class Routes {
  static String root = "/";
  static String home = "/home";
  static String login = "/login";
  static String authLogin = "/authlogin";
  static String password = "/password";
  static String card = "/card";
  static String setting = "/setting";

  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
          print("ROUTE NOT FOUND");
          return LoginPage();
        }
    );
    router.define(login, handler: loginHandler);
    router.define(home, handler: homeHandler);
    router.define(password, handler: passwordHandler);
    router.define(card, handler: cardHandler);
    router.define(setting, handler: settingHandler);
    router.define(authLogin, handler: authLoginHandler);
  }
}