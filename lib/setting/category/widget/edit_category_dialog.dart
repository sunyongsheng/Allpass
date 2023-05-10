import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/material.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/core/enums/category_type.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';

/// 编辑属性对话框
/// 返回[null]代表未编辑；否则返回修改后的数据
class EditCategoryDialog extends StatefulWidget {

  final Key? key;
  final CategoryType type;
  final String initialValue;

  EditCategoryDialog(this.type, this.initialValue, {this.key}) : super(key: key);

  @override
  _EditCategoryDialog createState() {
    return _EditCategoryDialog();
  }

}

class _EditCategoryDialog extends State<EditCategoryDialog> {

  late String initialValue;

  bool _inputFormatCorr = true;
  late TextEditingController _editTextController;

  @override
  void initState() {
    super.initState();
    this.initialValue = widget.initialValue;
    _editTextController = TextEditingController(text: initialValue);
  }

  @override
  void dispose() {
    super.dispose();
    _editTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color mainColor = Theme.of(context).primaryColor;
    var categoryName = widget.type.title(context);
    var l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.updateCategory(categoryName)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          NoneBorderCircularTextField(
            editingController: _editTextController,
            errorText: _inputFormatCorr
                ? null
                : l10n.categoryNameRuleRequire(categoryName),
            hintText: l10n.pleaseInputCategoryName(categoryName),
            needPadding: false,
            autoFocus: true,
            onChanged: (text) {
              if (text.contains(",") || text.contains("~") || text.contains(" ")) {
                setState(() {
                  _inputFormatCorr = false;
                });
              } else {
                setState(() {
                  _inputFormatCorr = true;
                });
              }
            },
            onEditingComplete: () => _submit(),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => _submit(),
          child: Text(l10n.submit, style: TextStyle(color: mainColor)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(l10n.cancel),
        ),
      ],
    );
  }

  void _submit() {
    if (_inputFormatCorr && (_editTextController.text.trim().length) > 0) {
      if (_editTextController.text != initialValue) {
        Navigator.pop<String>(context, _editTextController.text);
      } else {
        Navigator.pop(context);
      }
    } else if (!_inputFormatCorr) {
      ToastUtil.showError(msg: context.l10n.categoryNameNotValid);
    } else {
      ToastUtil.showError(msg: context.l10n.categoryNameNotAllowEmpty);
    }
  }
}