import 'dart:io';
import 'dart:ui';

import 'package:allpass/common/widget/loading_text_button.dart';
import 'package:allpass/home/about_page.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:allpass/application.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/encrypt/encrypt_util.dart';
import 'package:allpass/util/navigation_util.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {

  @override
  State createState() {
    return _RegisterPage();
  }
}

class _RegisterPage extends State<RegisterPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();

  @override
  void initState() {
    super.initState();

    var themeProvider = context.read<ThemeProvider>();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      themeProvider.setExtraColor(window.platformBrightness);
      _tryShowPrivacyDialog();
    });

    window.onPlatformBrightnessChanged = () {
      themeProvider.setExtraColor(window.platformBrightness);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: AllpassScreenUtil.setHeight(500)),
        child: Padding(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(150), right: ScreenUtil().setWidth(150)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                child: Text(
                  "设置 Allpass",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                padding: AllpassEdgeInsets.smallTBPadding,
              ),
              NoneBorderCircularTextField(
                  editingController:_passwordController,
                  hintText: "请输入主密码",
                  obscureText: true,
                  textAlign: TextAlign.center,
              ),
              NoneBorderCircularTextField(
                  editingController: _secondController,
                  hintText: "请再输入一遍",
                  obscureText: true,
                  textAlign: TextAlign.center,
              ),
              Container(
                padding: AllpassEdgeInsets.smallTBPadding,
                child: LoadingTextButton(
                  color: Theme.of(context).primaryColor,
                  title: "设置",
                  onPressed: () async => await register(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> register(BuildContext context) async {
    if (_passwordController.text != _secondController.text) {
      ToastUtil.showError(msg: "两次密码输入不一致！");
      return;
    }

    if (_passwordController.text.length < 6) {
      ToastUtil.showError(msg: "主密码长度必须大于等于6！");
      return;
    }

    // 判断是否已有账号存在
    if (Config.password.isEmpty) {
      _registerActual();
      ToastUtil.show(msg: "设置成功");
    } else {
      ToastUtil.showError(msg: "已有账号注册过，只允许单账号");
    }
  }

  void _registerActual() {
    String _password = EncryptUtil.encrypt(_passwordController.text);
    Config.setPassword(_password);
    Config.setEnabledBiometrics(false);
    NavigationUtil.goLoginPage(context);
  }

  void _tryShowPrivacyDialog() {
    if (AllpassApplication.sp.getBool(SPKeys.firstRun) ?? true) {
      showDialog(
        context: context,
        builder: (cx) => AlertDialog(
          title: Text("服务条款"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AboutPage.serviceContent,
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("同意并继续"),
              onPressed: () async {
                await initAppFirstRun();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("取消"),
              onPressed: () => exit(0),
            )
          ],
        ),
      );
    }
  }
}