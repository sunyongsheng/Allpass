import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/model/password_bean.dart';
import 'package:allpass/params/params.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/encrypt_helper.dart';
import 'package:allpass/widgets/add_category_dialog.dart';

/// 查看或编辑密码页面
class ViewAndEditPasswordPage extends StatefulWidget {
  final PasswordBean data;
  final String pageTitle;
  final bool readOnly;

  ViewAndEditPasswordPage(this.data, this.pageTitle, this.readOnly);

  @override
  _ViewPasswordPage createState() {
    return _ViewPasswordPage(data, pageTitle, readOnly);
  }
}

class _ViewPasswordPage extends State<ViewAndEditPasswordPage> {
  String pageName;

  PasswordBean _tempData;
  PasswordBean _oldData;
  String _password;

  var _futureHelper;

  var _nameController;
  var _usernameController;
  var _passwordController;
  var _notesController;
  var _urlController;

  bool _passwordVisible = false;
  bool _readOnly;

  _ViewPasswordPage(PasswordBean data, this.pageName, this._readOnly) {
    this._oldData = data;
    _tempData = PasswordBean(
        username: _oldData.username,
        password: _oldData.password,
        url: _oldData.url,
        key: _oldData.uniqueKey,
        name: _oldData.name,
        folder: _oldData.folder,
        label: _oldData.label,
        notes: _oldData.notes,
        fav: _oldData.fav);

    _nameController = TextEditingController(text: _tempData.name);
    _usernameController = TextEditingController(text: _tempData.username);
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

  Future<Null> _decryptPassword() async {
    _password =  await EncryptHelper.decrypt(_tempData.password);
    _passwordController = TextEditingController(text: _password);
  }

  @override
  void initState() {
    _futureHelper = _decryptPassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop<PasswordBean>(context, null);
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
              onPressed: () async {
                if (_readOnly) {
                  setState(() {
                    pageName = "编辑密码";
                    _readOnly = false;
                  });
                } else {
                  if (_usernameController.text.length >= 1
                      && _passwordController.text.length >= 1
                      && _urlController.text.length >= 1) {
                    _tempData.password = await EncryptHelper.encrypt(_password);
                    Navigator.pop<PasswordBean>(context, _tempData);
                  } else {
                    Fluttertoast.showToast(msg: "用户名、密码和链接不允许为空！");
                  }
                }
              },
            )
          ],
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          brightness: Brightness.light,
        ),
        body: FutureBuilder(
          future: _futureHelper,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                return SingleChildScrollView(
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
                                "链接",
                                style: AllpassTextUI.firstTitleStyleBlue,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      controller: _urlController,
                                      onChanged: (text) => _tempData.url = text,
                                      readOnly: this._readOnly,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.content_copy),
                                    onPressed: () => Clipboard.setData(
                                        ClipboardData(text: _tempData.url)),
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
                                "用户名",
                                style: AllpassTextUI.firstTitleStyleBlue,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      controller: _usernameController,
                                      onChanged: (text) => _tempData.username = text,
                                      readOnly: this._readOnly,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.content_copy),
                                    onPressed: () => Clipboard.setData(
                                        ClipboardData(text: _tempData.username)),
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
                                "密码",
                                style: AllpassTextUI.firstTitleStyleBlue,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      controller: _passwordController,
                                      obscureText: !_passwordVisible,
                                      onChanged: (text) => _password= text,
                                      readOnly: this._readOnly,
                                    ),
                                  ),
                                  IconButton(
                                    icon: _passwordVisible == true
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off),
                                    onPressed: () {
                                      this.setState(() {
                                        if (_passwordVisible == false)
                                          _passwordVisible = true;
                                        else
                                          _passwordVisible = false;
                                      });
                                    },
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
                                    setState(() {
                                      _tempData.folder = newValue;
                                    });
                                  }
                                },
                                items:
                                Params.folderList.map<DropdownMenuItem<String>>((item) {
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
                    ));
              default:
                return Center(
                  child: Text("未知状态，请与开发者联系：sys6511@126.com"),
                );
            }
          },
        ),
        backgroundColor: Colors.white,
      ),
    );
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
