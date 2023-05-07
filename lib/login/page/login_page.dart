import 'dart:ui';
import 'package:allpass/common/widget/loading_text_button.dart';
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
                  "解锁 Allpass",
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
                hintText: "请输入主密码",
                obscureText: true,
                onEditingComplete: login,
                textAlign: TextAlign.center,
                autoFocus: true,
              ),
              Container(
                child: LoadingTextButton(
                  color: Theme.of(context).primaryColor,
                  title: "解锁",
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
                    child: Text("使用生物识别"),
                    onPressed: () {
                      if (Config.enabledBiometrics) {
                        NavigationUtil.goAuthLoginPage(context);
                      } else {
                        ToastUtil.show(msg: "您还未开启生物识别");
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
      ToastUtil.showError(msg: "锁定中，还剩$lockSeconds秒");
      return;
    }

    if (inputErrorTimes >= 5) {
      await Locker.lock();
      inputErrorTimes = 0;
      ToastUtil.showError(msg: "连续错误超过五次，锁定30秒");
      return;
    }

    var password = _passwordController.text;
    if (password.isEmpty) {
      ToastUtil.show(msg: "请先输入应用主密码");
      return;
    }

    if (Config.password != "") {
      if (Config.password == EncryptUtil.encrypt(password)) {
        NavigationUtil.goHomePage(context);
        ToastUtil.show(msg: "登录成功");
        Config.updateLatestUsePasswordTime();
      } else {
        inputErrorTimes++;
        ToastUtil.showError(msg: "主密码错误，已错误$inputErrorTimes次，连续超过五次将锁定30秒");
      }
    } else {
      ToastUtil.showError(msg: "还未设置过Allpass，请先进行设置");
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => RegisterPage(),
      ));
    }
  }
}
