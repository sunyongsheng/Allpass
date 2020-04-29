import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:allpass/application.dart';
import 'package:allpass/params/param.dart';
import 'package:allpass/params/config.dart';
import 'package:allpass/utils/encrypt_util.dart';
import 'package:allpass/utils/navigation_util.dart';
import 'package:allpass/ui/allpass_ui.dart';
import 'package:allpass/utils/screen_util.dart';
import 'package:allpass/widgets/common/none_border_circular_textfield.dart';
import 'package:allpass/pages/login/login_page.dart';

class RegisterPage extends StatelessWidget {
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
                _usernameController,
                "请输入用户名",
                null,
                false,
                null
              ),
              NoneBorderCircularTextField(
                _passwordController,
                "请输入密码",
                null,
                true,
                null
              ),
              NoneBorderCircularTextField(
                _secondController,
                "请再输入一遍",
                null,
                true,
                null
              ),
              Padding(
                padding: AllpassEdgeInsets.smallTBPadding,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(AllpassUI.bigBorderRadius))
                  ),
                  child: Text("注册", style: TextStyle(color: Colors.white, fontSize: 15),),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => register(context),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: AllpassScreenUtil.setHeight(300)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
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

  void register(BuildContext context) {
    if (_passwordController.text != _secondController.text) {
      Fluttertoast.showToast(msg: "两次密码输入不一致！");
      return;
    }
    // 判断是否已有账号存在
    if (Application.sp.getString(SharedPreferencesKeys.username) == "") {
      // 判断用户名和密码长度
      if (_usernameController.text.length >= 6 && _passwordController.text.length >= 6) {
        String _password = EncryptUtil.encrypt(_passwordController.text);
        Application.sp.setString(SharedPreferencesKeys.username, _usernameController.text);
        Application.sp.setString(SharedPreferencesKeys.password, _password);
        Config.username = _usernameController.text;
        Config.password = _password;
        Config.enabledBiometrics = false;
        Fluttertoast.showToast(msg: "注册成功");
        NavigationUtil.goLoginPage(context);
      } else {
        Fluttertoast.showToast(msg: "用户名或密码长度必须大于等于6！");
      }
    } else {
      Fluttertoast.showToast(msg: "已有账号注册过，只允许单账号");
    }
  }
}