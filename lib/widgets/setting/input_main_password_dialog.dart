import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/application.dart';
import 'package:allpass/params/config.dart';
import 'package:allpass/utils/encrypt_util.dart';

class InputMainPasswordDialog extends StatelessWidget {

  final TextEditingController _passwordController = TextEditingController();
  final String helperText;

  InputMainPasswordDialog({this.helperText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("请输入主密码"),
      content: TextField(
        controller: _passwordController,
        obscureText: true,
        autofocus: true,
        onSubmitted: (_) => submit(context),
        decoration: InputDecoration(
          helperText: helperText,
          helperMaxLines: 5
        ),
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