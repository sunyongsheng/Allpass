import 'package:flutter/material.dart';

import 'package:allpass/bean/password_bean.dart';

class PasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("密码"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: "搜索",
            onPressed: () {
              print("点击了密码页的搜索");
            },
          )
        ],
      ),
      body: ListView(
          children: getPasswordWidgetList()
      ),
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
  List<PasswordBean> passwordList = List();

  passwordList.add(PasswordBean("sys6511@126.com", "1234","https://www.weibo.com"));
  passwordList.add(PasswordBean("sys6511@126.com", "12345", "https://www.zhihu.com"));
  passwordList.add(PasswordBean("sys6511@126.com", "31238912","https://www.126.com"));
  passwordList.add(PasswordBean("sunyongsheng6511@gmail.com", "joi123123", "https://www.gmail.com"));

  return passwordList.map((item) => PasswordWidget(item)).toList();
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
                return _createBottomSheet(context, passwordBean);
              });
        },
      ),
    );
  }
}

Widget _createBottomSheet(BuildContext context, PasswordBean accountBean) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      ListTile(
        leading: Icon(Icons.remove_red_eye),
        title: Text("查看"),
        onTap: () {
          print("点击了账号：" + accountBean.name + "的查看按钮");
        },
      ),
      ListTile(
        leading: Icon(Icons.edit),
        title: Text("编辑"),
        onTap: () {
          print("点击了账号：" + accountBean.name + "的编辑按钮");
        },
      ),
      ListTile(
        leading: Icon(Icons.person),
        title: Text("复制用户名"),
        onTap: () {
          print("复制用户名：" + accountBean.username);
        },
      ),
      ListTile(
        leading: Icon(Icons.content_copy),
        title: Text("复制密码"),
        onTap: () {
          print("复制密码：" + accountBean.password);
        },
      )
    ],
  );
}
