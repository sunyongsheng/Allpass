import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/model/base_model.dart';
import 'package:allpass/model/password_bean.dart';
import 'package:allpass/model/card_bean.dart';
import 'package:allpass/params/config.dart';
import 'package:allpass/params/allpass_type.dart';
import 'package:allpass/ui/allpass_ui.dart';
import 'package:allpass/utils/encrypt_util.dart';
import 'package:allpass/utils/string_process.dart';
import 'package:allpass/provider/card_list.dart';
import 'package:allpass/provider/password_list.dart';
import 'package:allpass/pages/card/view_card_page.dart';
import 'package:allpass/pages/card/edit_card_page.dart';
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
  TextEditingController _searchController;
  List<Widget> _result = List();

  _SearchPage(this._type) {
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchWidget(),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: getSearchResult(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
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
    _searchText = _searchController.text.toLowerCase();
    if (_type == AllpassType.PASSWORD) {
      for (var item in Provider.of<PasswordList>(context).passwordList) {
        if (containsKeyword(item)) {
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AllpassUI.smallBorderRadius),
                        topRight: Radius.circular(AllpassUI.smallBorderRadius)
                    )
                ),
                context: context,
                builder: (BuildContext context) {
                  return createPassBottomSheet(context, item);
                });
            }));
        }
      }
    } else {
      for (var item in Provider.of<CardList>(context).cardList) {
        if (containsKeyword(item)) {
          _result.add(ListTile(
            leading: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius),
                  color: getRandomColor(item.uniqueKey),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AllpassUI.smallBorderRadius),
                        topRight: Radius.circular(AllpassUI.smallBorderRadius)
                    )
                ),
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

  bool containsKeyword(BaseModel baseModel) {
    if (baseModel is PasswordBean) {
      return baseModel.name.toLowerCase().contains(_searchText) ||
          baseModel.username.toLowerCase().contains(_searchText) ||
          baseModel.notes.toLowerCase().contains(_searchText) ||
          list2PureStr(baseModel.label).toLowerCase().contains(_searchText);
    } else if (baseModel is CardBean) {
      return baseModel.name.toLowerCase().contains(_searchText) ||
          baseModel.ownerName.toLowerCase().contains(_searchText) ||
          baseModel.notes.toLowerCase().contains(_searchText) ||
          list2PureStr(baseModel.label).toLowerCase().contains(_searchText);
    }
    return false;
  }

  /// 搜索栏
  Widget searchWidget() {
    return Container(
        padding: EdgeInsets.only(left: 0, right: 0, bottom: 11, top: 11),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  color: Config.theme == 'dark' ? Colors.black : Colors.grey[200],
                ),
                height: 35,
                child: TextField(
                  style: TextStyle(fontSize: 14),
                  controller: _searchController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 20, right: 20),
                    hintText: "搜索名称、用户名、备注或关键字",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Config.theme == 'dark'
                          ? Colors.grey
                          : Colors.grey[900],),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide.none
                    ),
                  ),
                  onChanged: (_) async {
                    await getSearchResult();
                    setState(() {});
                  },
                  onEditingComplete: () async {
                    await Provider.of<PasswordList>(context).init();
                    await Provider.of<CardList>(context).init();
                    await getSearchResult();
                    setState(() {});
                  },
                  autofocus: true,
                ),
              )
            ),
            InkWell(
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                child: Text("取消", style: AllpassTextUI.secondTitleStyle),
              ),
              onTap: () => Navigator.pop(context),
            )
          ],
        ));
  }

  // 点击密码弹出模态菜单
  Widget createPassBottomSheet(BuildContext context, PasswordBean data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.remove_red_eye, color: Colors.lightGreen,),
          title: Text("查看"),
          onTap: () {
            Navigator.push(context,
                CupertinoPageRoute(
                      builder: (context) => ViewPasswordPage(data)))
                .then((reData) {
              if (reData != null) {
                if (reData.isChanged) {
                  Provider.of<PasswordList>(context).updatePassword(reData);
                } else {
                  Provider.of<PasswordList>(context).deletePassword(data);
                }
              }
              Navigator.pop(context);
            });
          },
        ),
        ListTile(
          leading: Icon(Icons.edit, color: Colors.blue,),
          title: Text("编辑"),
          onTap: () {
            Navigator.push(context,
                CupertinoPageRoute(
                  builder: (context) => EditPasswordPage(data, "编辑密码")))
                .then((reData) {
              if (reData != null) {
                if (reData.isChanged) {
                  Provider.of<PasswordList>(context).updatePassword(reData);
                } else {
                  Provider.of<PasswordList>(context).deletePassword(data);
                }
              }
              Navigator.pop(context);
            });
          },
        ),
        ListTile(
          leading: Icon(Icons.person, color: Colors.teal,),
          title: Text("复制用户名"),
          onTap: () {
            Clipboard.setData(ClipboardData(text: data.username));
            Fluttertoast.showToast(msg: "已复制用户名");
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.content_copy, color: Colors.orange,),
          title: Text("复制密码"),
          onTap: () async {
            String pw = EncryptUtil.decrypt(data.password);
            Clipboard.setData(ClipboardData(text: pw));
            Fluttertoast.showToast(msg: "已复制密码");
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.delete_outline, color: Colors.red,),
          title: Text("删除密码"),
          onTap: () {
            Provider.of<PasswordList>(context).deletePassword(data);
            Navigator.pop(context);
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
          leading: Icon(Icons.remove_red_eye, color: Colors.lightGreen,),
          title: Text("查看"),
          onTap: () {
            Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) =>
                            ViewCardPage(data)))
                .then((resData) {
              if (resData != null) {
                if (resData.isChanged) {
                  Provider.of<CardList>(context).updateCard(resData);
                } else {
                  Provider.of<CardList>(context).deleteCard(resData);
                }
              }
              Navigator.pop(context);
            });
          }),
        ListTile(
          leading: Icon(Icons.edit, color: Colors.blue,),
          title: Text("编辑"),
          onTap: () {
            Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) =>
                            EditCardPage(data, "编辑卡片")))
                .then((resData) {
              if (resData != null) {
                if (resData.isChanged) {
                  Provider.of<CardList>(context).updateCard(resData);
                } else {
                  Provider.of<CardList>(context).deleteCard(resData);
                }
              }
              Navigator.pop(context);
            });
          }),
        ListTile(
          leading: Icon(Icons.person, color: Colors.teal,),
          title: Text("复制用户名"),
          onTap: () {
            Clipboard.setData(ClipboardData(text: data.ownerName));
            Fluttertoast.showToast(msg: "已复制用户名");
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.content_copy, color: Colors.orange,),
          title: Text("复制卡号"),
          onTap: () {
            Clipboard.setData(ClipboardData(text: data.cardId));
            Fluttertoast.showToast(msg: "已复制卡号");
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.delete_outline, color: Colors.red,),
          title: Text("删除卡片"),
          onTap: () {
            Provider.of<CardList>(context).deleteCard(data);
            Navigator.pop(context);
          }
        )
      ],
    );
  }
}
