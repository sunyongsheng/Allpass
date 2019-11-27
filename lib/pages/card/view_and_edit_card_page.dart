import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/model/card_bean.dart';
import 'package:allpass/params/params.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/widgets/add_category_dialog.dart';

/// 查看或编辑“卡片”页面
class ViewAndEditCardPage extends StatefulWidget {
  final CardBean data;
  final String pageTitle;
  final bool readOnly;

  ViewAndEditCardPage(this.data, this.pageTitle, this.readOnly);

  @override
  State<StatefulWidget> createState() {
    return _ViewAndEditCardPage(data, pageTitle, readOnly);
  }
}

class _ViewAndEditCardPage extends State<ViewAndEditCardPage> {
  String pageName;

  CardBean _oldData;
  CardBean _tempData;

  var _nameController;
  var _ownerNameController;
  var _cardIdController;
  var _telephoneController;
  var _notesController;
  var _urlController;

  bool _readOnly;

  _ViewAndEditCardPage(CardBean inData, this.pageName, this._readOnly) {
    this._oldData = inData;

    _tempData = CardBean(
      ownerName: _oldData.ownerName,
      cardId: _oldData.cardId,
      key: _oldData.uniqueKey,
      name: _oldData.name,
      telephone: _oldData.telephone,
      folder: _oldData.folder,
      label: _oldData.label,
      fav: _oldData.fav,
      notes: _oldData.notes,
      url: _oldData.url,
    );

    _nameController = TextEditingController(text: _tempData.name);
    _ownerNameController = TextEditingController(text: _tempData.ownerName);
    _cardIdController = TextEditingController(text: _tempData.cardId);
    _telephoneController = TextEditingController(text: _tempData.telephone);
    _notesController = TextEditingController(text: _tempData.notes);
    _urlController = TextEditingController(text: _tempData.url);

    // 如果文件夹未知，添加
    if (!Params.folderList.contains(_tempData.folder)) {
      Params.folderList.add(_tempData.folder);
    }
    // 检查标签未知，添加
    for (var label in _tempData.label) {
      if (!Params.labelList.contains(label)) {
        Params.labelList.add(label);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          print("取消修改: " + _oldData.toString());
          Navigator.pop<CardBean>(context, null);
          return Future<bool>.value(false);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                pageName,
                style: AllpassTextUI.firstTitleStyleBlack,
              ),
              actions: <Widget>[
                IconButton(
                  icon: _readOnly
                      ? Icon(
                          Icons.edit,
                          color: Colors.black,
                        )
                      : Icon(
                          Icons.check,
                          color: Colors.black,
                        ),
                  onPressed: () {
                    if (_readOnly) {
                      setState(() {
                        _readOnly = false;
                        pageName = "编辑卡片";
                      });
                    } else {
                      if (_tempData.ownerName.length >= 1 && _tempData.cardId.length >= 1) {
                        Navigator.pop<CardBean>(context, _tempData);
                      } else {
                        Fluttertoast.showToast(msg: "用户名和卡号不允许为空！");
                      }
                    }
                  },
                )
              ],
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40, bottom: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "名称",
                          style: AllpassTextUI.firstTitleStyleBlue,
                        ),
                        TextField(
                          controller: _nameController,
                          onChanged: (text) => _tempData.name = text,
                          readOnly: this._readOnly,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40, bottom: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "拥有者姓名",
                          style: AllpassTextUI.firstTitleStyleBlue,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _ownerNameController,
                                onChanged: (text) => _tempData.ownerName = text,
                                readOnly: this._readOnly,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.content_copy),
                              onPressed: () => Clipboard.setData(
                                  ClipboardData(text: _tempData.ownerName)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40, bottom: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "卡号",
                          style: AllpassTextUI.firstTitleStyleBlue,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _cardIdController,
                                onChanged: (text) => _tempData.cardId = text,
                                readOnly: this._readOnly,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.content_copy),
                              onPressed: () => Clipboard.setData(
                                  ClipboardData(text: _tempData.cardId)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40, bottom: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "URL",
                          style: AllpassTextUI.firstTitleStyleBlue,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _urlController,
                                onChanged: (text) {
                                  _tempData.url = text;
                                },
                                readOnly: this._readOnly,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.content_copy),
                              onPressed: () => Clipboard.setData(
                                  ClipboardData(text: _tempData.telephone)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40, bottom: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "绑定手机号",
                          style: AllpassTextUI.firstTitleStyleBlue,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _telephoneController,
                                onChanged: (text) {
                                  _tempData.telephone = text;
                                },
                                readOnly: this._readOnly,
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.content_copy),
                              onPressed: () => Clipboard.setData(
                                  ClipboardData(text: _tempData.telephone)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40, bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "文件夹",
                          style: AllpassTextUI.firstTitleStyleBlue,
                        ),
                        DropdownButton(
                          onChanged: (newValue) {
                            if (!_readOnly) {
                              setState(() => _tempData.folder = newValue);
                            }
                          },
                          items: Params.folderList
                              .map<DropdownMenuItem<String>>((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          style: AllpassTextUI.firstTitleStyleBlack,
                          elevation: 8,
                          iconSize: 30,
                          value: _tempData.folder,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40, bottom: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "标签",
                            style: AllpassTextUI.firstTitleStyleBlue,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  spacing: 8.0,
                                  runSpacing: 10.0,
                                  children: _getTag()),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40, bottom: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "备注",
                          style: AllpassTextUI.firstTitleStyleBlue,
                        ),
                        TextField(
                          controller: _notesController,
                          onChanged: (text) => _tempData.notes = text,
                          readOnly: this._readOnly,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }

  List<Widget> _getTag() {
    List<Widget> labelChoices = List();
    Params.labelList.forEach((item) {
      labelChoices.add(ChoiceChip(
        label: Text(item),
        labelStyle: AllpassTextUI.secondTitleStyleBlack,
        selected: _tempData.label.contains(item),
        onSelected: (selected) {
          if (!_readOnly) {
            setState(() => _tempData.label.contains(item)
                ? _tempData.label.remove(item)
                : _tempData.label.add(item));
          }
        },
        selectedColor: AllpassColorUI.mainColor,
      ));
    });
    labelChoices.add(
      ChoiceChip(
          label: Icon(Icons.add),
          selected: false,
          onSelected: (_) {
            if (!_readOnly) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, state) {
                      return AddCategoryDialog("标签");
                    },
                  );
                },
              );
            }
          }),
    );
    return labelChoices;
  }
}
