import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/model/card_bean.dart';
import 'package:allpass/params/params.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/widgets/add_category_dialog.dart';
import 'package:allpass/pages/common/detail_text_page.dart';

/// 查看或编辑“卡片”页面
class EditCardPage extends StatefulWidget {
  final CardBean data;
  final String pageTitle;

  EditCardPage(this.data, this.pageTitle);

  @override
  State<StatefulWidget> createState() {
    return _EditCardPage(data, pageTitle);
  }
}

class _EditCardPage extends State<EditCardPage> {
  String pageName;

  CardBean _oldData;
  CardBean _tempData;

  var _nameController;
  var _ownerNameController;
  var _cardIdController;
  var _telephoneController;
  var _notesController;
  var _urlController;
  String _folder = "默认";
  List<String> _labels;
  int _fav = 0;


  _EditCardPage(CardBean inData, this.pageName) {
    if (inData != null) {
      this._oldData = inData;
      _nameController = TextEditingController(text: _oldData.name);
      _ownerNameController = TextEditingController(text: _oldData.ownerName);
      _cardIdController = TextEditingController(text: _oldData.cardId);
      _telephoneController = TextEditingController(text: _oldData.telephone);
      _notesController = TextEditingController(text: _oldData.notes);
      _urlController = TextEditingController(text: _oldData.url);
      _folder = _oldData.folder;
      _labels = List()..addAll(_oldData.label);
      _fav = _oldData.fav;
    } else {
      _nameController = TextEditingController();
      _ownerNameController = TextEditingController();
      _cardIdController = TextEditingController();
      _telephoneController = TextEditingController();
      _notesController = TextEditingController();
      _urlController = TextEditingController();
      _labels = List();
    }
  }

  @override
  void dispose() {
    _nameController?.dispose();
    _ownerNameController?.dispose();
    _cardIdController?.dispose();
    _telephoneController?.dispose();
    _notesController?.dispose();
    _urlController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop<CardBean>(context, _oldData);
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
                  icon: _fav == 1
                      ? Icon(Icons.favorite, color: Colors.redAccent,)
                      : Icon(Icons.favorite_border, color: Colors.black,),
                  onPressed: () {
                    setState(() {
                      _fav = _fav == 1 ? 0 : 1;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                          Icons.check,
                          color: Colors.black,
                        ),
                  onPressed: () {
                    if (_ownerNameController.text.length >= 1 && _cardIdController.text.length >= 1) {
                      _tempData = CardBean(
                        ownerName: _ownerNameController.text,
                        cardId: _cardIdController.text,
                        key: _oldData?.uniqueKey,
                        name: _nameController.text,
                        telephone: _telephoneController.text,
                        folder: _folder,
                        label: _labels,
                        fav: _fav,
                        notes: _notesController.text,
                        url: _urlController.text,
                        isChanged: true
                      );
                      Navigator.pop<CardBean>(context, _tempData);
                    } else {
                      Fluttertoast.showToast(msg: "用户名和卡号不允许为空！");
                    }
                  },
                )
              ],
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0,
              brightness: Brightness.light,
            ),
            backgroundColor: AllpassColorUI.mainBackgroundColor,
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
                        TextField(
                          controller: _ownerNameController,
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
                          "卡号",
                          style: AllpassTextUI.firstTitleStyleBlue,
                        ),
                        TextField(
                          controller: _cardIdController,
                          keyboardType: TextInputType.number,
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
                          "链接",
                          style: AllpassTextUI.firstTitleStyleBlue,
                        ),
                        TextField(
                          controller: _urlController,
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
                        TextField(
                          controller: _telephoneController,
                          onChanged: (text) {
                            _tempData.telephone = text;
                          },
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true),
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
                            setState(() => _folder = newValue);
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
                          value: _folder,
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
                          readOnly: true,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => DetailTextPage(_notesController.text, true),
                            )).then((newValue) {
                              setState(() {
                                _notesController.text = newValue;
                              });
                            });
                          },
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
        selected: _labels.contains(item),
        onSelected: (selected) {
          setState(() => _labels.contains(item)
              ? _labels.remove(item)
              : _labels.add(item));
        },
        selectedColor: AllpassColorUI.mainColor,
      ));
    });
    labelChoices.add(
      ChoiceChip(
          label: Icon(Icons.add),
          selected: false,
          onSelected: (_) =>
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AddCategoryDialog("标签");
                },
              ).then((_) => setState((){})),
      ),
    );
    return labelChoices;
  }
}
