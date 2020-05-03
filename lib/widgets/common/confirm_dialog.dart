import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String _dialogMessage;
  final String _dialogTitle;

  ConfirmDialog(this._dialogTitle, this._dialogMessage);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_dialogTitle),
      content: Text(_dialogMessage),
      actions: <Widget>[
        FlatButton(
          child: Text("确认"),
          onPressed: () async {
            Navigator.pop<bool>(context, true);
          },
        ),
        FlatButton(
          child: Text("取消"),
          onPressed: () {
            Navigator.pop<bool>(context, false);
          },
        )
      ],
    );
  }


}