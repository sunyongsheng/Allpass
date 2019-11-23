import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/bean/password_bean.dart';
import 'package:allpass/pages/view_and_edit_password_page.dart';
import 'package:allpass/pages/search_page.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/params/allpass_type.dart';
import 'package:allpass/params/password_data.dart';

/// 密码页面
class PasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PasswordPage();
  }
}

class _PasswordPage extends StatefulWidget {
  @override
  _PasswordPageState createState() {
    return _PasswordPageState();
  }
}

class _PasswordPageState extends State<_PasswordPage> {

  TextEditingController searchController = TextEditingController();
  int _currentKey = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "密码",
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(AllpassType.PASSWORD)));
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
          // 密码列表
          Expanded(
            child: ListView(children: _getPasswordWidgetList()),
          ),
        ],
      ),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
      // 添加 按钮
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          var newData = PasswordBean("", "", "", folder: "默认", isNew: false);
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => ViewAndEditPasswordPage(newData, "添加密码")))
          .then((resData) {
            assert(resData is PasswordBean);
            this.setState(() {
              if (resData.username != "" && resData.password != "" && resData.url != "") {
                PasswordData.passwordData.add(resData);
                PasswordData.passwordKeySet.add(resData.uniqueKey);
              }
            });
          });
        },
      ),
    );
  }

  List<Widget> _getPasswordWidgetList() =>
      PasswordData.passwordData.map((item) => _getPasswordWidget(item)).toList();

  Widget _getPasswordWidget(PasswordBean passwordBean) {
    // TODO 滑动弹出删除按钮
    return Dismissible(
      key: Key(passwordBean.uniqueKey.toString()),
      onDismissed: (dismissibleDirection) {
        setState(() {
          Fluttertoast.showToast(msg: "删除了“"+passwordBean.name+"”");
          PasswordData.passwordData.remove(passwordBean);
          // TODO 是否remove对应的key
        });
      },
      child: Container(
        width: 140,
        height: 70,
        //ListTile可以作为listView的一种子组件类型，支持配置点击事件，一个拥有固定样式的Widget
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: passwordBean.hashCode % 2 == 1 ? Colors.blue : Colors.amberAccent,
            child: Text(
              passwordBean.name.substring(0, 1),
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: Text(passwordBean.name),
          subtitle: Text(passwordBean.username),
          onTap: () {
            _currentKey = passwordBean.uniqueKey;
            // 显示模态BottomSheet
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return _createBottomSheet(context, passwordBean);
                });
          },
        ),
      ),
    );
  }

  // 点击密码弹出模态菜单
  Widget _createBottomSheet(BuildContext context, PasswordBean data) {
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
                        ViewAndEditPasswordPage(data, "查看密码")))
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
                        ViewAndEditPasswordPage(data, "编辑密码")))
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
}