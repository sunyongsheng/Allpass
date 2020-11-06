import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:allpass/core/param/allpass_type.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';

/// 添加属性对话框
class AddCategoryDialog extends StatefulWidget {

  final Key key;
  final CategoryType type;

  AddCategoryDialog({this.key, this.type = CategoryType.Label});

  @override
  _AddLabelDialog createState() {
    return _AddLabelDialog();
  }

}

class _AddLabelDialog extends State<AddCategoryDialog> {

  var _addTextController = TextEditingController();
  bool _inputFormatCorr = true;
  String categoryName;
  CategoryType type;

  @override
  void initState() {
    super.initState();
    this.type = widget.type;
    this.categoryName = Category.getCategoryName(type);
  }

  @override
  void dispose() {
    super.dispose();
    _addTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: widget.key,
      title: Text("新建$categoryName"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          NoneBorderCircularTextField(
            autoFocus: true,
            editingController: _addTextController,
            errorText: _inputFormatCorr
                ? null
                : "$categoryName名不允许包含“,”或“~”或空格",
            needPadding: false,
            hintText: "请输入$categoryName名",
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
        FlatButton(
          onPressed: () => submit(),
          child: Text('提交'),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('取消'),
        ),
      ],
    );
  }

  void submit() {
    if (_inputFormatCorr && ((_addTextController.text?.trim()?.length) ?? 0) > 0) {
      Navigator.pop<String>(context, _addTextController.text);
    } else {
      Fluttertoast.showToast(msg: "输入内容不合法");
    }
  }
}