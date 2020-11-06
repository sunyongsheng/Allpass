import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/application.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';

class InputMainPasswordDialog extends StatelessWidget {

  final Key key;
  final String helperText;

  final TextEditingController _passwordController = TextEditingController();

  InputMainPasswordDialog({this.helperText, this.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      title: Text("请输入主密码"),
      content: NoneBorderCircularTextField(
        needPadding: false,
        editingController: _passwordController,
        autoFocus: true,
        helperText: helperText,
        obscureText: true,
        onEditingComplete: () => submit(context),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("确认"),
          onPressed: () => submit(context),
        ),
        FlatButton(
          child: Text("取消"),
          onPressed: () => Navigator.pop<bool>(context, false),
        )
      ],
    );
  }

  void submit(BuildContext context) {
    if (EncryptUtil.encrypt(_passwordController.text) == Config.password) {
      _passwordController.clear();
      Application.updateLatestUsePasswordTime();
      Navigator.pop<bool>(context, true);
    } else {
      Fluttertoast.showToast(msg: "密码错误");
      _passwordController.clear();
      Navigator.pop<bool>(context, false);
    }
  }

}