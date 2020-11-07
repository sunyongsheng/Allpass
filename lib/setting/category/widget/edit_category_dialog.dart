import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:allpass/core/param/allpass_type.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';

/// 编辑属性对话框
/// 返回[null]代表未编辑；否则返回修改后的数据
class EditCategoryDialog extends StatefulWidget {

  final Key key;
  final CategoryType type;
  final String initialValue;

  EditCategoryDialog(this.type, this.initialValue, {this.key}) : super(key: key);

  @override
  _EditCategoryDialog createState() {
    return _EditCategoryDialog();
  }

}

class _EditCategoryDialog extends State<EditCategoryDialog> {

  String categoryName;
  String initialValue;

  bool _inputFormatCorr = true;
  TextEditingController _editTextController;

  @override
  void initState() {
    super.initState();
    this.initialValue = widget.initialValue;
    this.categoryName = Category.getCategoryName(widget.type);
    _editTextController = TextEditingController(text: initialValue);
  }

  @override
  void dispose() {
    super.dispose();
    _editTextController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        FlatButton(
          onPressed: () => _submit(),
          child: Text('提交'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('取消'),
        ),
      ],
    );
  }

  void _submit() {
    if (_inputFormatCorr && (_editTextController.text?.trim()?.length ?? 0) > 0) {
      if (_editTextController.text != initialValue) {
        Navigator.pop<String>(context, _editTextController.text);
      } else {
        Navigator.pop(context);
      }
    } else if (!_inputFormatCorr) {
      Fluttertoast.showToast(msg: "输入内容不合法，请勿包含“,”、“~”和空格");
    } else {
      Navigator.pop(context);
    }
  }
}