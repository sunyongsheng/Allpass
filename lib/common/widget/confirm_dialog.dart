import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final bool danger;
  final String _dialogMessage;
  final String _dialogTitle;
  final void Function(bool)? onClick;
  final void Function()? onConfirm;

  ConfirmDialog(
    this._dialogTitle,
    this._dialogMessage, {
    Key? key,
    this.danger = false,
    this.onClick,
    this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color mainColor;
    if (danger) {
      mainColor = Colors.red;
    } else {
      mainColor = Theme.of(context).primaryColor;
    }
    return AlertDialog(
      title: Text(_dialogTitle),
      content: Text(_dialogMessage),
      actions: <Widget>[
        TextButton(
          child: Text(context.l10n.confirm, style: TextStyle(color: mainColor),),
          onPressed: () async {
            Navigator.pop<bool>(context, true);
            onClick?.call(true);
            onConfirm?.call();
          },
        ),
        TextButton(
          child: Text(context.l10n.cancel, style: TextStyle(color: Colors.grey)),
          onPressed: () {
            Navigator.pop<bool>(context, false);
            onClick?.call(false);
          },
        )
      ],
    );
  }


}