import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:allpass/model/password_bean.dart';
import 'package:allpass/model/card_bean.dart';
import 'package:allpass/params/allpass_type.dart';
import 'package:allpass/pages/card/view_and_edit_card_page.dart';
import 'package:allpass/pages/password/view_and_edit_password_page.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/dao/card_dao.dart';
import 'package:allpass/dao/password_dao.dart';

class SearchPage extends StatefulWidget {
  final AllpassType type;

  SearchPage(this.type);

  @override
  State<SearchPage> createState() => _SearchPage(type);
}

class _SearchPage extends State<SearchPage> {
  final AllpassType _type;

  String _searchText = "";
  var _searchController;
  List<dynamic> _searchList = List();
  List<Widget> _result = List();

  PasswordDao passwordDao = PasswordDao();
  CardDao cardDao = CardDao();

  int _currentKey = -1;

  _SearchPage(this._type) {
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchWidget(),
        automaticallyImplyLeading: false,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        toolbarOpacity: 1,
      ),
      body: FutureBuilder(
        future: getSearchResult(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(
                child: Text("搜索中..."),
              );
            case ConnectionState.done:
              return _result.length == 0
                  ? Center(
                      child: Text("无结果"),
                    )
                  : ListView(
                      children: _result,
                    );
            default:
              return Center(child: Text("未知状态，请联系开发者：sys6511@126.com"));
          }
        },
      ),
    );
  }

  Future<Null> getSearchResult() async {
    _result.clear();
    if (_type == AllpassType.PASSWORD) {
      _searchList = await passwordDao.getAllPasswordBeanList();
      for (var item in _searchList) {
        if (item.categoryName.contains(_searchText) ||
            item.username.contains(_searchText) ||
            item.notes.contains(_searchText)) {
          _result.add(ListTile(
              title: Text(item.categoryName),
              subtitle: Text(item.username),
              onTap: () {
                _currentKey = item.uniqueKey;
                // 显示模态BottomSheet
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return createPassBottomSheet(context, item);
                    });
              }));
        }
      }
    } else {
      _searchList = await cardDao.getAllCardBeanList();
      for (var item in _searchList) {
        if (item.categoryName.contains(_searchText) ||
            item.ownerName.contains(_searchText) ||
            item.notes.contains(_searchText)) {
          _result.add(ListTile(
            title: Text(item.categoryName),
            subtitle: Text(item.ownerName),
            onTap: () {
              _currentKey = item.uniqueKey;
              // 显示模态BottomSheet
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return createCardBottomSheet(context, item);
                  });
            },
          ));
        }
      }
    }
  }

  /// 搜索栏
  Widget searchWidget() {
    return Container(
        padding: EdgeInsets.only(left: 0, right: 0, bottom: 11, top: 11),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 40),
                child: Container(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 15, right: 15),
                    alignment: Alignment.center,
                    height: 60.0,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: null,
                        borderRadius: new BorderRadius.circular(25.0)),
                    child: TextField(
                      decoration: InputDecoration.collapsed(hintText: ""),
                      style: AllpassTextUI.secondTitleStyleBlack,
                      controller: _searchController,
                      autofocus: true,
                      onEditingComplete: () {
                        setState(() {
                          _searchText = _searchController.text;
                        });
                      },
                    )),
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: Text("取消", style: AllpassTextUI.secondTitleStyleBlack),
              splashColor: AllpassColorUI.mainBackgroundColor,
            ),
          ],
        ));
  }

  /// 以下代码与password_page和card_page的重复
  // 点击密码弹出模态菜单
  Widget createPassBottomSheet(BuildContext context, PasswordBean data) {
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
                            ViewAndEditPasswordPage(data, "查看密码", true)))
                .then((reData) {
              if (reData != null) passwordDao.updatePasswordBean(reData);
            });
          },
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text("编辑"),
          onTap: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ViewAndEditPasswordPage(data, "编辑密码", false)))
                .then((reData) {
              if (reData != null) passwordDao.updatePasswordBean(reData);
            });
          },
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text("复制用户名"),
          onTap: () {
            print("复制用户名：" + data.username);
            Clipboard.setData(ClipboardData(text: data.username));
          },
        ),
        ListTile(
          leading: Icon(Icons.content_copy),
          title: Text("复制密码"),
          onTap: () {
            print("复制密码：" + data.password);
            Clipboard.setData(ClipboardData(text: data.password));
          },
        ),
        ListTile(
          leading: Icon(Icons.delete_outline),
          title: Text("删除密码"),
          onTap: () {
            passwordDao.deletePasswordBeanById(_currentKey);
          },
        )
      ],
    );
  }

  // 点击卡片弹出模态菜单
  Widget createCardBottomSheet(BuildContext context, CardBean data) {
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
                              ViewAndEditCardPage(data, "查看卡片", true)))
                  .then((resData) {
                if (resData != null) cardDao.updatePasswordBean(resData);
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
                              ViewAndEditCardPage(data, "编辑卡片", false)))
                  .then((resData) {
                if (resData != null) cardDao.updatePasswordBean(resData);
              });
            }),
        ListTile(
          leading: Icon(Icons.person),
          title: Text("复制用户名"),
          onTap: () {
            Clipboard.setData(ClipboardData(text: data.ownerName));
          },
        ),
        ListTile(
          leading: Icon(Icons.content_copy),
          title: Text("复制卡号"),
          onTap: () {
            Clipboard.setData(ClipboardData(text: data.cardId));
          },
        ),
        ListTile(
          leading: Icon(Icons.delete_outline),
          title: Text("删除卡片"),
          onTap: () => cardDao.deleteCardBeanById(_currentKey),
        )
      ],
    );
  }
}
