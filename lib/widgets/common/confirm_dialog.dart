import 'package:flutter/material.dart';

import 'package:allpass/utils/allpass_ui.dart';

class ConfirmDialog extends StatelessWidget {
  final String _dialogMessage;
  final String _dialogTitle;

  ConfirmDialog(this._dialogTitle, this._dialogMessage);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.all(Radius.circular(AllpassUI.smallBorderRadius),),
      ),
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