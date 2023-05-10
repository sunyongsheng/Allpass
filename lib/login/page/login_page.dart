import 'dart:ui';
import 'package:allpass/common/widget/loading_text_button.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/login/locker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:allpass/core/param/config.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/util/navigation_util.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/encrypt/encrypt_util.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/login/page/register_page.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';
import 'package:allpass/setting/theme/theme_provider.dart';

/// 登陆页面
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  late TextEditingController _passwordController;

  int inputErrorTimes = 0;

  @override
  void initState() {
    super.initState();

    _passwordController = TextEditingController();

    var themeProvider = context.read<ThemeProvider>();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      themeProvider.setExtraColor(window.platformBrightness);
    });

    window.onPlatformBrightnessChanged = () {
      themeProvider.setExtraColor(window.platformBrightness);
    };
  }
  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: AllpassScreenUtil.setHeight(400)),
        child: Padding(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(150), right: ScreenUtil().setWidth(150)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                child: Text(
                  context.l10n.unlockAllpass,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                padding: AllpassEdgeInsets.smallTBPadding,
              ),
              NoneBorderCircularTextField(
                editingController: _passwordController,
                hintText: context.l10n.pleaseInputMainPassword,
                obscureText: true,
                onEditingComplete: login,
                textAlign: TextAlign.center,
                autoFocus: true,
              ),
              Container(
                child: LoadingTextButton(
                  color: Theme.of(context).primaryColor,
                  title: context.l10n.unlock,
                  onPressed: () => login(),
                ),
                padding: AllpassEdgeInsets.smallTBPadding,
              ),
              Padding(
                padding: EdgeInsets.only(top: AllpassScreenUtil.setHeight(300)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: Text(context.l10n.useBiometrics),
                    onPressed: () {
                      if (Config.enabledBiometrics) {
                        NavigationUtil.goAuthLoginPage(context);
                      } else {
                        ToastUtil.show(msg: context.l10n.notEnableBiometricsYet);
                      }
                    },
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: AllpassScreenUtil.setHeight(80)),)
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    var lockSeconds = Locker.remainsLockSeconds();
    if (lockSeconds > 0) {
      ToastUtil.showError(msg: context.l10n.lockingRemains(lockSeconds));
      return;
    }

    if (inputErrorTimes >= 5) {
      await Locker.lock();
      inputErrorTimes = 0;
      ToastUtil.showError(msg: context.l10n.errorExceedThreshold);
      return;
    }

    var password = _passwordController.text;
    if (password.isEmpty) {
      ToastUtil.show(msg: context.l10n.pleaseInputMainPasswordFirst);
      return;
    }

    if (Config.password != "") {
      if (Config.password == EncryptUtil.encrypt(password)) {
        NavigationUtil.goHomePage(context);
        ToastUtil.show(msg: context.l10n.unlockSuccess);
        Config.updateLatestUsePasswordTime();
      } else {
        inputErrorTimes++;
        ToastUtil.showError(msg: context.l10n.mainPasswordError(inputErrorTimes));
      }
    } else {
      ToastUtil.showError(msg: context.l10n.notSetupYet);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => RegisterPage(),
      ));
    }
  }
}
