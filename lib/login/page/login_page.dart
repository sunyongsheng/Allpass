import 'package:allpass/common/widget/loading_text_button.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/login/force_locker.dart';
import 'package:allpass/login/page/abstract_login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:allpass/core/param/config.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/navigation/navigator.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/login/page/register_page.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';

/// 登陆页面
class LoginPage extends AbstractLoginPage {

  const LoginPage({super.key, required super.arguments});

  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends AbstractLoginState {
  late TextEditingController _passwordController;

  int inputErrorTimes = 0;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget buildRoot(BuildContext context) {
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
                        if (Config.hasLockManually) {
                          ToastUtil.show(msg: context.l10n.appHasForceLock);
                        } else {
                          AllpassNavigator.goAuthLoginPage(context);
                        }
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

  @override
  Future<bool> onPreLogin() async {
    var lockSeconds = ForceLocker.remainsLockSeconds();
    if (lockSeconds > 0) {
      ToastUtil.showError(msg: context.l10n.lockingRemains(lockSeconds));
      return false;
    }

    if (inputErrorTimes >= 5) {
      await ForceLocker.lock();
      inputErrorTimes = 0;
      ToastUtil.showError(msg: context.l10n.errorExceedThreshold);
      return false;
    }

    var password = _passwordController.text;
    if (password.isEmpty) {
      ToastUtil.show(msg: context.l10n.pleaseInputMainPasswordFirst);
      return false;
    }

    if (Config.password.isEmpty) {
      ToastUtil.showError(msg: context.l10n.notSetupYet);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => RegisterPage(),
      ));
      return false;
    }

    if (Config.isPasswordCorrect(password)) {
      Config.setHasLockManually(false);
      Config.updateLatestUsePasswordTime();
      ToastUtil.show(msg: context.l10n.unlockSuccess);
      return true;
    } else {
      inputErrorTimes++;
      ToastUtil.showError(msg: context.l10n.mainPasswordError(inputErrorTimes));
      return false;
    }
  }
}
