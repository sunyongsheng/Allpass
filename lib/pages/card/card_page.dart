import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/model/card_bean.dart';
import 'package:allpass/pages/card/view_and_edit_card_page.dart';
import 'package:allpass/pages/search/search_page.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/params/allpass_type.dart';
import 'package:allpass/dao/card_dao.dart';

/// 卡片页面
class CardPage extends StatefulWidget {
  @override
  _CardPageState createState() {
    return _CardPageState();
  }
}

class _CardPageState extends State<CardPage> {
  CardDao cardDao = CardDao();

  int _currentKey = -1;

  List<CardBean> _cardList = List(); // 所有的PasswordBean
  List<Widget> _cardWidgetList = List(); // 列表

  @override
  void initState() {
    super.initState();
    _getDataFromDB();
  }

  Future<Null> _getDataFromDB() async {
    List<CardBean> data = await cardDao.getAllCardBeanList();
    if (data != null) {
      if (data.length > 0) {
        data.forEach((bean) {
          _cardList.add(bean);
        });
      }
    }
    setState(() {});
  }

  // 查询
  Future<Null> _query() async {
    _cardList.clear();
    List<CardBean> data = await cardDao.getAllCardBeanList();
    if (data != null) {
      if (data.length > 0) {
        data.forEach((bean) {
          _cardList.add(bean);
        });
      }
    }
    setState(() {});
  }

  // 添加
  Future<Null> _add(CardBean newBean) async {
    await cardDao.insert(newBean);
    _query();
  }

  // 删除
  Future<Null> _delete(int key) async {
    await cardDao.deleteCardBeanById(key);
    _query();
  }

  // 更新
  Future<Null> _update(CardBean newBean) async {
    await cardDao.updatePasswordBean(newBean);
    _query();
  }

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
        elevation: 0,
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
                            builder: (context) => SearchPage(AllpassType.CARD)))
                    .then((value) => setState(() {
                          _query();
                        }));
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
          FutureBuilder(
            future: _getCardWidgetList(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return Center(
                    child: Text("加载中..."),
                  );
                case ConnectionState.done:
                  return Expanded(
                    child: ListView(children: _cardWidgetList),
                  );
                default:
                  return Center(
                    child: Text("未知状态，请联系开发者：sys6511@126.com"),
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
          var newData = CardBean(ownerName: "", cardId: "", folder: "默认");
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewAndEditCardPage(newData, "添加卡片", false)))
              .then((resData) {
            if (resData != null) {
              _add(resData);
            }
          });
        },
      ),
    );
  }

  Future<Null> _getCardWidgetList() async {
    _cardWidgetList.clear();
    for (var item in _cardList) {
      _cardWidgetList.add(_getCardWidget(item));
    }
  }

  Widget _getCardWidget(CardBean cardBean) {
    return Dismissible(
      key: Key(cardBean.uniqueKey.toString()),
      onDismissed: (dismissibleDec) {
        _currentKey = cardBean.uniqueKey;
        setState(() {
          _delete(cardBean.uniqueKey).then(
              (_) => Fluttertoast.showToast(msg: "删除了“" + cardBean.name + "”"));
        });
      },
      child: SizedBox(
        height: 100,
        //ListTile可以作为listView的一种子组件类型，支持配置点击事件，一个拥有固定样式的Widget
        child: Card(
          elevation: 10,
          color: getRandomColor(cardBean.uniqueKey),
          margin: EdgeInsets.only(left: 20, right: 20, top: 6, bottom: 12),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
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
            contentPadding: EdgeInsets.only(left: 30, right: 30, top: 4),
            onTap: () {
              _currentKey = cardBean.uniqueKey;
              // 显示模态BottomSheet
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return _createBottomSheet(context, cardBean);
                  });
            },
          ),
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
                              ViewAndEditCardPage(cardBean, "查看卡片", true)))
                  .then((resData) {
                if (resData != null) _update(resData);
              });
            }),
        ListTile(
            leading: Icon(Icons.edit),
            title: Text("编辑"),
            onTap: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewAndEditCardPage(cardBean, "编辑卡片", false)))
                  .then((resData) {
                if (resData != null) _update(resData);
              });
            }),
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
          onTap: () => _delete(_currentKey),
        )
      ],
    );
  }
}
