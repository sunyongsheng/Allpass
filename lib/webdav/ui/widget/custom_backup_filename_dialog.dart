import 'package:allpass/l10n/l10n_support.dart';
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
    var l10n = context.l10n;
    return AlertDialog(
      title: Text(
        l10n.modifyBackupFilename,
        style: AllpassTextUI.firstTitleStyle,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            NoneBorderCircularTextField(
              editingController: _passwordFilenameController,
              labelText: l10n.passwordBackupFilename,
              autoFocus: true,
            ),
            NoneBorderCircularTextField(
              editingController: _cardFilenameController,
              labelText: l10n.cardBackupFilename,
            ),
            NoneBorderCircularTextField(
              editingController: _extraFilenameController,
              labelText: l10n.extraBackupFilename,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            l10n.submit,
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
              ToastUtil.showError(msg: l10n.filenameNotAllowSame);
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
          child: Text(l10n.cancel),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }

  bool _validate(String text) {
    if (text.isEmpty) {
      ToastUtil.showError(msg: context.l10n.filenameNotAllowEmpty);
      return false;
    }

    if (containIllegalChar(text)) {
      ToastUtil.showError(msg: context.l10n.filenameRuleRequire);
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
