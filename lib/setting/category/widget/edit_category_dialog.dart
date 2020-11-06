import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';

/// 编辑属性对话框
class EditCategoryDialog extends StatefulWidget {

  final Key key;
  final String categoryName;
  final int index;

  EditCategoryDialog(this.categoryName, this.index, {this.key});

  @override
  _EditCategoryDialog createState() {
    return _EditCategoryDialog();
  }

}

class _EditCategoryDialog extends State<EditCategoryDialog> {

  String categoryName;

  var _editTextController;

  bool _inputFormatCorr = true;
  int _index;

  @override
  void initState() {
    super.initState();
    this.categoryName = widget.categoryName;
    this._index = widget.index;

    if (categoryName == "标签")
      _editTextController = TextEditingController(text: RuntimeData.labelList[_index]);
    else
      _editTextController = TextEditingController(text: RuntimeData.folderList[_index]);
  }

  @override
  void dispose() {
    super.dispose();
    _editTextController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: widget.key,
      title: Text("编辑$categoryName"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          NoneBorderCircularTextField(
            editingController: _editTextController,
            errorText: _inputFormatCorr?"":"$categoryName名不允许包含“,”或“~”或空格",
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
            Navigator.pop<bool>(context, false);
          },
          child: Text('取消'),
        ),
      ],
    );
  }

  _submit() async {
    if (_inputFormatCorr && _editTextController.text != "") {
      if (categoryName == "标签") {
        if (!RuntimeData.labelList.contains(_editTextController.text)) {
          await editLabelAndUpdate();
          Fluttertoast.showToast(msg: "保存$categoryName ${_editTextController.text}");
          Navigator.pop<bool>(context, true);
        } else {
          Fluttertoast.showToast(msg: "$categoryName ${_editTextController.text} 已存在");
          Navigator.pop<bool>(context, false);
        }
      } else {
        if (!RuntimeData.folderList.contains(_editTextController.text)) {
          await editFolderAndUpdate();
          Fluttertoast.showToast(msg: "保存$categoryName ${_editTextController.text}");
          Navigator.pop<bool>(context, true);
        } else {
          Fluttertoast.showToast(msg: "$categoryName ${_editTextController.text} 已存在");
          Navigator.pop<bool>(context, false);
        }
      }
    } else {
      Fluttertoast.showToast(msg: "输入内容不合法，请勿包含“,”、“~”和空格");
    }
  }

  editLabelAndUpdate() async {
    List<PasswordBean> passwordList = Provider.of<PasswordProvider>(context).passwordList;
    if (passwordList != null) {
      for (var bean in passwordList) {
        if (bean.label.contains(RuntimeData.labelList[_index])) {
          bean.label.remove(RuntimeData.labelList[_index]);
          bean.label.add(_editTextController.text);
          await Provider.of<PasswordProvider>(context).updatePassword(bean);
        }
      }
    }
    List<CardBean> cardList = Provider.of<CardProvider>(context).cardList;
    if (cardList != null) {
      for (var bean in cardList) {
        if (bean.label.contains(RuntimeData.labelList[_index])) {
          bean.label.remove(RuntimeData.labelList[_index]);
          bean.label.add(_editTextController.text);
          await Provider.of<CardProvider>(context).updateCard(bean);
        }
      }
    }
    RuntimeData.labelList[_index] = _editTextController.text;
    RuntimeData.labelParamsPersistence();
  }

  editFolderAndUpdate() async {
    List<PasswordBean> passwordList = Provider.of<PasswordProvider>(context).passwordList;
    if (passwordList != null) {
      for (var bean in passwordList) {
        if (bean.folder == RuntimeData.folderList[_index]) {
          bean.folder = _editTextController.text;
          await Provider.of<PasswordProvider>(context).updatePassword(bean);
        }
      }
    }
    List<CardBean> cardList = Provider.of<CardProvider>(context).cardList;
    if (cardList != null) {
      for (var bean in cardList) {
        if (bean.folder == RuntimeData.folderList[_index]) {
          bean.folder = _editTextController.text;
          await Provider.of<CardProvider>(context).updateCard(bean);
        }
      }
    }
    RuntimeData.folderList[_index] = _editTextController.text;
    RuntimeData.folderParamsPersistence();
  }
}