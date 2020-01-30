import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/model/card_bean.dart';
import 'package:allpass/params/params.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/encrypt_util.dart';
import 'package:allpass/widgets/add_category_dialog.dart';
import 'package:allpass/pages/common/detail_text_page.dart';
import 'package:allpass/widgets/password_generation_dialog.dart';

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
  bool _passwordVisible = false;
  var _futureHelper;

  TextEditingController _nameController;
  TextEditingController _ownerNameController;
  TextEditingController _cardIdController;
  TextEditingController _telephoneController;
  TextEditingController _notesController;
  TextEditingController _passwordController;
  String _password;
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
      _folder = _oldData.folder;
      _labels = List()..addAll(_oldData.label);
      _fav = _oldData.fav;
    } else {
      _nameController = TextEditingController();
      _ownerNameController = TextEditingController();
      _cardIdController = TextEditingController();
      _telephoneController = TextEditingController();
      _notesController = TextEditingController();
      _passwordController = TextEditingController();
      _labels = List();
    }
  }

  Future<Null> _decryptPassword() async {
    _password =  EncryptUtil.decrypt(_oldData.password);
    _passwordController = TextEditingController(text: _password);
  }

  @override
  void initState() {
    super.initState();
    _futureHelper = _decryptPassword();
  }

  @override
  void dispose() {
    _nameController?.dispose();
    _ownerNameController?.dispose();
    _cardIdController?.dispose();
    _telephoneController?.dispose();
    _notesController?.dispose();
    _passwordController?.dispose();
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
                  icon: Icon(Icons.code),
                  onPressed: () {
                    showDialog(context: context, child: PasswordGenerationDialog())
                        .then((value) {
                      if (value != null) _passwordController.text = value;
                    });
                  },
                ),
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
                      String pwd = _passwordController.text.length >= 1
                          ? EncryptUtil.encrypt(_passwordController.text)
                          : EncryptUtil.encrypt("000000");
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
                        password: pwd,
                        isChanged: true
                      );
                      if (_passwordController.text.length < 1) {
                        Fluttertoast.showToast(msg: "未输入密码，自动初始化为00000");
                      }
                      Navigator.pop<CardBean>(context, _tempData);
                    } else {
                      Fluttertoast.showToast(msg: "拥有者姓名和卡号不允许为空！");
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
            body: FutureBuilder(
              future: _futureHelper,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
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
                                  decoration: InputDecoration(
                                      suffix: InkWell(
                                        child: Icon(
                                          Icons.cancel,
                                          size: 20,
                                          color: Colors.black26,
                                        ),
                                        onTap: () {
                                          // 保证在组件build的第一帧时才去触发取消清空内容，防止报错
                                          WidgetsBinding.instance.addPostFrameCallback((_) => _nameController.clear());
                                        },
                                      )
                                  ),
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
                                  decoration: InputDecoration(
                                      suffix: InkWell(
                                        child: Icon(
                                          Icons.cancel,
                                          size: 20,
                                          color: Colors.black26,
                                        ),
                                        onTap: () {
                                          // 保证在组件build的第一帧时才去触发取消清空内容，防止报错
                                          WidgetsBinding.instance.addPostFrameCallback((_) => _ownerNameController.clear());
                                        },
                                      )
                                  ),
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
                                  decoration: InputDecoration(
                                      suffix: InkWell(
                                        child: Icon(
                                          Icons.cancel,
                                          size: 20,
                                          color: Colors.black26,
                                        ),
                                        onTap: () {
                                          // 保证在组件build的第一帧时才去触发取消清空内容，防止报错
                                          WidgetsBinding.instance.addPostFrameCallback((_) => _cardIdController.clear());
                                        },
                                      )
                                  ),
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
                                        decoration: InputDecoration(
                                            suffix: InkWell(
                                              child: Icon(
                                                Icons.cancel,
                                                size: 20,
                                                color: Colors.black26,
                                              ),
                                              onTap: () {
                                                // 保证在组件build的第一帧时才去触发取消清空内容，防止报错
                                                WidgetsBinding.instance.addPostFrameCallback((_) => _passwordController.clear());
                                              },
                                            )
                                        ),
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
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: true),
                                  decoration: InputDecoration(
                                      suffix: InkWell(
                                        child: Icon(
                                          Icons.cancel,
                                          size: 20,
                                          color: Colors.black26,
                                        ),
                                        onTap: () {
                                          // 保证在组件build的第一帧时才去触发取消清空内容，防止报错
                                          WidgetsBinding.instance.addPostFrameCallback((_) => _telephoneController.clear());
                                        },
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40, right: 40, bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                  maxLines: null,
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
                    );
                  default:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                }
              },
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
