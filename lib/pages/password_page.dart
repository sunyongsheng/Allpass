import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/bean/password_bean.dart';
import 'package:allpass/pages/view_and_edit_password_page.dart';
import 'package:allpass/utils/allpass_ui.dart';

import 'package:allpass/utils/test_data.dart';
import 'package:allpass/params/password_data.dart';

/// 密码页面
class PasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PasswordTestData(); // 初始化测试数据
    return _PasswordPage();
  }
}

class _PasswordPage extends StatefulWidget {
  @override
  _PasswordPageState createState() {
    PasswordTestData(); // 初始化测试数据
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
                print("点击了搜索按钮");
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
            child: ListView(children: getPasswordWidgetList()),
          ),
        ],
      ),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
      // 添加 按钮
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          print("点击了密码页面的增加按钮");
        },
      ),
    );
  }

  List<Widget> getPasswordWidgetList() =>
      PasswordData.passwordData.map((item) => getPasswordWidget(item)).toList();

  Widget getPasswordWidget(PasswordBase passwordBean) {
    // TODO 滑动弹出删除按钮
    return Dismissible(
      key: Key(passwordBean.key.toString()),
      onDismissed: (dismissibleDirection) {
        setState(() {
          PasswordData.passwordData.remove(passwordBean);
          Fluttertoast.showToast(msg: "删除了"+passwordBean.name);
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
            print("点击了账号：" + passwordBean.name);
            _currentKey = passwordBean.key;
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

  // 点击账号弹出模态菜单
  Widget _createBottomSheet(BuildContext context, PasswordBase data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.remove_red_eye),
          title: Text("查看"),
          onTap: () {
            print("点击了账号：" + data.name + "的查看按钮");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ViewAndEditPasswordPage(data)))
                .then((reData){
              this.setState(() {
                int index = 0;
                for (int i = 0; i < PasswordData.passwordData.length; i++) {
                  if (_currentKey == PasswordData.passwordData[i].key) {
                    index = i;
                    break;
                  }
                }
                PasswordData.passwordData[index] = reData;
                // TODO 下面的函数会报 PasswordBean isn't the subtype of PassWordTempBean
                // copyPasswordBean(PasswordTestData.passwordList[index], reData);

                // PasswordTestData.passwordList[index].name = reData.name;
                // PasswordTestData.passwordList[index].username = reData.username;
                // PasswordTestData.passwordList[index].password = reData.password;
                // PasswordTestData.passwordList[index].url = reData.url;
                // PasswordTestData.passwordList[index].folder = reData.folder;
                // PasswordTestData.passwordList[index].label = reData.label;
                // PasswordTestData.passwordList[index].notes = reData.notes;
                // PasswordTestData.passwordList[index].fav = reData.fav;
              });
            });
          },
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text("编辑"),
          onTap: () {
            print("点击了账号：" + data.name + "的编辑按钮");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ViewAndEditPasswordPage(data)))
            .then((newData) {
              this.setState(() {
                int index = 0;
                for (int i = 0; i < PasswordTestData.passwordList.length; i++) {
                  if (_currentKey == PasswordTestData.passwordList[i].key) {
                    index = i;
                    break;
                  }
                }
                PasswordTestData.passwordList[index] = newData;
              });
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
        )
      ],
    );
  }

  viewDetails(PasswordBean data) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ViewAndEditPasswordPage(data)))
        .then((newData){
      this.setState(() {
        data = newData;
        print(PasswordTestData.passwordList[0].name);
      });
    });
  }
}