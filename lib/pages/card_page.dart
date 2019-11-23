import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/bean/card_bean.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/params/card_data.dart';
import 'package:allpass/pages/view_and_edit_card_page.dart';
import 'package:allpass/pages/search_page.dart';
import 'package:allpass/params/allpass_type.dart';

/// 卡片页面
class CardPage extends StatefulWidget {
  @override
  _CardPageState createState() {
    return _CardPageState();
  }
}

class _CardPageState extends State<CardPage> {
  int _currentKey = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "卡片",
          style: AllpassTextUI.mainTitleStyle,
        ),
        centerTitle: true,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        toolbarOpacity: 1,
      ),
      body: Column(
        children: <Widget>[
          // 搜索框 按钮
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
            child: FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchPage(AllpassType.CARD)));
              },
              child: Row(
                children: <Widget>[
                  Icon(Icons.search),
                  Text("搜索"),
                ],
              ),
              color: Colors.grey[200],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              splashColor:
                  Colors.grey[200], // 设置成和FlatButton.color一样的值，点击时不会点击效果
            ),
          ),
          // 卡片列表
          Expanded(
            child: ListView(children: _getCardWidgetList()),
          ),
        ],
      ),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
      // 添加按钮
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          var newData = CardBean("", "", folder: "默认", isNew: false);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ViewAndEditCardPage(newData, "添加卡片", false))).then((resData) {
            assert(resData is CardBean);
            this.setState(() {
              if (resData.ownerName != "" && resData.cardId != "") {
                CardData.cardData.add(resData);
                CardData.cardKeySet.add(resData.uniqueKey);
              }
            });
          });
        },
      ),
    );
  }

  List<Widget> _getCardWidgetList() {
    return CardData.cardData.map((card) => _getCardWidget(card)).toList();
  }

  Widget _getCardWidget(CardBean cardBean) {
    return Dismissible(
      key: Key(cardBean.uniqueKey.toString()),
      onDismissed: (dismissibleDec) {
        setState(() {
          Fluttertoast.showToast(msg: "删除了“" + cardBean.name + "”");
          CardData.cardData.remove(cardBean);
          // TODO 是否remove对应的key
        });
      },
      child: Container(
        width: 150,
        height: 70,
        //ListTile可以作为listView的一种子组件类型，支持配置点击事件，一个拥有固定样式的Widget
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor:
                cardBean.hashCode % 2 == 1 ? Colors.blue : Colors.amberAccent,
            child: Text(
              cardBean.name.substring(0, 1),
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: Text(cardBean.name),
          subtitle: Text(cardBean.ownerName),
          onTap: () {
            print("点击了卡片：" + cardBean.name);
            // 显示模态BottomSheet
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return _createBottomSheet(context, cardBean);
                });
          },
        ),
      ),
    );
  }

  // 点击卡片弹出模态菜单
  Widget _createBottomSheet(BuildContext context, CardBean cardBean) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
            leading: Icon(Icons.remove_red_eye),
            title: Text("查看"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewAndEditCardPage(cardBean, "查看卡片", true))).then(
                  (resData) => this.setState(() => updateCardBean(resData, _currentKey)));
            }),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text("编辑"),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ViewAndEditCardPage(cardBean, "编辑卡片", false))).then(
                (resData) => this.setState(() => updateCardBean(resData, _currentKey)));
          },
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text("复制用户名"),
          onTap: () {
            Clipboard.setData(ClipboardData(text: cardBean.ownerName));
          },
        ),
        ListTile(
          leading: Icon(Icons.content_copy),
          title: Text("复制卡号"),
          onTap: () {
            Clipboard.setData(ClipboardData(text: cardBean.cardId));
          },
        ),
        ListTile(
          leading: Icon(Icons.delete_outline),
          title: Text("删除卡片"),
          onTap: () => setState(() => deleteCardBean(_currentKey)),
        )
      ],
    );
  }
}
