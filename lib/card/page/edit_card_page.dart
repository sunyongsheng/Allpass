import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/util/theme_util.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:allpass/common/page/detail_text_page.dart';
import 'package:allpass/common/widget/label_chip.dart';
import 'package:allpass/setting/category/widget/add_category_dialog.dart';
import 'package:allpass/common/widget/password_generation_dialog.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';

/// 查看或编辑“卡片”页面
class EditCardPage extends StatefulWidget {
  final CardBean data;
  final String pageTitle;

  EditCardPage(this.data, this.pageTitle);

  @override
  State<StatefulWidget> createState() {
    return _EditCardPage();
  }
}

class _EditCardPage extends State<EditCardPage> {

  CardBean _oldData;
  var _futureHelper;

  Color _mainColor;
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
  String _createTime;

  bool _passwordVisible = false;
  bool _frameDone = false;

  Future<Null> _decryptPassword() async {
    _password =  EncryptUtil.decrypt(_oldData.password);
    _passwordController = TextEditingController(text: _password);
  }

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      this._oldData = widget.data;
      _nameController = TextEditingController(text: _oldData.name);
      _ownerNameController = TextEditingController(text: _oldData.ownerName);
      _cardIdController = TextEditingController(text: _oldData.cardId);
      _telephoneController = TextEditingController(text: _oldData.telephone);
      _notesController = TextEditingController(text: _oldData.notes);
      if (_passwordController == null) {
        _passwordController = TextEditingController();
      }
      _folder = _oldData.folder;
      _labels = List()..addAll(_oldData.label);
      _fav = _oldData.fav;
      _createTime = _oldData.createTime;
    } else {
      _nameController = TextEditingController();
      _ownerNameController = TextEditingController();
      _cardIdController = TextEditingController();
      _telephoneController = TextEditingController();
      _notesController = TextEditingController();
      _passwordController = TextEditingController();
      _labels = List();
    }

    _futureHelper = _decryptPassword();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ThemeUtil.isInDarkTheme(context)) {
        _mainColor = Provider.of<ThemeProvider>(context).darkTheme.primaryColor;
      } else {
        _mainColor = Provider.of<ThemeProvider>(context).lightTheme.primaryColor;
      }
      _frameDone = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameController?.dispose();
    _ownerNameController?.dispose();
    _cardIdController?.dispose();
    _telephoneController?.dispose();
    _notesController?.dispose();
    _passwordController?.dispose();
    _frameDone = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.pageTitle,
            style: AllpassTextUI.titleBarStyle,
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
                  : Icon(Icons.favorite_border,),
              onPressed: () {
                setState(() {
                  _fav = _fav == 1 ? 0 : 1;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.check,),
              onPressed: () {
                if (_ownerNameController.text.length >= 1 && _cardIdController.text.length >= 1) {
                  String pwd = _passwordController.text.length >= 1
                      ? EncryptUtil.encrypt(_passwordController.text)
                      : EncryptUtil.encrypt("000000");
                  CardBean tempData = CardBean(
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
                    isChanged: true,
                    color: _oldData?.color??getRandomColor(),
                    createTime: _createTime
                  );
                  if (_passwordController.text.length < 1) {
                    Fluttertoast.showToast(msg: "未输入密码，自动初始化为00000");
                  }
                  Navigator.pop<CardBean>(context, tempData);
                } else {
                  Fluttertoast.showToast(msg: "拥有者姓名和卡号不允许为空！");
                }
              },
            )
          ],
        ),
        body: FutureBuilder(
          future: _futureHelper,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "名称",
                              style: TextStyle(fontSize: 16, color: _mainColor),
                            ),
                            NoneBorderCircularTextField(
                              editingController: _nameController,
                              trailing: InkWell(
                                child: Icon(
                                  Icons.cancel,
                                  size: 20,
                                ),
                                onTap: () {
                                  if (_frameDone) _nameController.clear();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "拥有者姓名",
                              style: TextStyle(fontSize: 16, color: _mainColor),
                            ),
                            NoneBorderCircularTextField(
                              editingController: _ownerNameController,
                              trailing: InkWell(
                                child: Icon(
                                  Icons.cancel,
                                  size: 20,
                                ),
                                onTap: () {
                                  if (_frameDone) _ownerNameController.clear();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "卡号",
                              style: TextStyle(fontSize: 16, color: _mainColor),
                            ),
                            NoneBorderCircularTextField(
                              editingController: _cardIdController,
                              inputType: TextInputType.number,
                              trailing: InkWell(
                                child: Icon(
                                  Icons.cancel,
                                  size: 20,
                                ),
                                onTap: () {
                                  if (_frameDone) _cardIdController.clear();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "密码",
                              style: TextStyle(fontSize: 16, color: _mainColor),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: NoneBorderCircularTextField(
                                    editingController: _passwordController,
                                    obscureText: !_passwordVisible,
                                    trailing: InkWell(
                                      child: Icon(
                                        Icons.cancel,
                                        size: 20,
                                      ),
                                      onTap: () {
                                        // 保证在组件build的第一帧时才去触发取消清空内容，防止报错
                                        if (_frameDone) _passwordController.clear();
                                      },
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
                        margin: EdgeInsets.only(left: 40, right: 40, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "绑定手机号",
                              style: TextStyle(fontSize: 16, color: _mainColor),
                            ),
                            NoneBorderCircularTextField(
                              editingController: _telephoneController,
                              inputType: TextInputType.numberWithOptions(signed: true),
                              trailing: InkWell(
                                child: Icon(
                                  Icons.cancel,
                                  size: 20,
                                ),
                                onTap: () {
                                  // 保证在组件build的第一帧时才去触发取消清空内容，防止报错
                                  if (_frameDone) _telephoneController.clear();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40, bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "文件夹",
                              style: TextStyle(fontSize: 16, color: _mainColor),
                            ),
                            DropdownButton(
                              onChanged: (newValue) {
                                setState(() => _folder = newValue);
                              },
                              items: RuntimeData.folderList.map<DropdownMenuItem<String>>((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item, style: TextStyle(
                                      color: ThemeUtil.isInDarkTheme(context)
                                          ? Colors.white
                                          : Colors.black
                                  ),),
                                );
                              }).toList(),
                              style: AllpassTextUI.firstTitleStyle,
                              elevation: 8,
                              iconSize: 30,
                              value: _folder,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40, bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Text(
                                "标签",
                                style: TextStyle(fontSize: 16, color: _mainColor),
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
                        margin: EdgeInsets.only(left: 40, right: 40, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "备注",
                              style: TextStyle(fontSize: 16, color: _mainColor),
                            ),
                            NoneBorderCircularTextField(
                              editingController: _notesController,
                              maxLines: null,
                              onTap: () {
                                Navigator.push(context, CupertinoPageRoute(
                                  builder: (context) => DetailTextPage("备注", _notesController.text, true),
                                )).then((newValue) {
                                  setState(() {
                                    _notesController.text = newValue;
                                  });
                                });
                              },
                            )
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
        ));
  }

  List<Widget> _getTag() {
    List<Widget> labelChoices = List();
    RuntimeData.labelList.forEach((item) {
      labelChoices.add(LabelChip(
        text: item,
        selected: _labels.contains(item),
        onSelected: (selected) {
          setState(() => _labels.contains(item)
              ? _labels.remove(item)
              : _labels.add(item));
        },
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
                builder: (context) => AddCategoryDialog()
              ).then((label) {
                if (label != null && RuntimeData.labelListAdd([label])) {
                  setState(() {});
                  Fluttertoast.showToast(msg: "添加标签 $label 成功");
                } else if (label != null) {
                  Fluttertoast.showToast(msg: "标签 $label 已存在");
                }
              }),
      ),
    );
    return labelChoices;
  }
}
