import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/util/theme_util.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:allpass/common/page/detail_text_page.dart';
import 'package:allpass/common/widget/label_chip.dart';
import 'package:allpass/setting/category/widget/add_category_dialog.dart';
import 'package:allpass/common/widget/password_generation_dialog.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';

/// 查看或编辑密码页面
class EditPasswordPage extends StatefulWidget {

  final PasswordBean data;

  final int operation;

  EditPasswordPage(this.data, this.operation);

  @override
  _EditPasswordPage createState() {
    return _EditPasswordPage();
  }
}

class _EditPasswordPage extends State<EditPasswordPage> {

  String get pageTitle => (operation == DataOperation.add)? "添加密码" : "编辑密码";

  PasswordBean _oldData;

  int operation;

  String _folder = "默认";
  TextEditingController _nameController;
  TextEditingController _usernameController;
  TextEditingController _passwordController;
  TextEditingController _notesController;
  TextEditingController _urlController;
  List<String> _labels;
  int _fav = 0;
  String _createTime;

  Color _mainColor;

  bool _passwordVisible = false;
  bool _frameDone = false;


  @override
  void dispose() {
    super.dispose();
    _nameController?.dispose();
    _usernameController?.dispose();
    _passwordController?.dispose();
    _notesController?.dispose();
    _urlController?.dispose();
    _frameDone = false;
  }


  @override
  void initState() {
    super.initState();
    this.operation = widget.operation;
    if (operation == DataOperation.update) {
      this._oldData = widget.data;
      _folder = _oldData.folder;
      _labels = List()..addAll(_oldData.label);
      _fav = _oldData.fav;
      _createTime = _oldData.createTime;

      _nameController = TextEditingController(text: _oldData.name);
      _usernameController = TextEditingController(text: _oldData.username);
      _notesController = TextEditingController(text: _oldData.notes);
      _urlController = TextEditingController(text: _oldData.url);
      _passwordController = TextEditingController(text: EncryptUtil.decrypt(_oldData.password));
    } else {
      _nameController = TextEditingController();
      _usernameController = TextEditingController();
      _notesController = TextEditingController();
      _urlController = TextEditingController();
      _passwordController = TextEditingController();
      _labels = List();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (ThemeUtil.isInDarkTheme(context)) {
          _mainColor = Provider.of<ThemeProvider>(context).darkTheme.primaryColor;
        } else {
          _mainColor = Provider.of<ThemeProvider>(context).lightTheme.primaryColor;
        }
      });
      _frameDone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    PasswordProvider provider = Provider.of<PasswordProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitle,
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
                : Icon(Icons.favorite_border),
            onPressed: () {
              setState(() {
                _fav = _fav == 1 ? 0 : 1;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.check,),
            onPressed: () async {
              if (_usernameController.text.length >= 1
                  && _passwordController.text.length >= 1) {
                String pw = EncryptUtil.encrypt(_passwordController.text);
                String name = _nameController.text.trimLeft();
                PasswordBean tempData = PasswordBean(
                  key: _oldData?.uniqueKey,
                  username: _usernameController.text,
                  password: pw,
                  url: _urlController.text,
                  name: name,
                  folder: _folder,
                  label: _labels,
                  notes: _notesController.text,
                  fav: _fav,
                  color: _oldData?.color??getRandomColor(),
                  createTime: _createTime
                );
                if (operation == DataOperation.add) {
                  provider.insertPassword(tempData);
                  RuntimeData.newPasswordOrCardCount++;
                } else {
                  provider.updatePassword(tempData);
                }
                Navigator.pop(context);
              } else {
                ToastUtil.showError(msg: "账号和密码不允许为空！");
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
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
                          // 保证在组件build的第一帧时才去触发取消清空内容，防止报错
                          if (_frameDone) _nameController.clear();
                        },
                      ),
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
                      "账号",
                      style: TextStyle(fontSize: 16, color: _mainColor),
                    ),
                    NoneBorderCircularTextField(
                      editingController: _usernameController,
                      trailing: InkWell(
                        child: Icon(
                          Icons.cancel,
                          size: 20,
                        ),
                        onTap: () {
                          if (_frameDone) _usernameController.clear();
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              spacing: 8.0,
                              runSpacing: 10.0,
                              children: _getMostUsedUsername()),
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
                      "密码",
                      style: TextStyle(fontSize: 16, color: _mainColor),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: NoneBorderCircularTextField(
                            editingController: _passwordController,
                            trailing: InkWell(
                              child: Icon(
                                  Icons.cancel,
                                  size: 20),
                              onTap: () {
                                if (_frameDone) _passwordController.clear();
                              },
                            ),
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
                margin: EdgeInsets.only(left: 40, right: 40, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "链接",
                      style: TextStyle(fontSize: 16, color: _mainColor),
                    ),
                    NoneBorderCircularTextField(
                      editingController: _urlController,
                      trailing: InkWell(
                        child: Icon(
                          Icons.cancel,
                          size: 20,
                        ),
                        onTap: () {
                          if (_frameDone) _urlController.clear();
                        },
                      ),
                    )
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
                        setState(() {
                          _folder = newValue;
                        });
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
                    ),
                  ],
                ),
              )
            ],
          ))
    );
  }

  List<Widget> _getMostUsedUsername() {
    List<Widget> usernameChips = List();
    Provider.of<PasswordProvider>(context).mostUsedUsername.forEach((element) {
      usernameChips.add(LabelChip(
        text: element,
        selected: false,
        onSelected: (_) {
          _usernameController.text = element;
        },
      ));
    });
    return usernameChips;
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
          onSelected: (_) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AddCategoryDialog(),
            ).then((label) {
              if (label != null && RuntimeData.labelListAdd([label])) {
                setState(() {});
                ToastUtil.show(msg: "添加标签 $label 成功");
              } else if (label != null) {
                ToastUtil.show(msg: "标签 $label 已存在");
              }
            });
          }),
    );
    return labelChoices;
  }
}
