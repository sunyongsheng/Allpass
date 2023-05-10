import 'package:allpass/common/widget/none_border_circular_textfield.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/material.dart';

class EditTextDialog extends StatefulWidget {
  final String dialogTitle;
  final String initialText;
  final String? helpText;
  final bool Function(String)? validator;
  final ValueSetter<String>? onConfirm;
  final VoidCallback? onCancel;

  EditTextDialog({
    Key? key,
    required this.dialogTitle,
    required this.initialText,
    this.onConfirm,
    this.onCancel,
    this.helpText,
    this.validator,
  }) : super(key: key);

  @override
  State<EditTextDialog> createState() {
    return _EditTextDialogState();
  }
}

class _EditTextDialogState extends State<EditTextDialog> {

  final TextEditingController _editingController = TextEditingController();

  bool _confirmEnable = true;

  @override
  void initState() {
    super.initState();
    _editingController.text = widget.initialText;
    _confirmEnable = widget.validator?.call(widget.initialText) != false;
  }

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;
    return AlertDialog(
      title: Text(widget.dialogTitle),
      content: SingleChildScrollView(
        child: Column(children: _content(context)),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            l10n.confirm,
            style: _confirmEnable
                ? TextStyle(color: Theme.of(context).primaryColor)
                : TextStyle(color: Colors.grey),
          ),
          onPressed: () => _submit(context, _editingController.text),
        ),
        TextButton(
          child: Text(l10n.cancel, style: TextStyle(color: Colors.grey)),
          onPressed: () {
            Navigator.pop(context);
            widget.onCancel?.call();
          },
        )
      ],
    );
  }

  List<Widget> _content(BuildContext context) {
    List<Widget> widgetList = [];
    if (widget.helpText != null) {
      widgetList.add(Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Text(
          widget.helpText!,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
        ),
      ));
    }
    widgetList.add(NoneBorderCircularTextField(
      needPadding: false,
      editingController: _editingController,
      autoFocus: true,
      obscureText: false,
      onEditingComplete: () => _submit(context, _editingController.text),
      onChanged: (text) {
        if (widget.validator == null) {
          return;
        }

        setState(() {
          _confirmEnable = widget.validator!.call(text);
        });
      },
    ));
    return widgetList;
  }

  void _submit(BuildContext context, String text) {
    if (widget.validator?.call(text) == false) {
      return;
    }

    Navigator.pop<String>(context, text);
    widget.onConfirm?.call(text);
  }
}
