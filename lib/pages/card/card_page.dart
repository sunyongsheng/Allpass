import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:allpass/params/params.dart';
import 'package:allpass/pages/card/card_widget_item.dart';
import 'package:allpass/pages/card/edit_card_page.dart';
import 'package:allpass/pages/search/search_page.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/screen_util.dart';
import 'package:allpass/params/allpass_type.dart';
import 'package:allpass/widgets/search_button_widget.dart';
import 'package:allpass/widgets/confirm_dialog.dart';
import 'package:allpass/provider/card_list.dart';

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
  Future<Null> _query() async {
    await Provider.of<CardList>(context).init();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        elevation: 0,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          Params.multiSelected
              ? InkWell(
            splashColor: Colors.transparent,
            child: Icon(Icons.delete_outline),
            onTap: () {
              showDialog<bool>(
                  context: context,
                  builder: (context) => ConfirmDialog(
                      "确认删除",
                      "您将删除${Params.multiCardList.length}项卡片，确认吗？"
                  )
              ).then((confirm) {
                if (confirm) {
                  for (var item in Params.multiCardList) {
                    Provider.of<CardList>(context).deleteCard(item);
                  }
                  Params.multiCardList.clear();
                }
              });
            },
          ) : Container(),
          FlatButton(
            splashColor: Colors.transparent,
            child: Params.multiSelected ? Text("取消") : Text("多选"),
            onPressed: () {
              setState(() {
                Params.multiCardList.clear();
                Params.multiSelected = !Params.multiSelected;
              });
            },
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
                onRefresh: _query,
                child: Scrollbar(
                    child: Consumer<CardList>(
                      builder: (context, model, _) {
                        if (model.cardList.length >= 1) {
                          return Params.multiSelected
                            ? ListView.builder(
                              controller: _controller,
                              itemBuilder: (context, index) =>
                                  MultiCardWidgetItem(index),
                              itemCount: model.cardList.length,
                            )
                            : ListView.builder(
                              controller: _controller,
                              itemBuilder: (context, index) =>
                                  CardWidgetItem(index),
                              itemCount: model.cardList.length,
                            );
                        } else {
                          return ListView(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: AllpassScreenUtil.setHeight(400)),
                              ),
                              Padding(
                                child: Center(
                                  child: Text("什么也没有，赶快添加吧"),
                                ),
                                padding: AllpassEdgeInsets.forCardInset,
                              ),
                              Padding(
                                padding: AllpassEdgeInsets.smallTBPadding,
                              ),
                              Padding(
                                child: Center(
                                  child: Text("这里存储你的卡片信息，例如\n身份证，银行卡或贵宾卡等",textAlign: TextAlign.center,),
                                ),
                                padding: AllpassEdgeInsets.forCardInset,
                              )
                            ],
                          );
                        }
                      }
                    )
                )
            ),
          )
        ],
      ),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
      // 添加按钮
      floatingActionButton: Consumer<CardList>(
        builder: (context, model, _) => FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditCardPage(null, "添加卡片")))
                .then((resData) {
              if (resData != null) {
                model.insertCard(resData);
              }
            });
          },
          heroTag: "card",
        ),
      )
    );
  }

  _searchPress() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage(AllpassType.CARD)));
  }
}
