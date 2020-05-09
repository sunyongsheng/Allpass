import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/params/config.dart';
import 'package:allpass/ui/allpass_ui.dart';
import 'package:allpass/utils/encrypt_util.dart';

/// 修改密码对话框
class ModifyPasswordDialog extends StatelessWidget {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _secondInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "修改主密码",
        style: AllpassTextUI.firstTitleStyle,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                controller: _oldPasswordController,
                decoration: InputDecoration(labelText: "请输入旧密码"),
                obscureText: true,
                autofocus: true,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(labelText: "请输入新密码"),
                obscureText: true,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                controller: _secondInputController,
                decoration: InputDecoration(labelText: "请再输入一遍"),
                obscureText: true,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("提交"),
          onPressed: () async {
            if (Config.password == EncryptUtil.encrypt(_oldPasswordController.text)) {
              if (_newPasswordController.text.length >= 6
                  && _newPasswordController.text == _secondInputController.text) {
                String newPassword = EncryptUtil.encrypt(_newPasswordController.text);
                Config.setPassword(newPassword);
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
