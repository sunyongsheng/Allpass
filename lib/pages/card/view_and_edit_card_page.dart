import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:allpass/bean/card_bean.dart';
import 'package:allpass/params/params.dart';
import 'package:allpass/utils/allpass_ui.dart';

/// 查看或编辑“卡片”页面
class ViewAndEditCardPage extends StatefulWidget {
  final CardBean data;
  final String pageTitle;
  bool readOnly;

  ViewAndEditCardPage(this.data, this.pageTitle, this.readOnly);

  @override
  State<StatefulWidget> createState() {
    return _ViewAndEditCardPage(data, pageTitle, readOnly);
  }
}

class _ViewAndEditCardPage extends State<ViewAndEditCardPage> {
  final String pageName;

  CardBean oldData;
  CardBean tempData;

  var nameController;
  var ownerNameController;
  var cardIdController;
  var telephoneController;
  var notesController;
  var urlController;

  bool readOnly;

  _ViewAndEditCardPage(CardBean inData, this.pageName, this.readOnly) {

    this.oldData = inData;

    tempData = CardBean(oldData.ownerName, oldData.cardId,
        key: oldData.uniqueKey,
        name: oldData.name,
        telephone: oldData.telephone,
        folder: oldData.folder,
        label: List()..addAll(oldData.label),
        fav: oldData.fav,
        notes: oldData.notes,
      url: oldData.url,
    );

    nameController = TextEditingController(text: tempData.name);
    ownerNameController = TextEditingController(text: tempData.ownerName);
    cardIdController = TextEditingController(text: tempData.cardId);
    telephoneController = TextEditingController(text: tempData.telephone);
    notesController = TextEditingController(text: tempData.notes);
    urlController = TextEditingController(text: tempData.url);

    // 如果文件夹未知，添加
    if (!Params.folderList.contains(tempData.folder)) {
      Params.folderList.add(tempData.folder);
    }
    // 检查标签未知，添加
    for (var label in tempData.label) {
      if (!Params.labelList.contains(label)) {
        Params.labelList.add(label);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          print("取消修改: " + oldData.toString());
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
                  icon: readOnly
                      ? Icon(
                          Icons.edit,
                          color: Colors.black,
                        )
                      : Icon(
                          Icons.check,
                          color: Colors.black,
                        ),
                  onPressed: () {
                    if (readOnly) {
                      setState(() => readOnly = false);
                    } else {
                      print("保存: " + tempData.toString());
                      Navigator.pop<CardBean>(context, tempData);
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
                          controller: nameController,
                          onChanged: (text) => tempData.name = text,
                          readOnly: this.readOnly,
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
                                controller: ownerNameController,
                                onChanged: (text) => tempData.ownerName = text,
                                readOnly: this.readOnly,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.content_copy),
                              onPressed: () => Clipboard.setData(
                                  ClipboardData(text: tempData.ownerName)),
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
                                controller: cardIdController,
                                onChanged: (text) => tempData.cardId = text,
                                readOnly: this.readOnly,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.content_copy),
                              onPressed: () => Clipboard.setData(
                                  ClipboardData(text: tempData.cardId)),
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
                                controller: urlController,
                                onChanged: (text) {
                                  tempData.url = text;
                                },
                                readOnly: this.readOnly,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.content_copy),
                              onPressed: () => Clipboard.setData(
                                  ClipboardData(text: tempData.telephone)),
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
                                controller: telephoneController,
                                onChanged: (text) {
                                  tempData.telephone = text;
                                },
                                readOnly: this.readOnly,
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.content_copy),
                              onPressed: () => Clipboard.setData(
                                  ClipboardData(text: tempData.telephone)),
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
                            if (!readOnly) {
                              setState(() => tempData.folder = newValue);
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
                          value: tempData.folder,
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
                          controller: notesController,
                          onChanged: (text) => tempData.notes = text,
                          readOnly: this.readOnly,
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
        selected: tempData.label.contains(item),
        onSelected: (selected) {
          if (!readOnly) {
            setState(() => tempData.label.contains(item)
                ? tempData.label.remove(item)
                : tempData.label.add(item));
          }
        },
        selectedColor: AllpassColorUI.mainColor,
      ));
    });
    return labelChoices;
  }
}
