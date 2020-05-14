import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/ui/allpass_ui.dart';
import 'package:allpass/params/allpass_type.dart';
import 'package:allpass/params/runtime_data.dart';
import 'package:allpass/provider/card_list.dart';
import 'package:allpass/pages/card/card_widget_item.dart';
import 'package:allpass/pages/card/edit_card_page.dart';
import 'package:allpass/pages/search/search_page.dart';
import 'package:allpass/widgets/common/search_button_widget.dart';
import 'package:allpass/widgets/common/confirm_dialog.dart';
import 'package:allpass/widgets/common/select_item_dialog.dart';
import 'package:allpass/widgets/common/nodata_widget.dart';

/// 卡片页面
class CardPage extends StatefulWidget {
  @override
  _CardPageState createState() {
    return _CardPageState();
  }
}

class _CardPageState extends State<CardPage> with AutomaticKeepAliveClientMixin {

  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  bool get wantKeepAlive => true;


  // 查询
  Future<Null> _query(CardList model) async {
    await model.refresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<CardList>(
      builder: (context, model, _) {
        return Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: AllpassEdgeInsets.smallLPadding,
                child: InkWell(
                  splashColor: Colors.transparent,
                  child: Text(
                    "卡片",
                    style: AllpassTextUI.titleBarStyle,
                  ),
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
                              _deleteCard(context, model);
                              break;
                            case "移动":
                              _moveCard(context, model);
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
                        if (RuntimeData.multiCardList.length != model.count) {
                          RuntimeData.multiCardList.clear();
                          setState(() {
                            RuntimeData.multiCardList.addAll(model.cardList);
                          });
                        } else {
                          setState(() {
                            RuntimeData.multiCardList.clear();
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
                      RuntimeData.multiCardList.clear();
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
                SearchButtonWidget(_searchPress, "卡片"),
                // 卡片列表
                Expanded(
                  child: RefreshIndicator(
                      onRefresh: () => _query(model),
                      child: Scrollbar(
                          child: model.count >= 1
                              ? RuntimeData.multiSelected
                              ? ListView.builder(
                            controller: _controller,
                            itemBuilder: (context, index) => MultiCardWidgetItem(index),
                            itemCount: model.count,
                          )
                              : ListView.builder(
                            controller: _controller,
                            itemBuilder: (context, index) => CardWidgetItem(index),
                            itemCount: model.count,
                          )
                              : NoDataWidget("这里存储你的卡片信息，例如\n身份证，银行卡或贵宾卡等")
                      )
                  ),
                )
              ],
            ),
            // 添加按钮
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) =>
                            EditCardPage(null, "添加卡片")))
                    .then((resData) async {
                  if (resData != null) {
                    await model.insertCard(resData);
                    if (RuntimeData.newPasswordOrCardCount >= 3) {
                      await model.refresh();
                    }
                  }
                });
              },
              heroTag: "card",
            ),
        );
      },
    );
  }

  _searchPress() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage(AllpassType.CARD)));
  }

  void _deleteCard(BuildContext context, CardList model) {
    if (RuntimeData.multiCardList.length == 0) {
      Fluttertoast.showToast(msg: "请选择至少一项卡片");
    } else {
      showDialog<bool>(
          context: context,
          builder: (context) => ConfirmDialog("确认删除", "您将删除${RuntimeData.multiCardList.length}项卡片，确认吗？"))
          .then((confirm) async {
        if (confirm) {
          for (var item in RuntimeData.multiCardList) {
            await model.deleteCard(item);
          }
          RuntimeData.multiCardList.clear();
        }
      });
    }
  }

  void _moveCard(BuildContext context, CardList model) {
    if (RuntimeData.multiCardList.length == 0) {
      Fluttertoast.showToast(msg: "请选择至少一项卡片");
    } else {
      showDialog(
          context: context,
          builder: (context) => SelectItemDialog())
          .then((value) async {
        if (value != null) {
          for (int i = 0; i < RuntimeData.multiCardList.length; i++) {
            RuntimeData.multiCardList[i].folder = value;
            await model.updateCard(RuntimeData.multiCardList[i]);
          }
          Fluttertoast.showToast(msg: "已移动${RuntimeData.multiCardList.length}项密码至 $value 文件夹");
          setState(() {
            RuntimeData.multiCardList.clear();
          });
        }
      });
    }
  }
}
