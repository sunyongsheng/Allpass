import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:allpass/services/navigate_service.dart';
import 'package:allpass/services/local_authentication_service.dart';

class Application {
  static Router router;
  static GlobalKey<NavigatorState> key = GlobalKey();
  static SharedPreferences sp;
  static GetIt getIt = GetIt.instance;

  static initSp() async {
    sp = await SharedPreferences.getInstance();
  }

  static setupLocator() {
    getIt.registerSingleton(NavigateService());
    getIt.registerSingleton(LocalAuthenticationService());
  }
}
