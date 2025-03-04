import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/material.dart';

import 'package:allpass/core/param/config.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/encrypt/encrypt_util.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';

/// 修改密码对话框
class ModifyPasswordDialog extends StatelessWidget {

  final Key? key;

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _secondInputController = TextEditingController();

  ModifyPasswordDialog({this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color mainColor = Theme.of(context).primaryColor;
    var l10n = context.l10n;
    return AlertDialog(
      title: Text(
        l10n.modifyMainPassword,
        style: AllpassTextUI.firstTitleStyle,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            NoneBorderCircularTextField(
              editingController: _oldPasswordController,
              labelText: l10n.oldPassword,
              hintText: l10n.pleaseInputOldPassword,
              obscureText: true,
              autoFocus: true,
            ),
            NoneBorderCircularTextField(
              editingController: _newPasswordController,
              labelText: l10n.newPassword,
              hintText: l10n.pleaseInputNewPassword,
              obscureText: true,
            ),
            NoneBorderCircularTextField(
              editingController: _secondInputController,
              labelText: l10n.newPassword,
              hintText: l10n.pleaseInputAgain,
              obscureText: true,
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(l10n.submit, style: TextStyle(color: mainColor)),
          onPressed: () async {
            if (Config.isPasswordCorrect(_oldPasswordController.text)) {
              if (_newPasswordController.text.length >= 6
                  && _newPasswordController.text == _secondInputController.text) {
                String newPassword = EncryptUtil.encrypt(_newPasswordController.text);
                Config.setPassword(newPassword);
                ToastUtil.show(msg: l10n.modifySuccess);
                Navigator.pop(context);
              } else {
                ToastUtil.showError(msg: l10n.modifyPasswordFail);
              }
            } else {
              ToastUtil.showError(msg: l10n.oldPasswordIncorrect);
            }
          },
        ),
        TextButton(
          child: Text(l10n.cancel, style: TextStyle(color: Colors.grey)),
          onPressed: () => Navigator.pop(context)
        )
      ],
    );
  }
}
