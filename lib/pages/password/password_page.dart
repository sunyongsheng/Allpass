import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/params/params.dart';
import 'package:allpass/params/allpass_type.dart';
import 'package:allpass/model/password_bean.dart';
import 'package:allpass/pages/password/edit_password_page.dart';
import 'package:allpass/pages/password/view_password_page.dart';
import 'package:allpass/pages/search/search_page.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/encrypt_util.dart';
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

  List<Widget> _passWidgetList = List(); // 列表

  @override
  void initState() {
    super.initState();
  }

  Future<Null> _query() async {
    await Provider.of<PasswordList>(context).init();
    _getPasswordWidgetList();
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
          FutureBuilder(
            future: _getPasswordWidgetList(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: _query,
                      child: Scrollbar(
                        child: ListView.builder(
                          itemBuilder: (context, index) => _passWidgetList[index],
                          itemCount: _passWidgetList.length,
                        ),
                      )
                    ),
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
      // 添加 按钮
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditPasswordPage(null, "添加密码")))
              .then((resData) {
            if (resData != null) {
              Provider.of<PasswordList>(context).insertPassword(resData);
            }
          });
        },
        heroTag: "password",
      ),
    );
  }

  Future<Null> _getPasswordWidgetList() async {
      _passWidgetList.clear();
      for (var item in Provider.of<PasswordList>(context).passwordList) {
        try {
          _passWidgetList.add(_getPasswordWidget(item));
        } catch (e) {
          print("有问题出现，key=${item.uniqueKey}");
        }
      }
      if (_passWidgetList.length == 0) {
        _passWidgetList.add(Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text("什么也没有，赶快添加吧"),
            )
          ],
        ));
      }
  }

  Widget _getPasswordWidget(PasswordBean passwordBean) {
    return Container(
      margin: AllpassEdgeInsets.listInset,
      //ListTile可以作为listView的一种子组件类型，支持配置点击事件，一个拥有固定样式的Widget
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: getRandomColor(passwordBean.uniqueKey),
          child: Text(
            passwordBean.name.substring(0, 1),
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(passwordBean.name, overflow: TextOverflow.ellipsis,),
        subtitle: Text(passwordBean.username, overflow: TextOverflow.ellipsis,),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => ViewPasswordPage(passwordBean)
          )).then((bean) {
            if (bean != null) {
              if (bean.isChanged) {
                Provider.of<PasswordList>(context).updatePassword(bean);
              } else {
                Provider.of<PasswordList>(context).deletePassword(passwordBean);
              }
            }
          });
        },
        onLongPress: () async {
          if (Params.longPressCopy) {
            String pw = await EncryptUtil.decrypt(passwordBean.password);
            Clipboard.setData(ClipboardData(text: pw));
            Fluttertoast.showToast(msg: "已复制密码");
          } else {
            Fluttertoast.showToast(msg: "多选");
          }
        },
      ),
    );
  }

  _searchPress () {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SearchPage(AllpassType.PASSWORD)))
        .then((changed) {
          if (changed) {
            setState(() {
              _query();
            });
          }
    });
  }
}
