import 'package:allpass/ui/allpass_ui.dart';
import 'package:allpass/widgets/common/none_border_circular_textfield.dart';
import 'package:flutter/material.dart';

class ModifyWebDavFileName extends StatelessWidget {

  final _passwordFileNameController = TextEditingController();
  final _cardFileNameController = TextEditingController();

  final String oldPasswordName;
  final String oldCardName;

  ModifyWebDavFileName({this.oldCardName, this.oldPasswordName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "修改备份文件名",
        style: AllpassTextUI.firstTitleStyle,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            NoneBorderCircularTextField(
              editingController: _passwordFileNameController,
              labelText: "密码备份文件名",
              hintText: oldPasswordName,
              autoFocus: true,
            ),
            NoneBorderCircularTextField(
              editingController: _cardFileNameController,
              labelText: "卡片备份文件名",
              hintText: oldCardName,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("提交"),
          onPressed: () async {
            String password = _passwordFileNameController.text;
            String card = _cardFileNameController.text;
            Map<String, String> res = Map();
            if (password.trim().length == 0) {
              password = oldPasswordName;
            }
            if (card.trim().length == 0) {
              card = oldCardName;
            }
            if (!containIllegalChar(password)) {
              res['password'] = password;
            } else {
              Navigator.pop(context, "文件名中不能含有\\/:*?\"<>|");
              return;
            }
            if (!containIllegalChar(card)) {
              res['card'] = card;
            } else {
              Navigator.pop(context, "文件名中不能含有\\/:*?\"<>|");
              return;
            }
            Navigator.pop(context, res);
          },
        ),
        FlatButton(child: Text("取消"), onPressed: () => Navigator.pop(context, false))
      ],
    );
  }

  bool containIllegalChar(String string) {
    return string.contains("\\") || string.contains("/") || string.contains("?")
        || string.contains("|") || string.contains(":") || string.contains("*")
        || string.contains("<") || string.contains(">");
  }
}