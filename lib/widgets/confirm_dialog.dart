import 'package:flutter/material.dart';

import 'package:allpass/utils/allpass_ui.dart';

class ConfirmDialog extends StatelessWidget {
  final String message;
  ConfirmDialog(this.message);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.all(Radius.circular(AllpassUI.borderRadius),),
      ),
      title: Text("确认删除"),
      content: Text(message),
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