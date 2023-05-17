import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/material.dart';

import 'package:allpass/core/param/config.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/encrypt/encrypt_util.dart';
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
    var l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.pleaseInputMainPassword),
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
          child: Text(l10n.confirm, style: TextStyle(color: mainColor)),
          onPressed: () => _submit(context),
        ),
        TextButton(
          child: Text(l10n.cancel, style: TextStyle(color: mainColor)),
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
      ToastUtil.showError(msg: context.l10n.pleaseInputMainPassword);
      return;
    }
    if (EncryptUtil.encrypt(_passwordController.text) == Config.password) {
      _passwordController.clear();
      Config.updateLatestUsePasswordTime();
      Navigator.pop<bool>(context, true);
      onVerifyResult?.call(true);
      onVerified?.call();
    } else {
      ToastUtil.show(msg: context.l10n.mainPasswordIncorrect);
      _passwordController.clear();
      Navigator.pop<bool>(context, false);
      onVerifyResult?.call(false);
    }
  }

}