import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:allpass/model/password_bean.dart';
import 'package:allpass/pages/password/view_and_edit_password_page.dart';
import 'package:allpass/pages/search/search_page.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/params/allpass_type.dart';
import 'package:allpass/dao/password_dao.dart';

/// 密码页面
class PasswordPage extends StatefulWidget {
  @override
  _PasswordPageState createState() {
    return _PasswordPageState();
  }
}

class _PasswordPageState extends State<PasswordPage> {
  PasswordDao passwordDao = new PasswordDao();

  int _currentKey = -1;

  List<PasswordBean> _passList = List(); // 所有的PasswordBean
  List<Widget> _passWidgetList = List(); // 列表

  @override
  void initState() {
    super.initState();
    _getDataFromDB();
  }

  Future<Null> _getDataFromDB() async {
    List<PasswordBean> data = await passwordDao.getAllPasswordBeanList();
    if (data != null) {
      if (data.length > 0) {
        data.forEach((bean) {
          _passList.add(bean);
        });
      }
    }
    setState(() {});
  }

  // 查询
  Future<Null> _query() async {
    _passList.clear();
    List<PasswordBean> data = await passwordDao.getAllPasswordBeanList();
    if (data != null) {
      if (data.length > 0) {
        data.forEach((bean) {
          _passList.add(bean);
        });
      }
    }
    setState(() {});
  }

  // 添加
  Future<Null> _add(PasswordBean newBean) async {
    await passwordDao.insert(newBean);
    _query();
  }

  // 删除
  Future<Null> _delete(int key) async {
    await passwordDao.deletePasswordBeanById(key);
    _query();
  }

  // 更新
  Future<Null> _update(PasswordBean newBean) async {
    await passwordDao.updatePasswordBean(newBean);
    _query();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "密码",
          style: AllpassTextUI.mainTitleStyle,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
      ),
      body: Column(
        children: <Widget>[
          // 搜索框 按钮
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
            child: FlatButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SearchPage(AllpassType.PASSWORD)))
                    .then((value) => setState(() {
                          _query();
                        }));
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
          FutureBuilder(
            future: _getPasswordWidgetList(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return Center(
                    child: Text("加载中..."),
                  );
                case ConnectionState.done:
                  return Expanded(
                    child: ListView(children: _passWidgetList),
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
            var newData =
                PasswordBean(username: "", password: "", url: "", folder: "默认");
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ViewAndEditPasswordPage(newData, "添加密码", false)))
                .then((resData) {
              if (resData != null) {
                _add(resData);
              }
            });
          }),
    );
  }

  Future<Null> _getPasswordWidgetList() async {
    setState(() {
      _passWidgetList.clear();
      for (var item in _passList) {
        _passWidgetList.add(_getPasswordWidget(item));
      }
    });
  }

  Widget _getPasswordWidget(PasswordBean passwordBean) {
    return Container(
      margin: EdgeInsets.only(right: 10, left: 10),
      //ListTile可以作为listView的一种子组件类型，支持配置点击事件，一个拥有固定样式的Widget
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: getRandomColor(passwordBean.uniqueKey),
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
                            ViewAndEditPasswordPage(data, "查看密码", true)))
                .then((reData) {
              if (reData != null) _update(reData);
            });
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
                .then((reData) {
              if (reData != null) _update(reData);
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
        ),
        ListTile(
          leading: Icon(Icons.delete_outline),
          title: Text("删除密码"),
          onTap: () {
            _delete(_currentKey);
          },
        )
      ],
    );
  }
}
