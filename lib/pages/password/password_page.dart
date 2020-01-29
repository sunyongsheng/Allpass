import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:allpass/params/allpass_type.dart';
import 'package:allpass/pages/password/edit_password_page.dart';
import 'package:allpass/pages/password/view_password_page.dart';
import 'package:allpass/pages/search/search_page.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/widgets/search_button_widget.dart';
import 'package:allpass/provider/password_list.dart';

/// 密码页面
class PasswordPage extends StatefulWidget {
  @override
  _PasswordPageState createState() {
    return _PasswordPageState();
  }
}

class _PasswordPageState extends State<PasswordPage> with AutomaticKeepAliveClientMixin{

  @override
  void initState() {
    super.initState();
  }

  Future<Null> _query() async {
    await Provider.of<PasswordList>(context).init();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "密码",
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: <Widget>[
          // 搜索框 按钮
          SearchButtonWidget(_searchPress, "密码"),
          // 密码列表
          Expanded(
            child: RefreshIndicator(
               onRefresh: _query,
               child: Scrollbar(
                 child: Consumer<PasswordList>(
                   builder: (context, model, child) {
                     if (model.passwordList.length >= 1) {
                       return ListView.builder(
                         itemBuilder: (context, index) =>
                             PasswordWidgetItem(index),
                         itemCount: model.passwordList.length,
                       );
                     } else {
                       return Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           Padding(
                             padding: AllpassEdgeInsets.smallTBPadding,
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
                               child: Text("这里存储你的密码信息，例如\n微博账号、知乎账号等", textAlign: TextAlign.center,),
                             ),
                             padding: AllpassEdgeInsets.forCardInset,
                           )
                         ],
                       );
                     }
                   },
                 )
               )
            ),
          )
        ],
      ),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
      // 添加 按钮
      floatingActionButton: Consumer<PasswordList>(
        builder: (context, model, _) => FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditPasswordPage(null, "添加密码")))
            .then((resData) {
              if (resData != null) {
                model.insertPassword(resData);
              }
            });
          },
          heroTag: "password",
        ),
      )
    );
  }

  _searchPress () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage(AllpassType.PASSWORD)));
  }
}

class PasswordWidgetItem extends StatelessWidget {
  final int index;

  PasswordWidgetItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordList>(
      builder: (context, model, child) {
        return Container(
          margin: AllpassEdgeInsets.listInset,
          //ListTile可以作为listView的一种子组件类型，支持配置点击事件，一个拥有固定样式的Widget
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getRandomColor(model.passwordList[index].uniqueKey),
              child: Text(
                model.passwordList[index].name.substring(0, 1),
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(model.passwordList[index].name, overflow: TextOverflow.ellipsis,),
            subtitle: Text(model.passwordList[index].username, overflow: TextOverflow.ellipsis,),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ViewPasswordPage(model.passwordList[index])
              )).then((bean) {
                if (bean != null) {
                  if (bean.isChanged) {
                    model.updatePassword(bean);
                  } else {
                    model.deletePassword(model.passwordList[index]);
                  }
                }
              });
            },
          ),
        );
      },
    );
  }
}