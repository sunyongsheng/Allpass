import 'package:flutter/material.dart';

import 'package:allpass/core/param/config.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';

class InputMainPasswordDialog extends StatelessWidget {

  final Key? key;
  final String? helperText;

  final void Function(bool)? onVerifyResult;
  final void Function()? onVerified;

  final TextEditingController _passwordController = TextEditingController();

  InputMainPasswordDialog({this.helperText, this.onVerified, this.onVerifyResult, this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color mainColor = Theme.of(context).primaryColor;
    return AlertDialog(
      title: Text("请输入主密码"),
      content: NoneBorderCircularTextField(
        needPadding: false,
        editingController: _passwordController,
        autoFocus: true,
        helperText: helperText,
        obscureText: true,
        onEditingComplete: () => _submit(context),
      ),
      actions: <Widget>[
        TextButton(
          child: Text("确认", style: TextStyle(color: mainColor)),
          onPressed: () => _submit(context),
        ),
        TextButton(
          child: Text("取消", style: TextStyle(color: mainColor)),
          onPressed: () {
            Navigator.pop<bool>(context, false);
            onVerifyResult?.call(false);
          },
        )
      ],
    );
  }

  void _submit(BuildContext context) {
    if (_passwordController.text.isEmpty) {
      ToastUtil.showError(msg: "请输入密码");
      return;
    }
    if (EncryptUtil.encrypt(_passwordController.text) == Config.password) {
      _passwordController.clear();
      Config.updateLatestUsePasswordTime();
      Navigator.pop<bool>(context, true);
      onVerifyResult?.call(true);
      onVerified?.call();
    } else {
      ToastUtil.show(msg: "密码错误");
      _passwordController.clear();
      Navigator.pop<bool>(context, false);
      onVerifyResult?.call(false);
    }
  }

}