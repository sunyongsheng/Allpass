import 'package:flutter/material.dart';

import 'package:allpass/bean/password_bean.dart';
import 'package:allpass/pages/view_and_edit_password_page.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/test_data.dart';

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
      PasswordTestData.passwordList.map((item) => getPasswordWidget(item)).toList();

  Widget getPasswordWidget(PasswordBean passwordBean) {
    return Container(
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

  // 点击账号弹出模态菜单
  Widget _createBottomSheet(BuildContext context, PasswordBean data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.remove_red_eye),
          title: Text("查看"),
          onTap: () {
            print("点击了账号：" + data.name + "的查看按钮");
            viewDetails(data);
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
                data = newData;
              });
            });
          },
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text("复制用户名"),
          onTap: () {
            print("复制用户名：" + data.username);
          },
        ),
        ListTile(
          leading: Icon(Icons.content_copy),
          title: Text("复制密码"),
          onTap: () {
            print("复制密码：" + data.password);
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
        print(data.name);
      });
    });
  }
}


// class PasswordWidget extends StatefulWidget {
//   PasswordBean passwordBean;
//   PasswordWidget(this.passwordBean);
//
//   @override
//   State<StatefulWidget> createState() => _PasswordWidget(passwordBean);
// }

/* class _PasswordWidget extends State<PasswordWidget> {
  PasswordBean passwordBean;

  _PasswordWidget(this.passwordBean);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 70,
      //ListTile可以作为listView的一种子组件类型，支持配置点击事件，一个拥有固定样式的Widget
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
          passwordBean.hashCode % 2 == 1 ? Colors.blue : Colors.amberAccent,
          child: Text(
            passwordBean.name.substring(0, 1),
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ViewAndEditPasswordPage(passwordBean)))
                .then((newBean){
              passwordBean = newBean;
            });
          },
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text("编辑"),
          onTap: () {
            print("点击了账号：" + passwordBean.name + "的编辑按钮");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ViewAndEditPasswordPage(passwordBean)));
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
*/