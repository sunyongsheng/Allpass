import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart';

import 'package:allpass/pages/card/card_page.dart';
import 'package:allpass/pages/login/login_page.dart';
import 'package:allpass/pages/password/password_page.dart';
import 'package:allpass/pages/setting/setting_page.dart';
import 'package:allpass/pages/home_page.dart';

/// 登录页
var loginHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<Object>> params) => LoginPage()
);

/// 主页
var homeHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<Object>> params) => HomePage()
);

/// 密码页
var passwordHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) => PasswordPage()
);

/// 卡片页
var cardHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) => CardPage()
);

/// 设置页
var settingHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) => SettingPage()
);