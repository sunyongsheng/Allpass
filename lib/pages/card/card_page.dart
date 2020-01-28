import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/params/params.dart';
import 'package:allpass/model/card_bean.dart';
import 'package:allpass/pages/card/view_card_page.dart';
import 'package:allpass/pages/card/edit_card_page.dart';
import 'package:allpass/pages/search/search_page.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/params/allpass_type.dart';
import 'package:allpass/dao/card_dao.dart';
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
  CardDao cardDao = CardDao();

  List<Widget> _cardWidgetList = List(); // 列表

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;


  // 查询
  Future<Null> _query() async {
    await Provider.of<CardList>(context).init();
    _getCardWidgetList();
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
          FutureBuilder(
            future: _getCardWidgetList(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: _query,
                      child: Scrollbar(
                        child: ListView.builder(
                          itemBuilder: (context, index) => _cardWidgetList[index],
                          itemCount: _cardWidgetList.length,
                        ),
                      )
                    ),
                  );
                default:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              }
            },
          )
        ],
      ),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
      // 添加按钮
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditCardPage(null, "添加卡片")))
              .then((resData) {
            if (resData != null) {
              Provider.of<CardList>(context).insertCard(resData);
            }
          });
        },
        heroTag: "card",
      ),
    );
  }

  Future<Null> _getCardWidgetList() async {
    _cardWidgetList.clear();
    for (var item in Provider.of<CardList>(context).cardList) {
      try {
        _cardWidgetList.add(_getCardWidget(item));
      } catch (e) {
        print("有问题出现，key=${item.uniqueKey}");
      }
    }
    if (_cardWidgetList.length == 0) {
      _cardWidgetList..add(
          Padding(
            padding: AllpassEdgeInsets.smallTBPadding,
          )
      )..add(Padding(
        child: Center(
          child: Text("什么也没有，赶快添加吧"),
        ),
        padding: AllpassEdgeInsets.forCardInset,
      ))..add(
        Padding(
          padding: AllpassEdgeInsets.smallTBPadding,
        )
      )..add(
        Padding(
          padding: AllpassEdgeInsets.forCardInset,
          child: Center(
            child: Text("这里存储你的卡片信息，例如\n身份证，银行卡或贵宾卡等",textAlign: TextAlign.center,),
          ),
        )
      );
    }
  }

  Widget _getCardWidget(CardBean cardBean) {
    return SizedBox(
        height: 100,
        child: Card(
          elevation: 2,
          color: getRandomColor(cardBean.uniqueKey),
          margin: AllpassEdgeInsets.forCardInset,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(AllpassUI.smallBorderRadius))),
          child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => ViewCardPage(cardBean),
              )).then((bean) {
                if (bean != null) {
                  // 改变了就更新，没改变就删除
                  if (bean.isChanged) {
                    Provider.of<CardList>(context).updateCard(bean);
                  } else {
                    Provider.of<CardList>(context).deleteCard(cardBean);
                  }
                }
              }),
              onLongPress: () async {
                if (Params.longPressCopy) {
                  Clipboard.setData(ClipboardData(text: cardBean.cardId));
                  Fluttertoast.showToast(msg: "已复制卡号");
                } else {
                  Fluttertoast.showToast(msg: "多选");
                }
              },
              child: ListTile(
                title: Text(
                  cardBean.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  "ID: ${cardBean.cardId}",
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
  }

  _searchPress() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage(AllpassType.CARD)));
  }
}
