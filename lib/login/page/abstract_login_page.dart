import 'dart:ui';
import 'package:allpass/login/page/login_arguments.dart';
import 'package:allpass/setting/autolock/auto_lock_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:allpass/navigation/navigator.dart';
import 'package:allpass/setting/theme/theme_provider.dart';

abstract class AbstractLoginPage extends StatefulWidget {
  final LoginArguments arguments;

  const AbstractLoginPage({super.key, required this.arguments});
}

abstract class AbstractLoginState extends State<AbstractLoginPage> {

  @override
  void initState() {
    super.initState();

    var themeProvider = context.read<ThemeProvider>();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      themeProvider.setExtraColor(PlatformDispatcher.instance.platformBrightness);
    });

    PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
      themeProvider.setExtraColor(PlatformDispatcher.instance.platformBrightness);
    };
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: buildRoot(context),
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (result != true) {
          SystemNavigator.pop();
        }
      },
    );
  }

  void login() async {
    var valid = await onPreLogin();
    if (!valid) {
      return;
    }

    if (widget.arguments.fromAutoLock) {
      AutoLockHandler.unlock();
      Navigator.pop(context, true);
    } else {
      AllpassNavigator.goHomePage(context);
    }
  }

  Widget buildRoot(BuildContext context);

  /// return true 表示校验成功
  Future<bool> onPreLogin();
}
