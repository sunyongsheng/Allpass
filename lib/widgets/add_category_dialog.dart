import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/params/params.dart';
import 'package:allpass/utils/allpass_ui.dart';

/// 添加属性对话框
class AddCategoryDialog extends StatefulWidget {

  final String categoryName;

  AddCategoryDialog(this.categoryName);

  @override
  _AddLabelDialog createState() {
    return _AddLabelDialog(categoryName);
  }

}

class _AddLabelDialog extends State<AddCategoryDialog> {

  var _addTextController = TextEditingController();
  bool _inputFormatCorr = true;

  final String categoryName;

  _AddLabelDialog(this.categoryName);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("新建$categoryName"),
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.all(Radius.circular(15),),
      ),
      content: Theme(
        data: ThemeData(primaryColor: AllpassColorUI.mainColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                  errorText: _inputFormatCorr?"":"$categoryName名不允许包含“,”或“~”或空格",
              ),
              controller: _addTextController,
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
              }
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            if (_inputFormatCorr && _addTextController.text != "") {
              if (categoryName == "标签") {
                if (Params.labelListAdd([_addTextController.text])) {
                  Fluttertoast.showToast(msg: "添加$categoryName ${_addTextController.text}");
                } else {
                  Fluttertoast.showToast(msg: "$categoryName ${_addTextController.text} 已存在");
                }
              } else {
                if (Params.folderListAdd(_addTextController.text)) {
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
          },
          child: Text('提交'),
          textColor: AllpassColorUI.mainColor,
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
            _addTextController.clear();
          },
          child: Text('取消'),
          textColor: AllpassColorUI.mainColor,
        ),
      ],
    );
  }
}