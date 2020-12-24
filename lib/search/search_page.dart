import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/core/param/config.dart';
import 'package:allpass/core/param/allpass_type.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/password/widget/password_widget_item.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/card/widget/card_widget_item.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/widget/confirm_dialog.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/card/page/view_card_page.dart';
import 'package:allpass/card/page/edit_card_page.dart';
import 'package:allpass/password/page/edit_password_page.dart';
import 'package:allpass/password/page/view_password_page.dart';
import 'package:allpass/search/search_provider.dart';

class SearchPage extends StatefulWidget {
  final AllpassType type;

  SearchPage(this.type);

  @override
  State<SearchPage> createState() => _SearchPage(type);
}

class _SearchPage extends State<SearchPage> {
  final AllpassType _type;

  TextEditingController _searchController;

  _SearchPage(this._type);

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (_, provider, __) {
        return Scaffold(
            appBar: AppBar(
              title: searchWidget(provider),
              automaticallyImplyLeading: false,
            ),
            body: provider.empty()
                ? Center(child: Text("无结果"),)
                : ListView.builder(
              itemBuilder: (_, index) => getSearchWidget(provider, index),
              itemCount: provider.length())
        );
      }
    );
  }

  Widget getSearchWidget(SearchProvider provider, int index) {
    if (_type == AllpassType.Password) {
      var item = provider.passwordSearch[index];
      return PasswordWidgetItem(
        data: item,
        onPasswordClicked: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return createPassBottomSheet(context, item);
              });
        },
      );
    } else if (_type == AllpassType.Card) {
      var item = provider.cardSearch[index];
      return SimpleCardWidgetItem(
        data: provider.cardSearch[index],
        onCardClicked: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return createCardBottomSheet(context, item);
              });
        },
      );
    }
    return Container();
  }

  /// 搜索栏
  Widget searchWidget(SearchProvider provider) {
    return Container(
        padding: EdgeInsets.only(left: 0, right: 0, bottom: 11, top: 11),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(AllpassUI.smallBorderRadius)),
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                height: 35,
                child: TextField(
                  style: TextStyle(fontSize: 14),
                  controller: _searchController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 20, right: 20),
                    hintText: "搜索名称、用户名、备注或标签",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Config.lightTheme == 'dark'
                          ? Colors.grey
                          : Colors.grey[900],),
                  ),
                  onChanged: (_) {
                    provider.search(_searchController.text.toLowerCase());
                  },
                  onEditingComplete: () {
                    provider.search(_searchController.text.toLowerCase());
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
            int index = Provider.of<PasswordProvider>(context).passwordList.indexOf(data);
            Navigator.push(context, CupertinoPageRoute(
                builder: (context) => ViewPasswordPage(index)))
                .then((_) => Navigator.pop(context));
          },
        ),
        ListTile(
          leading: Icon(Icons.edit, color: Colors.blue,),
          title: Text("编辑"),
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(
                builder: (context) => EditPasswordPage(data, DataOperation.update)))
                .then((reData) => Navigator.pop(context));
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
          onTap: () async {
            bool delete = await showDialog(
                context: context,
                builder: (context) => ConfirmDialog("确认删除", "你将删除此密码，确认吗？"));
            if (delete) {
              await Provider.of<PasswordProvider>(context).deletePassword(data);
              Fluttertoast.showToast(msg: "删除成功");
              Navigator.pop(context);
            }
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
            int index = Provider.of<CardProvider>(context).cardList.indexOf(data);
            Navigator.push(context, CupertinoPageRoute(
                builder: (context) => ViewCardPage(index)))
                .then((_) => Navigator.pop(context));
          }),
        ListTile(
          leading: Icon(Icons.edit, color: Colors.blue,),
          title: Text("编辑"),
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(
                builder: (context) => EditCardPage(data, DataOperation.update)))
                .then((_) => Navigator.pop(context));
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
          onTap: () async {
            bool delete = await showDialog(
                context: context,
                builder: (context) => ConfirmDialog("确认删除", "你将删除此卡片，确认吗？"));
            if (delete) {
              await Provider.of<CardProvider>(context).deleteCard(data);
              Fluttertoast.showToast(msg: "删除成功");
              Navigator.pop(context);
            }
          }
        )
      ],
    );
  }
}
