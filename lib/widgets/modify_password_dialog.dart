import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/application.dart';
import 'package:allpass/params/params.dart';
import 'package:allpass/utils/allpass_ui.dart';

/// 修改密码对话框
class ModifyPasswordDialog extends StatelessWidget {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final secondInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      title: Text(
        "修改主密码",
        style: AllpassTextUI.firstTitleStyleBlack,
      ),
      content: Theme(
        data: ThemeData(primaryColor: AllpassColorUI.mainColor),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  controller: oldPasswordController,
                  decoration: InputDecoration(labelText: "请输入旧密码"),
                  obscureText: true,
                  autofocus: true,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  controller: newPasswordController,
                  decoration: InputDecoration(labelText: "请输入新密码"),
                  obscureText: true,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  controller: secondInputController,
                  decoration: InputDecoration(labelText: "请再输入一遍"),
                  obscureText: true,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("提交"),
          onPressed: () {
            if (Params.password == oldPasswordController.text) {
              if (newPasswordController.text.length >= 6
                  && newPasswordController.text == secondInputController.text) {
                Application.sp.setString(Params.username, newPasswordController.text);
                Fluttertoast.showToast(msg: "修改成功");
                Navigator.pop(context);
              } else {
                Fluttertoast.showToast(msg: "密码过短或两次密码输入不一致！");
              }
            } else {
              Fluttertoast.showToast(msg: "输入旧密码错误！");
            }
          },
        ),
        FlatButton(child: Text("取消"), onPressed: () => Navigator.pop(context))
      ],
    );
  }
}
