import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/params/runtime_data.dart';
import 'package:allpass/params/allpass_type.dart';
import 'package:allpass/pages/password/edit_password_page.dart';
import 'package:allpass/pages/password/password_widget_item.dart';
import 'package:allpass/pages/search/search_page.dart';
import 'package:allpass/ui/allpass_ui.dart';
import 'package:allpass/utils/screen_util.dart';
import 'package:allpass/widgets/common/search_button_widget.dart';
import 'package:allpass/widgets/common/confirm_dialog.dart';
import 'package:allpass/widgets/common/select_item_dialog.dart';
import 'package:allpass/provider/password_list.dart';

/// 密码页面
class PasswordPage extends StatefulWidget {
  @override
  _PasswordPageState createState() {
    return _PasswordPageState();
  }
}

class _PasswordPageState extends State<PasswordPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<Null> _query() async {
    await Provider.of<PasswordList>(context).init();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: AllpassEdgeInsets.smallLPadding,
            child: InkWell(
              splashColor: Colors.transparent,
              child: Text("密码", style: AllpassTextUI.titleBarStyle,),
              onTap: () {
                _controller.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
              },
            ),
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            RuntimeData.multiSelected
                ? Row(
              children: <Widget>[
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case "删除":
                        _deletePassword(context);
                        break;
                      case "移动":
                        _movePassword(context);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        value: "移动",
                        child: Text("移动")
                    ),
                    PopupMenuItem(
                      value: "删除",
                      child: Text("删除")
                    ),
                  ]
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallLPadding,
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  child: Icon(Icons.select_all),
                  onTap: () {
                    if (RuntimeData.multiPasswordList.length != Provider.of<PasswordList>(context).passwordList.length) {
                      RuntimeData.multiPasswordList.clear();
                      setState(() {
                        RuntimeData.multiPasswordList.addAll(Provider.of<PasswordList>(context).passwordList);
                      });
                    } else {
                      setState(() {
                        RuntimeData.multiPasswordList.clear();
                      });
                    }
                  },
                ),
              ],
            ) : Container(),
            Padding(
              padding: AllpassEdgeInsets.smallLPadding,
            ),
            InkWell(
              splashColor: Colors.transparent,
              child: RuntimeData.multiSelected ? Icon(Icons.clear) : Icon(Icons.sort),
              onTap: () {
                setState(() {
                  RuntimeData.multiPasswordList.clear();
                  RuntimeData.multiSelected = !RuntimeData.multiSelected;
                });
              },
            ),
            Padding(
              padding: AllpassEdgeInsets.smallLPadding,
            ),
            Padding(
              padding: AllpassEdgeInsets.smallLPadding,
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            // 搜索框 按钮
            SearchButtonWidget(_searchPress, "密码"),
            // 密码列表
            Expanded(
              child: RefreshIndicator(
                  onRefresh: _query,
                  child: Scrollbar(
                    child: Provider.of<PasswordList>(context).passwordList.length >= 1
                        ? RuntimeData.multiSelected
                            ? ListView.builder(
                                controller: _controller,
                                itemBuilder: (context, index) => MultiPasswordWidgetItem(index),
                                itemCount: Provider.of<PasswordList>(context).passwordList.length,
                              )
                            : ListView.builder(
                                controller: _controller,
                                itemBuilder: (context, index) => PasswordWidgetItem(index),
                                itemCount: Provider.of<PasswordList>(context).passwordList.length,
                              )
                        : ListView(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: AllpassScreenUtil.setHeight(400)),
                              ),
                              Padding(
                                child: Center(child: Text("什么也没有，赶快添加吧"),),
                                padding: AllpassEdgeInsets.forCardInset,
                              ),
                              Padding(
                                padding: AllpassEdgeInsets.smallTBPadding,
                              ),
                              Padding(
                                child: Center(
                                  child: Text(
                                    "这里存储你的密码信息，例如\n微博账号、知乎账号等",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                padding: AllpassEdgeInsets.forCardInset,
                              )
                            ],
                          ),
                  )),
            )
          ],
        ),
        // 添加 按钮
        floatingActionButton: Consumer<PasswordList>(
          builder: (context, model, _) => FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => EditPasswordPage(null, "添加密码")))
                  .then((resData) async {
                if (resData != null) {
                  model.insertPassword(resData);
                  if (RuntimeData.newPasswordOrCardCount >= 3) {
                    await Provider.of<PasswordList>(context).refresh();
                  }
                }
              });
            },
            heroTag: "password",
          ),
        ));
  }

  _searchPress () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage(AllpassType.PASSWORD)));
  }

  void _deletePassword(BuildContext context) {
    if (RuntimeData.multiPasswordList.length == 0) {
      Fluttertoast.showToast(msg: "请选择至少一项密码");
    } else {
      showDialog<bool>(
          context: context,
          builder: (context) => ConfirmDialog("确认删除",
              "您将删除${RuntimeData.multiPasswordList.length}项密码，确认吗？"))
          .then((confirm) {
        if (confirm) {
          for (var item in RuntimeData.multiPasswordList) {
            Provider.of<PasswordList>(context).deletePassword(item);
          }
          RuntimeData.multiPasswordList.clear();
        }
      });
    }
  }

  void _movePassword(BuildContext context) {
    if (RuntimeData.multiPasswordList.length == 0) {
      Fluttertoast.showToast(msg: "请选择至少一项密码");
    } else {
      showDialog(
          context: context,
          builder: (context) => SelectItemDialog())
          .then((value) async {
        if (value != null) {
          for (int i = 0; i < RuntimeData.multiPasswordList.length; i++) {
            RuntimeData.multiPasswordList[i].folder = value;
            await Provider.of<PasswordList>(context).updatePassword(RuntimeData.multiPasswordList[i]);
          }
          Fluttertoast.showToast(msg: "已移动${RuntimeData.multiPasswordList.length}项密码至 $value 文件夹");
          setState(() {
            RuntimeData.multiPasswordList.clear();
          });
        }
      });
    }
  }
}