import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/model/password_bean.dart';
import 'package:allpass/params/params.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/encrypt_util.dart';
import 'package:allpass/widgets/add_category_dialog.dart';
import 'package:allpass/pages/common/detail_text_page.dart';

/// 查看或编辑密码页面
class EditPasswordPage extends StatefulWidget {
  final PasswordBean data;
  final String pageTitle;

  EditPasswordPage(this.data, this.pageTitle);

  @override
  _EditPasswordPage createState() {
    return _EditPasswordPage(data, pageTitle);
  }
}

class _EditPasswordPage extends State<EditPasswordPage> {
  String pageName;

  PasswordBean _tempData;
  PasswordBean _oldData;

  var _futureHelper;

  String _password;
  String _folder = "默认";
  var _nameController;
  var _usernameController;
  var _passwordController;
  var _notesController;
  var _urlController;
  List<String> _labels;

  bool _passwordVisible = false;

  _EditPasswordPage(PasswordBean data, this.pageName) {
    if (data != null) {
      this._oldData = data;
      _nameController = TextEditingController(text: _oldData.name);
      _usernameController = TextEditingController(text: _oldData.username);
      _notesController = TextEditingController(text: _oldData.notes);
      _urlController = TextEditingController(text: _oldData.url);
      _folder = _oldData.folder;
      _labels = List()..addAll(_oldData.label);
    } else {
      _nameController = TextEditingController();
      _usernameController = TextEditingController();
      _notesController = TextEditingController();
      _urlController = TextEditingController();
      _passwordController = TextEditingController();
      _labels = List();
    }
  }

  @override
  void dispose() {
    _nameController?.dispose();
    _usernameController?.dispose();
    _passwordController?.dispose();
    _notesController?.dispose();
    _urlController?.dispose();
    super.dispose();
  }

  Future<Null> _decryptPassword() async {
    _password =  await EncryptUtil.decrypt(_oldData.password);
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
        Navigator.pop<PasswordBean>(context, _oldData);
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
              icon: Icon(
                Icons.check,
                color: Colors.black,
              ),
              onPressed: () async {
                if (_usernameController.text.length >= 1
                    && _passwordController.text.length >= 1
                    && _urlController.text.length >= 1) {
                  String pw = await EncryptUtil.encrypt(_passwordController.text);
                  _tempData = PasswordBean(
                    key: _oldData?.uniqueKey,
                    username: _usernameController.text,
                    password: pw,
                    url: _urlController.text,
                    name: _nameController.text,
                    folder: _folder,
                    label: _labels,
                    notes: _notesController.text,
                    isChanged: true,
                    fav: 0
                  );
                  Navigator.pop<PasswordBean>(context, _tempData);
                } else {
                  Fluttertoast.showToast(msg: "用户名、密码和链接不允许为空！");
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
                                "用户名",
                                style: AllpassTextUI.firstTitleStyleBlue,
                              ),
                              TextField(
                                controller: _usernameController,
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
                                "密码",
                                style: AllpassTextUI.firstTitleStyleBlue,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      controller: _passwordController,
                                      obscureText: !_passwordVisible,
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
                                  setState(() {
                                    _folder = newValue;
                                  });
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
          onSelected: (_) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AddCategoryDialog("标签"),
            );
          }),
    );
    return labelChoices;
  }
}
