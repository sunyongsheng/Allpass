import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/material.dart';
import 'package:allpass/core/enums/category_type.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';

/// 添加属性对话框
class AddCategoryDialog extends StatefulWidget {

  final Key? key;
  final CategoryType type;

  AddCategoryDialog({this.key, this.type = CategoryType.label}) : super(key: key);

  @override
  _AddLabelDialog createState() {
    return _AddLabelDialog();
  }

}

class _AddLabelDialog extends State<AddCategoryDialog> {

  var _addTextController = TextEditingController();
  bool _inputFormatCorr = true;
  late CategoryType type;

  @override
  void initState() {
    super.initState();
    this.type = widget.type;
  }

  @override
  void dispose() {
    super.dispose();
    _addTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color mainColor = Theme.of(context).primaryColor;
    var l10n = context.l10n;
    var categoryName = type.title(context);
    return AlertDialog(
      title: Text(l10n.createCategory(categoryName)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          NoneBorderCircularTextField(
            autoFocus: true,
            editingController: _addTextController,
            errorText: _inputFormatCorr
                ? null
                : l10n.categoryNameRuleRequire(type.title(context)),
            needPadding: false,
            hintText: l10n.pleaseInputCategoryName(type.title(context)),
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
            onEditingComplete: () => submit(),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => submit(),
          child: Text(l10n.submit, style: TextStyle(color: mainColor)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }

  void submit() {
    if (_inputFormatCorr && ((_addTextController.text.trim().length)) > 0) {
      Navigator.pop<String>(context, _addTextController.text);
    } else if (!_inputFormatCorr) {
      ToastUtil.showError(msg: context.l10n.categoryNameNotValid);
    } else {
      ToastUtil.showError(msg: context.l10n.categoryNameNotAllowEmpty);
    }
  }
}