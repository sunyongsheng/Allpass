import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/application.dart';
import 'package:allpass/params/params.dart';
import 'package:allpass/dao/card_dao.dart';
import 'package:allpass/dao/password_dao.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/navigation_utils.dart';


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

  int inputErrorTimes = 0;  // 超过五次自动清除所有内容

  @override
  void initState() {
    _usernameController = TextEditingController(text: Params.username);
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        elevation: 0,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            margin: EdgeInsets.only(left: 20, right: 20),
            elevation: 8,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                        labelText: "用户名",
                        prefixIcon: Icon(Icons.person)
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: "密码",
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text("登录"),
                      color: Colors.grey[200],
                      onPressed: () {
                        if (inputErrorTimes >= 5) {
                          PasswordDao().deleteContent();
                          CardDao().deleteContent();
                          Fluttertoast.showToast(msg: "连续错误超过五次！已清除所有数据，请重新注册");
                          Application.sp.clear();
                        } else {
                          if (Application.sp.containsKey(_usernameController.text)) {
                            if (_passwordController.text == Application.sp.getString(_usernameController.text)) {
                              NavigationUtils.goHomePage(context);
                              Fluttertoast.showToast(msg: "登录成功");
                            } else {
                              inputErrorTimes++;
                              Fluttertoast.showToast(msg: "密码错误，已错误$inputErrorTimes次，连续超过五次将删除所有数据！");
                            }
                          } else {
                            inputErrorTimes++;
                            Fluttertoast.showToast(msg: "用户名错误，已错误$inputErrorTimes次，连续超过五次将删除所有数据！");
                          }
                        }
                      },
                    ),
                    FlatButton(
                      child: Text("注册"),
                      onPressed: () {
                        // 判断是否已有账号存在，sp中已有folder和label两个key
                        if (Application.sp.getKeys().length < 3) {
                          // 判断用户名和密码长度
                          if (_usernameController.text.length >= 3 && _passwordController.text.length >= 3) {
                            // 判断是否与其他key重复
                            if (!Application.sp.containsKey(_usernameController.text)) {
                              Application.sp.setString(_usernameController.text, _passwordController.text);
                              Params.username = _usernameController.text;
                              inputErrorTimes = 0;
                              Fluttertoast.showToast(msg: "注册成功");
                            } else {
                              Fluttertoast.showToast(msg: "用户名不允许为folder和label！");
                            }
                          } else {
                            Fluttertoast.showToast(msg: "用户名或密码长度必须大于3！");
                          }
                        } else {
                          Fluttertoast.showToast(msg: "已有账号注册过，只允许单账号");
                        }
                      },
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}