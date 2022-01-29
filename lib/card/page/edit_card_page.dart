import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:allpass/core/param/constants.dart';
import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/util/theme_util.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/page/detail_text_page.dart';
import 'package:allpass/common/widget/label_chip.dart';
import 'package:allpass/common/widget/password_generation_dialog.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';
import 'package:allpass/setting/category/widget/add_category_dialog.dart';

/// 查看或编辑“卡片”页面
class EditCardPage extends StatefulWidget {

  final CardBean? data;

  final int operation;

  EditCardPage(this.data, this.operation);

  @override
  State<StatefulWidget> createState() {
    return _EditCardPage();
  }
}

class _EditCardPage extends State<EditCardPage> {

  String get pageTitle => (operation == DataOperation.add)? "添加卡片" : "编辑卡片";

  CardBean? _oldData;

  late int operation;

  late TextEditingController _nameController;
  late TextEditingController _ownerNameController;
  late TextEditingController _cardIdController;
  late TextEditingController _telephoneController;
  late TextEditingController _notesController;
  late TextEditingController _passwordController;

  String _folder = "默认";
  late List<String> _labels;
  int _fav = 0;
  late String _createTime;

  bool _passwordVisible = false;
  bool _frameDone = false;

  @override
  void initState() {
    super.initState();
    this.operation = widget.operation;
    if (operation == DataOperation.update) {
      this._oldData = widget.data;
      _folder = _oldData!.folder;
      _labels = List.from(_oldData!.label ?? []);
      _fav = _oldData!.fav;
      _createTime = _oldData!.createTime;

      _nameController = TextEditingController(text: _oldData!.name);
      _ownerNameController = TextEditingController(text: _oldData!.ownerName);
      _cardIdController = TextEditingController(text: _oldData!.cardId);
      _telephoneController = TextEditingController(text: _oldData!.telephone);
      _notesController = TextEditingController(text: _oldData!.notes);
      _passwordController = TextEditingController(text: EncryptUtil.decrypt(_oldData!.password));
    } else {
      _nameController = TextEditingController();
      _ownerNameController = TextEditingController();
      _cardIdController = TextEditingController();
      _telephoneController = TextEditingController();
      _notesController = TextEditingController();
      _passwordController = TextEditingController();
      _labels = [];
      _createTime = DateTime.now().toIso8601String();
    }

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _frameDone = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _ownerNameController.dispose();
    _cardIdController.dispose();
    _telephoneController.dispose();
    _notesController.dispose();
    _passwordController.dispose();
    _frameDone = false;
  }

  @override
  Widget build(BuildContext context) {
    CardProvider provider = Provider.of<CardProvider>(context);
    Color mainColor = Theme.of(context).primaryColor;
    EdgeInsets marginInset = EdgeInsets.only(left: 30, right: 30, bottom: 20);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            this.pageTitle,
            style: AllpassTextUI.titleBarStyle,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.code),
              onPressed: () {
                showDialog(context: context, builder: (cx) => PasswordGenerationDialog())
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
                if (_ownerNameController.text.length >= 1
                    && _cardIdController.text.length >= 1) {
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
                    color: _oldData?.color ?? getRandomColor(),
                    createTime: _createTime
                  );
                  if (_passwordController.text.length < 1) {
                    ToastUtil.show(msg: "未输入密码，自动初始化为00000");
                  }
                  if (operation == DataOperation.add) {
                    provider.insertCard(tempData);
                    RuntimeData.newPasswordOrCardCount++;
                    ToastUtil.show(msg: "新增成功");
                  } else {
                    provider.updateCard(tempData);
                    ToastUtil.show(msg: "更新成功");
                  }
                  Navigator.pop(context);
                } else {
                  ToastUtil.showError(msg: "拥有者姓名和卡号不允许为空！");
                }
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: marginInset,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "名称",
                      style: TextStyle(fontSize: 16, color: mainColor),
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
                margin: marginInset,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "拥有者姓名",
                      style: TextStyle(fontSize: 16, color: mainColor),
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _getMostUsedOwnerName(),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: marginInset,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "卡号",
                      style: TextStyle(fontSize: 16, color: mainColor),
                    ),
                    NoneBorderCircularTextField(
                      editingController: _cardIdController,
                      inputType: TextInputType.text,
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
                margin: marginInset,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "密码",
                      style: TextStyle(fontSize: 16, color: mainColor),
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
                margin: marginInset,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "绑定手机号",
                      style: TextStyle(fontSize: 16, color: mainColor),
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
                margin: marginInset,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "文件夹",
                      style: TextStyle(fontSize: 16, color: mainColor),
                    ),
                    DropdownButton(
                      onChanged: (newValue) {
                        setState(() => {
                          if (newValue != null) {
                            _folder = newValue.toString()
                          }
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
                margin: EdgeInsets.only(left: 30, right: 30, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "标签",
                        style: TextStyle(fontSize: 16, color: mainColor),
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
                margin: marginInset,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "备注",
                      style: TextStyle(fontSize: 16, color: mainColor),
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
        ));
  }

  List<Widget> _getMostUsedOwnerName() {
    List<Widget> chips = [];
    Provider.of<CardProvider>(context).mostUsedOwnerName.forEach((element) {
      chips.add(Container(
        padding: EdgeInsets.only(right: 8),
        child: LabelChip(
          text: element,
          selected: false,
          onSelected: (_) {
            _ownerNameController.text = element;
          },
        ),
      ));
    });
    return chips;
  }

  List<Widget> _getTag() {
    List<Widget> labelChoices = [];
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
                  ToastUtil.show(msg: "添加标签 $label 成功");
                } else if (label != null) {
                  ToastUtil.show(msg: "标签 $label 已存在");
                }
              }),
      ),
    );
    return labelChoices;
  }
}
