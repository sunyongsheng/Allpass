import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/params/params.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/dao/card_dao.dart';
import 'package:allpass/dao/password_dao.dart';
import 'package:allpass/model/card_bean.dart';
import 'package:allpass/model/password_bean.dart';

/// 编辑属性对话框
class EditCategoryDialog extends StatefulWidget {

  final String categoryName;
  final int index;

  EditCategoryDialog(this.categoryName, this.index);

  @override
  _EditCategoryDialog createState() {
    return _EditCategoryDialog(categoryName, index);
  }

}

class _EditCategoryDialog extends State<EditCategoryDialog> {

  final String categoryName;

  var _editTextController;
  PasswordDao passwordDao = PasswordDao();
  CardDao cardDao = CardDao();

  bool _inputFormatCorr = true;
  int _index;

  _EditCategoryDialog(this.categoryName, int index) {
    this._index = index;
    _editTextController = TextEditingController(text: Params.labelList[_index]);
  }

  @override
  void dispose() {
    _editTextController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("编辑$categoryName"),
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.all(Radius.circular(10),),
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
                controller: _editTextController,
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
          onPressed: () async {
            if (_inputFormatCorr && _editTextController.text != "") {
              if (categoryName == "标签") {
                if (!Params.labelList.contains(_editTextController.text)) {
                  await editLabelAndUpdate();
                  Fluttertoast.showToast(msg: "保存$categoryName ${_editTextController.text}");
                  Navigator.pop<bool>(context, true);
                } else {
                  Fluttertoast.showToast(msg: "$categoryName ${_editTextController.text} 已存在");
                  Navigator.pop<bool>(context, false);
                }
              } else {
                if (!Params.folderList.contains(_editTextController.text)) {
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
          },
          child: Text('提交'),
          textColor: AllpassColorUI.mainColor,
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop<bool>(context, false);
          },
          child: Text('取消'),
          textColor: AllpassColorUI.mainColor,
        ),
      ],
    );
  }

  editLabelAndUpdate() async {
    List<PasswordBean> passwordList = await passwordDao.getAllPasswordBeanList();
    if (passwordList != null) {
      for (var bean in passwordList) {
        if (bean.label.contains(Params.labelList[_index])) {
          bean.label.remove(Params.labelList[_index]);
          bean.label.add(_editTextController.text);
          passwordDao.updatePasswordBean(bean);
        }
      }
    }
    List<CardBean> cardList = await cardDao.getAllCardBeanList();
    if (cardList != null) {
      for (var bean in cardList) {
        if (bean.label.contains(Params.labelList[_index])) {
          bean.label.remove(Params.labelList[_index]);
          bean.label.add(_editTextController.text);
          cardDao.updatePasswordBean(bean);
        }
      }
    }
    Params.labelList[_index] = _editTextController.text;
    Params.labelParamsPersistence();
  }

  editFolderAndUpdate() async {
    List<PasswordBean> passwordList = await passwordDao.getAllPasswordBeanList();
    if (passwordList != null) {
      for (var bean in passwordList) {
        if (bean.folder == Params.folderList[_index]) {
          bean.folder = _editTextController.text;
          passwordDao.updatePasswordBean(bean);
        }
      }
    }
    List<CardBean> cardList = await cardDao.getAllCardBeanList();
    if (cardList != null) {
      for (var bean in cardList) {
        if (bean.folder == Params.folderList[_index]) {
          bean.folder = _editTextController.text;
          cardDao.updatePasswordBean(bean);
        }
      }
    }
    Params.folderList[_index] = _editTextController.text;
    Params.folderParamsPersistence();
  }
}