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

  CardBean? editingData;

  late int operation;

  late TextEditingController nameController;
  late TextEditingController ownerNameController;
  late TextEditingController cardIdController;
  late TextEditingController telephoneController;
  late TextEditingController notesController;
  late TextEditingController passwordController;

  String folder = "默认";
  List<String> labels = [];
  int fav = 0;
  late String createTime;

  bool passwordVisible = false;
  bool frameDone = false;

  @override
  void initState() {
    super.initState();
    operation = widget.operation;
    if (operation == DataOperation.update) {
      editingData = widget.data;
      var editingCard = editingData!;
      folder = editingCard.folder;
      labels.addAll(editingCard.label ?? []);
      fav = editingCard.fav;
      createTime = editingCard.createTime;

      nameController = TextEditingController(text: editingCard.name);
      ownerNameController = TextEditingController(text: editingCard.ownerName);
      cardIdController = TextEditingController(text: editingCard.cardId);
      telephoneController = TextEditingController(text: editingCard.telephone);
      notesController = TextEditingController(text: editingCard.notes);
      passwordController = TextEditingController(text: EncryptUtil.decrypt(editingCard.password));
    } else {
      nameController = TextEditingController();
      ownerNameController = TextEditingController();
      cardIdController = TextEditingController();
      telephoneController = TextEditingController();
      notesController = TextEditingController();
      passwordController = TextEditingController();

      createTime = DateTime.now().toIso8601String();
    }

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      frameDone = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    ownerNameController.dispose();
    cardIdController.dispose();
    telephoneController.dispose();
    notesController.dispose();
    passwordController.dispose();
    frameDone = false;
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
                  if (value != null) passwordController.text = value;
                });
              },
            ),
            IconButton(
              icon: fav == 1
                  ? Icon(Icons.favorite, color: Colors.redAccent,)
                  : Icon(Icons.favorite_border,),
              onPressed: () {
                setState(() {
                  fav = fav == 1 ? 0 : 1;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.check,),
              onPressed: () {
                if (ownerNameController.text.length >= 1
                    && cardIdController.text.length >= 1) {
                  String pwd = passwordController.text.length >= 1
                      ? EncryptUtil.encrypt(passwordController.text)
                      : EncryptUtil.encrypt("000000");
                  CardBean tempData = CardBean(
                    ownerName: ownerNameController.text,
                    cardId: cardIdController.text,
                    key: editingData?.uniqueKey,
                    name: nameController.text,
                    telephone: telephoneController.text,
                    folder: folder,
                    label: labels,
                    fav: fav,
                    notes: notesController.text,
                    password: pwd,
                    color: editingData?.color ?? getRandomColor(),
                    createTime: createTime
                  );
                  if (passwordController.text.length < 1) {
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
                      editingController: nameController,
                      trailing: InkWell(
                        child: Icon(
                          Icons.cancel,
                          size: 20,
                        ),
                        onTap: () {
                          if (frameDone) nameController.clear();
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
                      editingController: ownerNameController,
                      trailing: InkWell(
                        child: Icon(
                          Icons.cancel,
                          size: 20,
                        ),
                        onTap: () {
                          if (frameDone) ownerNameController.clear();
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
                      editingController: cardIdController,
                      inputType: TextInputType.text,
                      trailing: InkWell(
                        child: Icon(
                          Icons.cancel,
                          size: 20,
                        ),
                        onTap: () {
                          if (frameDone) cardIdController.clear();
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
                            editingController: passwordController,
                            obscureText: !passwordVisible,
                            trailing: InkWell(
                              child: Icon(
                                Icons.cancel,
                                size: 20,
                              ),
                              onTap: () {
                                // 保证在组件build的第一帧时才去触发取消清空内容，防止报错
                                if (frameDone) passwordController.clear();
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          icon: passwordVisible == true
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                          onPressed: () {
                            this.setState(() {
                              if (passwordVisible == false)
                                passwordVisible = true;
                              else
                                passwordVisible = false;
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
                      editingController: telephoneController,
                      inputType: TextInputType.numberWithOptions(signed: true),
                      trailing: InkWell(
                        child: Icon(
                          Icons.cancel,
                          size: 20,
                        ),
                        onTap: () {
                          // 保证在组件build的第一帧时才去触发取消清空内容，防止报错
                          if (frameDone) telephoneController.clear();
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
                            folder = newValue.toString()
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
                      value: folder,
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
                      editingController: notesController,
                      maxLines: null,
                      onTap: () {
                        Navigator.push(context, CupertinoPageRoute(
                          builder: (context) => DetailTextPage("备注", notesController.text, true),
                        )).then((newValue) {
                          setState(() {
                            notesController.text = newValue;
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
            ownerNameController.text = element;
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
        selected: labels.contains(item),
        onSelected: (selected) {
          setState(() => labels.contains(item)
              ? labels.remove(item)
              : labels.add(item));
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
