import 'package:flutter/material.dart';

import 'package:allpass/core/param/config.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';

/// 修改密码对话框
class ModifyPasswordDialog extends StatelessWidget {

  final Key key;

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _secondInputController = TextEditingController();

  ModifyPasswordDialog({this.key}) : super(key: key);

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
            NoneBorderCircularTextField(
              editingController: _oldPasswordController,
              labelText: "请输入旧密码",
              obscureText: true,
              autoFocus: true,
            ),
            NoneBorderCircularTextField(
              editingController: _newPasswordController,
              labelText: "请输入新密码",
              obscureText: true,
            ),
            NoneBorderCircularTextField(
              editingController: _secondInputController,
              labelText: "请再输入一遍",
              obscureText: true,
            )
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
                ToastUtil.show(msg: "修改成功");
                Navigator.pop(context);
              } else {
                ToastUtil.show(msg: "密码过短或两次密码输入不一致！");
              }
            } else {
              ToastUtil.show(msg: "输入旧密码错误！");
            }
          },
        ),
        FlatButton(child: Text("取消"), onPressed: () => Navigator.pop(context))
      ],
    );
  }
}
