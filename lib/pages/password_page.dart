import 'package:flutter/material.dart';

import 'package:allpass/bean/password_bean.dart';
import 'package:allpass/pages/view_and_edit_password_page.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/test_data.dart';

/// 密码页面
class PasswordPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    PasswordTestData();   // 初始化测试数据
    return _PasswordPage();
  }
}

class _PasswordPage extends StatefulWidget {

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<_PasswordPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("密码", style: AllpassTextUI.mainTitleStyle,),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: "搜索",
            onPressed: () {
              print("点击了密码页的搜索");
            },
          )
        ],
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        toolbarOpacity: 1,
      ),
      body: ListView(
          children: getPasswordWidgetList()
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
}

List<Widget> getPasswordWidgetList() {

  return PasswordTestData.passwordList.map((item) => PasswordWidget(item)).toList();
}

class PasswordWidget extends StatelessWidget {

  final PasswordBean passwordBean;

  PasswordWidget(this.passwordBean);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 70,
      //ListTile可以作为listView的一种子组件类型，支持配置点击事件，一个拥有固定样式的Widget
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: passwordBean.hashCode%2==1?Colors.blue:Colors.amberAccent,
          child: Text(
            passwordBean.name.substring(0,1),
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(passwordBean.name),
        subtitle: Text(passwordBean.username),
        onTap: () {
          print("点击了账号：" + passwordBean.name);
          // 显示模态BottomSheet
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return _createBottomSheet(context);
              });
        },
      ),
    );
  }

  // 点击账号弹出模态菜单
  Widget _createBottomSheet(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.remove_red_eye),
          title: Text("查看"),
          onTap: () {
            print("点击了账号：" + passwordBean.name + "的查看按钮");
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => ViewAndEditPasswordPage(passwordBean)
                )
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text("编辑"),
          onTap: () {
            print("点击了账号：" + passwordBean.name + "的编辑按钮");
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => ViewAndEditPasswordPage(passwordBean)
                )
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text("复制用户名"),
          onTap: () {
            print("复制用户名：" + passwordBean.username);
          },
        ),
        ListTile(
          leading: Icon(Icons.content_copy),
          title: Text("复制密码"),
          onTap: () {
            print("复制密码：" + passwordBean.password);
          },
        )
      ],
    );
  }
}
