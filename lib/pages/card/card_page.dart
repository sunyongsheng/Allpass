import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/params/params.dart';
import 'package:allpass/pages/card/view_card_page.dart';
import 'package:allpass/pages/card/edit_card_page.dart';
import 'package:allpass/pages/search/search_page.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/params/allpass_type.dart';
import 'package:allpass/widgets/search_button_widget.dart';
import 'package:allpass/provider/card_list.dart';

/// 卡片页面
class CardPage extends StatefulWidget {
  @override
  _CardPageState createState() {
    return _CardPageState();
  }
}

class _CardPageState extends State<CardPage> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    super.initState();
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
        title: Text(
          "卡片",
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        elevation: 0,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.black),
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
                      builder: (context, model, _) => ListView.builder(
                        itemBuilder: (context, index) => CardWidgetItem(index),
                        itemCount: model.cardList.length,
                      ),
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

class CardWidgetItem extends StatelessWidget {
  final int index;
  CardWidgetItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Consumer<CardList>(
      builder: (context, model, _) {
        return SizedBox(
          height: 100,
          child: Card(
            elevation: 2,
            color: getRandomColor(model.cardList[index].uniqueKey),
            margin: AllpassEdgeInsets.forCardInset,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(AllpassUI.smallBorderRadius))),
            child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => ViewCardPage(model.cardList[index]),
              )).then((bean) {
                if (bean != null) {
                  // 改变了就更新，没改变就删除
                  if (bean.isChanged) {
                    model.updateCard(bean);
                  } else {
                    model.deleteCard(model.cardList[index]);
                  }
                }
              }),
              onLongPress: () async {
                if (Params.longPressCopy) {
                  Clipboard.setData(ClipboardData(text: model.cardList[index].cardId));
                  Fluttertoast.showToast(msg: "已复制卡号");
                } else {
                  Fluttertoast.showToast(msg: "多选");
                }
              },
              child: ListTile(
                title: Text(
                  model.cardList[index].name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  "ID: ${model.cardList[index].cardId}",
                  style:
                  TextStyle(color: Colors.white, letterSpacing: 1, height: 1.7),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                contentPadding: EdgeInsets.only(left: 30, right: 30, top: 5),
              ),
            ),
          ),
        );
      },
    );
  }
}
