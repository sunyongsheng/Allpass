import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:allpass/home/home_page.dart';
import 'package:allpass/login/page/login_page.dart';
import 'package:allpass/login/page/auth_login_page.dart';

/// 登录页
var loginHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<Object>> params) => LoginPage()
);

/// 生物识别登录页
var authLoginHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<Object>> params) => AuthLoginPage()
);

/// 主页
var homeHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<Object>> params) => HomePage()
);

