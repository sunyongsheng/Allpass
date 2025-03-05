import 'package:allpass/core/di/di.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/login/page/abstract_login_page.dart';
import 'package:allpass/setting/account/input_main_password_timing.dart';
import 'package:flutter/material.dart';

import 'package:allpass/application.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/navigation/navigator.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/core/service/auth_service.dart';
import 'package:allpass/setting/account/widget/input_main_password_dialog.dart';


/// 生物识别登录页
class AuthLoginPage extends AbstractLoginPage {

  const AuthLoginPage({super.key, required super.arguments});

  @override
  State<StatefulWidget> createState() {
    return _AuthLoginPage();
  }
}

class _AuthLoginPage extends AbstractLoginState {

  final AuthService _localAuthService = inject();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      login();
    });
  }

  @override
  Widget buildRoot(BuildContext context) {
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
              backgroundColor: WidgetStateProperty.all(Colors.transparent)
            ),
            autofocus: true,
            onPressed: () => login(),
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

  @override
  Future<bool> onPreLogin() async {
    var l10n = context.l10n;
    // 两次时间
    DateTime now = DateTime.now();
    String? lastUsePassword = AllpassApplication.sp.getString(SPKeys.latestUsePassword);
    DateTime lastUsePasswordTime;
    if (lastUsePassword == null) {
      lastUsePasswordTime = now;
    } else {
      lastUsePasswordTime = DateTime.parse(lastUsePassword);
    }
    if (Config.timingInMainPassword != InputMainPasswordTimingEnum.never
        && now.difference(lastUsePasswordTime).inDays >= Config.timingInMainPassword.days
    ) {
      await _localAuthService.stopAuthenticate();
      var result = await showDialog<bool>(
        context: context,
        builder: (context) => InputMainPasswordDialog(
          helperText: l10n.inputMainPasswordTimingHint,
        ),
      );
      if (result ?? false) {
        ToastUtil.show(msg: l10n.verificationSuccess);
        return true;
      } else {
        ToastUtil.show(msg: l10n.mainPasswordErrorHint);
        Config.setHasLockManually(true);
        AllpassNavigator.goLoginPage(context);
      }
      return false;
    }

    var authResult = await _localAuthService.authenticate(context);
    if (authResult == AuthResult.Success) {
      ToastUtil.show(msg: l10n.verificationSuccess);
      return true;
    } else if (authResult == AuthResult.Failed) {
      ToastUtil.show(msg: l10n.biometricsRecognizedFailed);
    } else {
      ToastUtil.show(msg: l10n.authorizationFailed);
    }
    return false;
  }
}