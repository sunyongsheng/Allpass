import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart';

import 'package:allpass/application.dart';
import 'package:allpass/route/routes.dart';
import 'package:allpass/model/password_bean.dart';

class NavigationUtil {
  static _navigateTo(BuildContext context, String path,
      {bool replace: false,
      bool clearStack: false,
      Duration transitionDuration: const Duration(milliseconds: 250),
      RouteTransitionsBuilder transitionBuilder}) {
    Application.router.navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        transitionDuration: transitionDuration,
        transitionBuilder: transitionBuilder,
        transition: TransitionType.material);
  }

  static void goLoginPage(BuildContext context) {
    _navigateTo(context, Routes.login, clearStack: true);
  }

  static void goAuthLoginPage(BuildContext context) {
    _navigateTo(context, Routes.authLogin, clearStack: true);
  }

  static void goHomePage(BuildContext context) {
    _navigateTo(context, Routes.home, clearStack: true);
  }

  static void goPasswordPage(BuildContext context) {
    _navigateTo(context, Routes.password);
  }

  static void goCardPage(BuildContext context) {
    _navigateTo(context, Routes.card);
  }

  static void goSettingPage(BuildContext context) {
    _navigateTo(context, Routes.setting);
  }

  static void goViewPasswordPage(BuildContext context,
    {@required PasswordBean data}) {
    _navigateTo(context, Routes.viewPassword);
  }
}
