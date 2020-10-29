import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart';

import 'package:allpass/route/route_handles.dart';
import 'package:allpass/page/login/login_page.dart';

class Routes {
  static String root = "/";
  static String home = "/home";
  static String login = "/login";
  static String authLogin = "/authlogin";
  static String initEncrypt = "/initEncrypt";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
          print("ROUTE NOT FOUND");
          return LoginPage();
        }
    );
    router.define(login, handler: loginHandler);
    router.define(home, handler: homeHandler);
    router.define(authLogin, handler: authLoginHandler);
    router.define(initEncrypt, handler: initEncryptHandler);
  }
}