import 'dart:ui';

import 'package:allpass/core/di/di.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:allpass/application.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/navigation/navigator.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/core/service/auth_service.dart';
import 'package:allpass/setting/account/widget/input_main_password_dialog.dart';
import 'package:allpass/setting/theme/theme_provider.dart';


/// 生物识别登录页
class AuthLoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _AuthLoginPage();
  }
}

class _AuthLoginPage extends State<StatefulWidget> {

  final AuthService _localAuthService = inject();

  @override
  void initState() {
    super.initState();

    var themeProvider = context.read<ThemeProvider>();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      themeProvider.setExtraColor(PlatformDispatcher.instance.platformBrightness);
      askAuth(context);
    });

    PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
      themeProvider.setExtraColor(PlatformDispatcher.instance.platformBrightness);
    };
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            child: Text(
              l10n.unlockAllpass,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
              ),
            ),
            padding: AllpassEdgeInsets.smallTBPadding,
          ),
          Padding(
            padding: AllpassEdgeInsets.smallTBPadding,
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent)
            ),
            autofocus: true,
            onPressed: () => askAuth(context),
            child: Column(
              children: <Widget>[
                Icon(Icons.fingerprint, size: AllpassScreenUtil.setWidth(150),),
                Padding(padding: EdgeInsets.only(
                  top: AllpassScreenUtil.setHeight(40),
                )),
                Text(l10n.clickToUseBiometrics)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: AllpassScreenUtil.setHeight(200)),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                child: Text(l10n.usePassword),
                onPressed: () async {
                  await _localAuthService.stopAuthenticate();
                  AllpassNavigator.goLoginPage(context);
                },
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: AllpassScreenUtil.setHeight(80)),)
        ],
      ),
    );
  }

  Future<Null> askAuth(BuildContext context) async {
    var l10n = context.l10n;
    // 两次时间
    DateTime now = DateTime.now();
    DateTime latestUsePassword = DateTime.parse(AllpassApplication.sp.get(SPKeys.latestUsePassword)?.toString() ?? now.toIso8601String());
    if (Config.timingInMainPassword > 0 && now.difference(latestUsePassword).inDays >= Config.timingInMainPassword) {
      await _localAuthService.stopAuthenticate();
      showDialog<bool>(
        context: context,
        builder: (context) => InputMainPasswordDialog(
          helperText: l10n.inputMainPasswordTimingHint,
        ),
      ).then((value) {
        if (value ?? false) {
          ToastUtil.show(msg: l10n.verificationSuccess);
          Config.updateLatestUsePasswordTime();
          AllpassNavigator.goHomePage(context);
        } else {
          ToastUtil.show(msg: l10n.mainPasswordErrorHint);
          AllpassNavigator.goLoginPage(context);
        }
      });
    } else {
      var authResult = await _localAuthService.authenticate(context);
      if (authResult == AuthResult.Success) {
        ToastUtil.show(msg: l10n.verificationSuccess);
        AllpassNavigator.goHomePage(context);
      } else if (authResult == AuthResult.Failed) {
        ToastUtil.show(msg: l10n.biometricsRecognizedFailed);
      }
    }
  }
}