import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:allpass/application.dart';
import 'package:allpass/params/params.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/navigation_util.dart';
import 'package:allpass/utils/encrypt_helper.dart';
import 'package:allpass/utils/screen_util.dart';
import 'package:allpass/provider/card_list.dart';
import 'package:allpass/provider/password_list.dart';

/// 登陆页面
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  var _usernameController;
  var _passwordController;

  int inputErrorTimes = 0; // 超过五次自动清除所有内容

  @override
  void initState() {
    _usernameController = TextEditingController(text: Params.username);
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        elevation: 0,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: AllpassScreenUtil.setHeight(500)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              margin: AllpassEdgeInsets.dividerInset,
              elevation: 8,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        left: AllpassScreenUtil.setWidth(100),
                        right: AllpassScreenUtil.setWidth(100),
                        top: 10,
                        bottom: 10),
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                          labelText: "用户名", prefixIcon: Icon(Icons.person)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: AllpassScreenUtil.setWidth(100),
                        right: AllpassScreenUtil.setWidth(100),
                        top: 10,
                        bottom: 10),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: "密码",
                      ),
                      onSubmitted: (_) => login(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                  )
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: AllpassScreenUtil.setHeight(100)),),
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)
              ),
              padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
              child: Text("登录", style: TextStyle(color: Colors.white, fontSize: 16)),
              color: AllpassColorUI.mainColor,
              onPressed: () => login(),
            ),
            Padding(
              padding: EdgeInsets.only(top: AllpassScreenUtil.setHeight(300)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text("注册"),
                  onPressed: () => register(),
                ),
                Text("|"),
                FlatButton(
                  child: Text("使用生物识别"),
                  onPressed: () {
                    NavigationUtil.goAuthLoginPage(context);
                  },
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: AllpassScreenUtil.setHeight(80)),)
          ],
        ),
      ),
    );
  }

  void register() async {
    // 判断是否已有账号存在
    if (Application.sp.getString("username") == null) {
      // 判断用户名和密码长度
      if (_usernameController.text.length >= 6 && _passwordController.text.length >= 6) {
        String _password = await EncryptHelper.encrypt(_passwordController.text);
        Application.sp.setString("username", _usernameController.text);
        Application.sp.setString("password", _password);
        Params.username = _usernameController.text;
        Params.password = _password;
        Params.enabledBiometrics = false;
        inputErrorTimes = 0;
        Fluttertoast.showToast(msg: "注册成功");
      } else {
        Fluttertoast.showToast(msg: "用户名或密码长度必须大于等于6！");
      }
    } else {
      Fluttertoast.showToast(msg: "已有账号注册过，只允许单账号");
    }
  }

  login() async {
    if (inputErrorTimes >= 5) {
      Provider.of<PasswordList>(context).clear();
      Provider.of<CardList>(context).clear();
      Params.paramsClear();
      await Application.sp.clear();
      Fluttertoast.showToast(msg: "连续错误超过五次！已清除所有数据，请重新注册");
    } else {
      if (Params.username != "" && Params.password != "") {
        if (Params.username == _usernameController.text
            && _passwordController.text == await EncryptHelper.decrypt(Params.password)) {
          NavigationUtil.goHomePage(context);
          Fluttertoast.showToast(msg: "登录成功");
        } else if (_usernameController.text == "" || _passwordController.text == "") {
          Fluttertoast.showToast(msg: "请输入用户名或密码");
        } else {
          inputErrorTimes++;
          Fluttertoast.showToast(msg: "用户名或密码错误，已错误$inputErrorTimes次，连续超过五次将删除所有数据！");
        }
      } else {
        Fluttertoast.showToast(msg: "当前不存在用户，请先注册！");
      }
    }
  }
}
