import 'package:allpass/util/toast_util.dart';
import 'package:allpass/webdav/backup/custom_backup_filename.dart';
import 'package:flutter/material.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';

class WebDavCustomBackupFilenameDialog extends StatefulWidget {
  final WebDavCustomBackupFilename? filename;
  final void Function(WebDavCustomBackupFilename) onSubmit;

  const WebDavCustomBackupFilenameDialog({
    Key? key,
    this.filename,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State createState() {
    return WebDavCustomBackupFilenameState();
  }
}

class WebDavCustomBackupFilenameState extends State<WebDavCustomBackupFilenameDialog> {

  late final TextEditingController _passwordFilenameController;
  late final TextEditingController _cardFilenameController;
  late final TextEditingController _extraFilenameController;

  @override
  void initState() {
    super.initState();

    _passwordFilenameController = TextEditingController(text: widget.filename?.passwordName);
    _cardFilenameController = TextEditingController(text: widget.filename?.cardName);
    _extraFilenameController = TextEditingController(text: widget.filename?.extraName);
  }

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
              editingController: _passwordFilenameController,
              labelText: "密码备份文件名",
              autoFocus: true,
            ),
            NoneBorderCircularTextField(
              editingController: _cardFilenameController,
              labelText: "卡片备份文件名",
            ),
            NoneBorderCircularTextField(
              editingController: _extraFilenameController,
              labelText: "标签文件夹备份文件名",
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            "提交",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          onPressed: () async {
            String password = _passwordFilenameController.text;
            if (!_validate(password)) {
              return;
            }

            String card = _cardFilenameController.text;
            if (!_validate(card)) {
              return;
            }

            String extra = _extraFilenameController.text;
            if (!_validate(extra)) {
              return;
            }

            if (password == card || password == extra || card == extra) {
              ToastUtil.showError(msg: "文件名不能相同");
              return;
            }

            widget.onSubmit(WebDavCustomBackupFilename(
              passwordName: password,
              cardName: card,
              extraName: extra,
            ));
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text("取消"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }

  bool _validate(String text) {
    if (text.isEmpty) {
      ToastUtil.showError(msg: "文件名不能为空");
      return false;
    }

    if (containIllegalChar(text)) {
      ToastUtil.showError(msg: "文件名中不能含有\\/:*?\"<>|");
      return false;
    }

    return true;
  }

  bool containIllegalChar(String string) {
    return string.contains("\\") ||
        string.contains("/") ||
        string.contains("?") ||
        string.contains("|") ||
        string.contains(":") ||
        string.contains("*") ||
        string.contains("<") ||
        string.contains(">");
  }
}
