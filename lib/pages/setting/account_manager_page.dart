import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/application.dart';
import 'package:allpass/params/params.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/navigation_utils.dart';
import 'package:allpass/widgets/modify_password_dialog.dart';
import 'package:allpass/dao/card_dao.dart';
import 'package:allpass/dao/password_dao.dart';

/// 主账号管理页
class AccountManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccountManagerPage();
  }
}

class _AccountManagerPage extends State<AccountManagerPage> {

  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "主账号管理",
          style: AllpassTextUI.mainTitleStyle,
        ),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        elevation: 0,
        brightness: Brightness.light,
      ),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: ListTile(
              title: Text("修改主密码"),
              leading: Icon(Icons.lock_open),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => ModifyPasswordDialog());
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: ListTile(
              title: Text("清除所有数据"),
              leading: Icon(Icons.clear),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    title: Text("确认清除"),
                    content: Text("此操作将删除所有记录，确认继续吗？"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("确认", style: AllpassTextUI.secondTitleStyleBlue,),
                        onPressed: () {
                          // 二次确认
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              title: Text("请输入主密码"),
                              content: TextField(
                                controller: passwordController,
                                obscureText: true,
                                autofocus: true,
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("确认", style: AllpassTextUI.secondTitleStyleBlue,),
                                  onPressed: () {
                                    if (passwordController.text == Params.password) {
                                      PasswordDao().deleteContent();
                                      CardDao().deleteContent();
                                      Application.sp.clear();
                                      Params.paramsClear();
                                      Fluttertoast.showToast(msg: "已删除所有数据");
                                      passwordController.clear();
                                      NavigationUtils.goLoginPage(context);
                                    } else {
                                      Fluttertoast.showToast(msg: "密码错误");
                                      Navigator.pop(context);
                                      passwordController.clear();
                                    }
                                  },
                                ),
                                FlatButton(
                                  child: Text("取消", style: AllpassTextUI.secondTitleStyleBlue,),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            )
                          );
                        },
                      ),
                      FlatButton(
                        child: Text("取消", style: AllpassTextUI.secondTitleStyleBlue,),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  )
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: ListTile(
              title: Text("退出"),
              leading: Icon(Icons.exit_to_app),
              onTap: () => Params.enabledBiometrics
                  ? NavigationUtils.goAuthLoginPage(context)
                  : NavigationUtils.goLoginPage(context),
            ),
          )
        ],
      ),
    );
  }
}
