import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/dao/password_dao.dart';
import 'package:allpass/dao/card_dao.dart';
import 'package:allpass/model/password_bean.dart';
import 'package:allpass/model/card_bean.dart';
import 'package:allpass/params/params.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/widgets/add_category_dialog.dart';
import 'package:allpass/widgets/edit_category_dialog.dart';



class CategoryManagerPage extends StatefulWidget {

  final String name;

  CategoryManagerPage(this.name);

  @override
  State<StatefulWidget> createState() {
    return _CategoryManagerPage(name);
  }
}

class _CategoryManagerPage extends State<CategoryManagerPage> {

  String categoryName;

  PasswordDao passwordDao = PasswordDao();
  CardDao cardDao = CardDao();

  _CategoryManagerPage(String name) {
    this.categoryName = name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$categoryName管理", style: AllpassTextUI.mainTitleStyle,),
        centerTitle: true,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        elevation: 0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(children: _getAllWidget(),),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, state) {
                  return AddCategoryDialog(categoryName);
                },
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _getAllWidget() {
    List<Widget> widgets = List();
    List<String> list = List();
    if (categoryName == "标签") list = Params.labelList;
    else list = Params.folderList;
    for (int currIndex = 0; currIndex < list.length; currIndex++) {
      String currCategoryName = list[currIndex];
      widgets.add(Container(
        child: ListTile(
          // TODO 增加trailing属性显示有多少个密码账号含有此标签
          title: Text(currCategoryName),
          onTap: () {
            if (categoryName == "文件夹" && currCategoryName == "默认") {
              Fluttertoast.showToast(msg: "此文件夹不允许修改！");
              return;
            }
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: AllpassEdgeInsets.listInset,
                        child: ListTile(
                          title: Text("编辑$categoryName"),
                          leading: Icon(Icons.edit_attributes),
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, state) {
                                    return EditCategoryDialog(categoryName, currIndex);
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: AllpassEdgeInsets.listInset,
                        child: ListTile(
                          title: Text("删除$categoryName"),
                          leading: Icon(Icons.delete),
                          onTap: () async {
                            if (categoryName == '标签') {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("确认删除"),
                                      content: Text("拥有此标签的密码或卡片将删除此标签，确认吗？"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("确认"),
                                          onPressed: () async => await deleteLabelAndUpdate(currCategoryName),
                                        ),
                                        FlatButton(
                                          child: Text("取消"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    );
                                  });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("确认删除"),
                                      content: Text("此操作将会移动此文件夹下的所有密码及卡片到‘默认’文件夹中，确认吗？"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("确认"),
                                          onPressed: () async => await deleteFolderAndUpdate(currCategoryName),
                                        ),
                                        FlatButton(
                                          child: Text("取消"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    );
                                  }
                              );
                            }
                          },
                        ),
                      )
                    ],
                  );
                }
            );
          },
        ),
        padding: EdgeInsets.only(right: 20, left: 20),
      ));
    }
    return widgets;
  }

  deleteLabelAndUpdate(String label) async {
    List<PasswordBean> passwordList = await passwordDao.getAllPasswordBeanList();
    if (passwordList != null) {
      for (var bean in passwordList) {
        if (bean.label.contains(label)) {
          bean.label.remove(label);
          passwordDao.updatePasswordBean(bean);
        }
      }
    }
    List<CardBean> cardList = await cardDao.getAllCardBeanList();
    if (cardList != null) {
      for (var bean in cardList) {
        if (bean.label.contains(label)) {
          bean.label.remove(label);
          cardDao.updatePasswordBean(bean);
        }
      }
    }
    setState(() {
      Params.labelList.remove(label);
    });
    Params.labelParamsPersistence();
    Navigator.pop(context);
  }

  deleteFolderAndUpdate(String folder) async {
    List<PasswordBean> passwordList = await passwordDao.getAllPasswordBeanList();
    if (passwordList != null) {
      for (var bean in passwordList) {
        if (folder == bean.folder) {
          bean.folder = "默认";
          passwordDao.updatePasswordBean(bean);
        }
      }
    }
    List<CardBean> cardList = await cardDao.getAllCardBeanList();
    if (cardList != null) {
      for (var bean in cardList) {
        if (folder == bean.folder) {
          bean.folder = "默认";
          cardDao.updatePasswordBean(bean);
        }
      }
    }
    setState(() {
      Params.folderList.remove(folder);
    });
    Params.folderParamsPersistence();
    Navigator.pop(context);
  }

}