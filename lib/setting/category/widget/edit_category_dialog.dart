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

  late String categoryName;
  late String initialValue;

  bool _inputFormatCorr = true;
  late TextEditingController _editTextController;

  @override
  void initState() {
    super.initState();
    this.initialValue = widget.initialValue;
    this.categoryName = CategoryTypes.getCategoryName(widget.type);
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
    return AlertDialog(
      title: Text("编辑$categoryName"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          NoneBorderCircularTextField(
            editingController: _editTextController,
            errorText: _inputFormatCorr
                ? null
                : "$categoryName名不允许包含“,”或“~”或空格",
            hintText: "请输入$categoryName名",
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
          child: Text('提交', style: TextStyle(color: mainColor)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('取消', style: TextStyle(color: mainColor)),
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
      ToastUtil.showError(msg: "输入内容不合法，请勿包含“,”、“~”和空格");
    } else {
      Navigator.pop(context);
    }
  }
}