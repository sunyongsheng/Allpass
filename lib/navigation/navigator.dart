import 'package:allpass/application.dart';
import 'package:allpass/login/page/login_arguments.dart';
import 'package:allpass/navigation/routes.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class AllpassNavigator {
  AllpassNavigator._();

  static _navigateTo(
    BuildContext context,
    String path, {
    bool replace = false,
    bool clearStack = false,
    Duration transitionDuration = const Duration(milliseconds: 250),
    RouteTransitionsBuilder? transitionBuilder,
    TransitionType transitionType = TransitionType.material,
    Object? arguments,
  }) {
    AllpassApplication.router.navigateTo(
      context,
      path,
      replace: replace,
      clearStack: clearStack,
      transitionDuration: transitionDuration,
      transitionBuilder: transitionBuilder,
      transition: transitionType,
      routeSettings: RouteSettings(arguments: arguments),
    );
  }

  static void goLoginPage(BuildContext context, { LoginArguments? arguments = null }) {
    var args = arguments ?? LoginArguments();
    _navigateTo(
      context,
      Routes.login,
      clearStack: !args.fromAutoLock,
      arguments: args,
    );
  }

  static void goAuthLoginPage(BuildContext context, { LoginArguments? arguments = null }) {
    var args = arguments ?? LoginArguments();
    _navigateTo(
      context,
      Routes.authLogin,
      clearStack: !args.fromAutoLock,
      arguments: args,
    );
  }

  static void goHomePage(BuildContext context) {
    _navigateTo(context, Routes.home, clearStack: true);
  }

  static void goImportDataPage(BuildContext context, String data) {
    _navigateTo(
      context,
      Routes.import,
      clearStack: false,
      arguments: data,
      transitionType: TransitionType.inFromBottom,
    );
  }
}
