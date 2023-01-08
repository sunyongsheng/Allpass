import 'package:allpass/common/widget/none_border_circular_textfield.dart';
import 'package:flutter/material.dart';

class EditTextDialog extends StatelessWidget {
  final String dialogTitle;
  final String initialText;
  final ValueSetter<String>? onConfirm;
  final VoidCallback? onCancel;

  final TextEditingController _editingController = TextEditingController();

  EditTextDialog(
      {Key? key,
      required this.dialogTitle,
      required this.initialText,
      this.onConfirm,
      this.onCancel})
      : super(key: key) {
    _editingController.text = initialText;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(dialogTitle),
      content: NoneBorderCircularTextField(
        needPadding: false,
        editingController: _editingController,
        autoFocus: true,
        obscureText: false,
        onEditingComplete: () => _submit(context, _editingController.text),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            "确认",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onPressed: () => _submit(context, _editingController.text),
        ),
        TextButton(
          child: Text("取消", style: TextStyle(color: Colors.grey)),
          onPressed: () {
            Navigator.pop(context);
            onCancel?.call();
          },
        )
      ],
    );
  }

  void _submit(BuildContext context, String text) {
    Navigator.pop<String>(context, text);
    onConfirm?.call(text);
  }
}
