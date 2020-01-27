import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/params/params.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/encrypt_util.dart';

class InputMainPasswordDialog extends StatelessWidget {

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AllpassUI.smallBorderRadius),
        ),
      ),
      title: Text("请输入主密码"),
      content: TextField(
        controller: _passwordController,
        obscureText: true,
        autofocus: true,
        onSubmitted: (_) => submit(context),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("确认", style: AllpassTextUI.secondTitleStyleBlue,),
          onPressed: () => submit(context),
        ),
        FlatButton(
          child: Text("取消", style: AllpassTextUI.secondTitleStyleBlue,),
          onPressed: () => Navigator.pop<bool>(context, false),
        )
      ],
    );
  }

  void submit(BuildContext context) {
    if (EncryptUtil.encrypt(_passwordController.text) == Params.password) {
      _passwordController.clear();
      Navigator.pop<bool>(context, true);
    } else {
      Fluttertoast.showToast(msg: "密码错误");
      _passwordController.clear();
      Navigator.pop<bool>(context, false);
    }
  }

}