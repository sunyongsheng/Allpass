import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final Key key;
  final bool danger;
  final String _dialogMessage;
  final String _dialogTitle;

  ConfirmDialog(this._dialogTitle, this._dialogMessage, {this.key, this.danger = false}) : super(key: key);

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
          child: Text("确认", style: TextStyle(color: mainColor),),
          onPressed: () async {
            Navigator.pop<bool>(context, true);
          },
        ),
        TextButton(
          child: Text("取消", style: TextStyle(color: Colors.grey)),
          onPressed: () {
            Navigator.pop<bool>(context, false);
          },
        )
      ],
    );
  }


}