import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:allpass/application.dart';
import 'package:allpass/navigation/routes.dart';

class AllpassNavigator {

  AllpassNavigator._();

  static _navigateTo(
    BuildContext context,
    String path, {
    bool replace = false,
    bool clearStack = false,
    Duration transitionDuration = const Duration(milliseconds: 250),
    RouteTransitionsBuilder? transitionBuilder,
  }) {
    AllpassApplication.router.navigateTo(context, path,
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
}
