import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:allpass/params/runtime_data.dart';
import 'package:allpass/widgets/common/none_border_circular_textfield.dart';

/// 添加属性对话框
class AddCategoryDialog extends StatefulWidget {

  final String categoryName;

  AddCategoryDialog(this.categoryName);

  @override
  _AddLabelDialog createState() {
    return _AddLabelDialog();
  }

}

class _AddLabelDialog extends State<AddCategoryDialog> {

  var _addTextController = TextEditingController();
  bool _inputFormatCorr = true;
  String categoryName;

  @override
  void initState() {
    categoryName = widget.categoryName;
    super.initState();
  }

  @override
  void didUpdateWidget(AddCategoryDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    categoryName = widget.categoryName;
  }

  @override
  void dispose() {
    _addTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("新建$categoryName"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          NoneBorderCircularTextField(
            autoFocus: true,
            editingController: _addTextController,
            errorText: _inputFormatCorr?"":"$categoryName名不允许包含“,”或“~”或空格",
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
          onPressed: () {
            Navigator.of(context).pop();
            _addTextController.clear();
          },
          child: Text('取消'),
        ),
      ],
    );
  }

  void submit() {
    if (_inputFormatCorr && _addTextController.text != "") {
      if (categoryName == "标签") {
        if (RuntimeData.labelListAdd([_addTextController.text])) {
          Fluttertoast.showToast(msg: "添加$categoryName ${_addTextController.text}");
        } else {
          Fluttertoast.showToast(msg: "$categoryName ${_addTextController.text} 已存在");
        }
      } else {
        if (RuntimeData.folderListAdd(_addTextController.text)) {
          Fluttertoast.showToast(msg: "添加$categoryName ${_addTextController.text}");
        } else {
          Fluttertoast.showToast(msg: "$categoryName ${_addTextController.text} 已存在");
        }
      }
      _addTextController.clear();
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: "输入内容不合法");
    }
  }
}