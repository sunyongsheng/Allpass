import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:allpass/bean/password_bean.dart';
import 'package:allpass/bean/card_bean.dart';
import 'package:allpass/params/allpass_type.dart';
import 'package:allpass/params/card_data.dart';
import 'package:allpass/params/password_data.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/pages/view_and_edit_card_page.dart';
import 'package:allpass/pages/view_and_edit_password_page.dart';

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
      body: ListView(
        children: getSearchResult(),
      ),
    );
  }

  List<Widget> getSearchResult() {
    List<Widget> res = List();
    if (_type == AllpassType.PASSWORD) {
      for (var item in PasswordData.passwordData) {
        if (item.name.contains(_searchText) || item.username.contains(_searchText)) {
          res.add(ListTile(
              title: Text(item.name),
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
      for (var item in CardData.cardData) {
        if (item.name.contains(_searchText) ||
            item.ownerName.contains(_searchText)) {
          res.add(ListTile(
            title: Text(item.name),
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
    return res;
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
                Navigator.pop(context);
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
                .then((reData) => this.setState(() => updatePasswordBean(reData)));
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
                .then((reData) => this.setState(() => updatePasswordBean(reData)));
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
            setState(() {
              int index = -1;
              for (int i = 0; i < PasswordData.passwordData.length; i++) {
                if (_currentKey == PasswordData.passwordData[i].uniqueKey) {
                  index = i;
                  break;
                }
              }
              PasswordData.passwordData.removeAt(index);

            });
          },
        )
      ],
    );
  }

  updatePasswordBean(PasswordBean res) {
    int index = 0;
    for (int i = 0; i < PasswordData.passwordData.length; i++) {
      if (_currentKey == PasswordData.passwordData[i].uniqueKey) {
        index = i;
        break;
      }
    }
    // TODO 以下这种方式修改的名称与用户名可以保存，但是其他数据修改保存再打开就会恢复
    // PasswordData.passwordData[index] = reData;
    copyPasswordBean(PasswordData.passwordData[index], res);
  }

  // 点击卡片弹出模态菜单
  Widget createCardBottomSheet(BuildContext context, CardBean cardBean) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
            leading: Icon(Icons.remove_red_eye),
            title: Text("查看"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ViewAndEditCardPage(cardBean, "查看卡片", true)))
                  .then((resData) => this.setState(() => updateCardBean(resData)));
            }
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text("编辑"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => ViewAndEditCardPage(cardBean, "编辑卡片", false)))
                .then((resData) => this.setState(() => updateCardBean(resData)));
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
          title: Text("删除密码"),
          onTap: () {
            setState(() {
              int index = -1;
              for (int i = 0; i < CardData.cardData.length; i++) {
                if (_currentKey == CardData.cardData[i].uniqueKey) {
                  index = i;
                  break;
                }
              }
              CardData.cardData.removeAt(index);
            });
          },
        )
      ],
    );
  }

  updateCardBean(CardBean res) {
    int index = 0;
    for (int i = 0; i < CardData.cardData.length; i++) {
      if (_currentKey == CardData.cardData[i].uniqueKey) {
        index = i;
        break;
      }
    }
    copyCardBean(CardData.cardData[index], res);
  }
}
