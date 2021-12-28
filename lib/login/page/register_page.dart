import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:allpass/application.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/util/navigation_util.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';
import 'package:allpass/login/page/login_page.dart';

class RegisterPage extends StatefulWidget {

  @override
  State createState() {
    return _RegisterPage();
  }
}

class _RegisterPage extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();

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
                  "注册 Allpass",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                  ),
                ),
                padding: AllpassEdgeInsets.smallTBPadding,
              ),
              NoneBorderCircularTextField(
                  editingController: _usernameController,
                  hintText: "请输入用户名",
                  textAlign: TextAlign.center,
              ),
              NoneBorderCircularTextField(
                  editingController:_passwordController,
                  hintText: "请输入密码",
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
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(AllpassUI.smallBorderRadius))
                  ),
                  color: Theme.of(context).primaryColor,
                  minWidth: double.infinity,
                  child: Text("注册", style: TextStyle(color: Colors.white, fontSize: 15),),
                  onPressed: () async => await register(context),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: AllpassScreenUtil.setHeight(300)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: Text("已有账号？登录"),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(
                        builder: (context) => LoginPage()
                    )),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: AllpassScreenUtil.setHeight(80)),)
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
    if (_usernameController.text.length < 6 && _passwordController.text.length < 6) {
      ToastUtil.showError(msg: "用户名或密码长度必须大于等于6！");
      return;
    }
    if (_usernameController.text.length > 15) {
      ToastUtil.showError(msg: "用户名长度最长为15个字符！");
      return;
    }
    // 判断是否已有账号存在
    if (Application.sp.getString(SPKeys.username) == "") {
      _registerActual();
      ToastUtil.show(msg: "注册成功");
    } else {
      ToastUtil.showError(msg: "已有账号注册过，只允许单账号");
    }
  }

  void _registerActual() {
    String _password = EncryptUtil.encrypt(_passwordController.text);
    Config.setUsername(_usernameController.text);
    Config.setPassword(_password);
    Config.setEnabledBiometrics(false);
    NavigationUtil.goInitEncryptPage(context);
  }
}