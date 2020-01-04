import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:allpass/model/password_bean.dart';
import 'package:allpass/model/card_bean.dart';
import 'package:allpass/params/allpass_type.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/encrypt_util.dart';
import 'package:allpass/provider/card_list.dart';
import 'package:allpass/provider/password_list.dart';
import 'package:allpass/pages/card/view_and_edit_card_page.dart';
import 'package:allpass/pages/password/edit_password_page.dart';
import 'package:allpass/pages/password/view_password_page.dart';

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
  List<Widget> _result = List();

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
        brightness: Brightness.light,
      ),
      body: FutureBuilder(
        future: getSearchResult(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              return _result.length == 0
                  ? Center(
                      child: Text("无结果"),
                    )
                  : ListView.builder(
                      itemBuilder: (_, index) => _result[index],
                      itemCount: _result.length,
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
      for (var item in Provider.of<PasswordList>(context).passwordList) {
        if (item.name.contains(_searchText) ||
            item.username.contains(_searchText) ||
            item.notes.contains(_searchText)) {
          _result.add(ListTile(
            leading: CircleAvatar(
              backgroundColor: getRandomColor(item.uniqueKey),
              child: Text(
                item.name.substring(0, 1),
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(item.name),
            subtitle: Text(item.username),
            onTap: () {
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
      for (var item in Provider.of<CardList>(context).cardList) {
        Color t = getRandomColor(item.uniqueKey);
        if (item.name.contains(_searchText) ||
            item.ownerName.contains(_searchText) ||
            item.notes.contains(_searchText)) {
          _result.add(ListTile(
            leading: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: t
              ),
              child: CircleAvatar(
                backgroundColor: t,
                child: Text(
                  item.name.substring(0, 1),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            title: Text(item.name),
            subtitle: Text(item.ownerName),
            onTap: () {
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
                        top: 0, bottom: 31, left: 15, right: 15),
                    alignment: Alignment.center,
                    height: 50.0,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: null,
                        borderRadius: new BorderRadius.circular(25.0)),
                    child: TextField(
                      decoration: InputDecoration.collapsed(hintText: ""),
                      style: AllpassTextUI.firstTitleStyleBlack,
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
                            ViewPasswordPage(data)))
                .then((reData) {
              if (reData != null) {
                if (reData.isChanged) {
                  Provider.of<PasswordList>(context).updatePassword(reData);
                } else {
                  Provider.of<PasswordList>(context).deletePassword(data);
                }
              }
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
                            EditPasswordPage(data, "编辑密码")))
                .then((reData) {
              if (reData != null) {
                if (reData.isChanged) {
                  Provider.of<PasswordList>(context).updatePassword(reData);
                }
              }
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
          onTap: () async {
            String pw = await EncryptUtil.decrypt(data.password);
            print("复制密码：" + pw);
            Clipboard.setData(ClipboardData(text: pw));
          },
        ),
        ListTile(
          leading: Icon(Icons.delete_outline),
          title: Text("删除密码"),
          onTap: () {
            Provider.of<PasswordList>(context).deletePassword(data);
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
                if (resData != null) Provider.of<CardList>(context).updateCard(resData);
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
                if (resData != null) Provider.of<CardList>(context).updateCard(resData);
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
          onTap: () => Provider.of<CardList>(context).deleteCard(data)
        )
      ],
    );
  }
}
