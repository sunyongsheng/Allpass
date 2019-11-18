import 'package:flutter/material.dart';
import 'package:allpass/bean/password_bean.dart';

class ViewAndEditPasswordPage extends StatefulWidget {
  final PasswordBean data;

  ViewAndEditPasswordPage(this.data);

  @override
  _ViewPasswordPage createState() {
    print("打开查看页面");
    return _ViewPasswordPage(data);
  }
}

class _ViewPasswordPage extends State<ViewAndEditPasswordPage> {

  final PasswordBean data;
  bool _passwordVisible = false;



  _ViewPasswordPage(this.data);

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController(
        text: this.data.name
    );
    var usernameController = TextEditingController(
        text: this.data.username
    );
    var passwordController = TextEditingController(
        text: this.data.password
    );
    var notesController = TextEditingController(
        text: this.data.notes
    );

    return Scaffold(
        appBar: AppBar(
          title: Text("查看密码"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                print("点击了保存按钮");
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("名称"),
                      TextField(
                        controller: nameController,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("用户名"),
                      TextField(
                        controller: usernameController,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("密码"),
                          IconButton(
                            icon: _passwordVisible==true?Icon(Icons.visibility):Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                if (_passwordVisible == false) _passwordVisible = true;
                                else _passwordVisible = false;
                              });
                            },
                          )
                        ],
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: !_passwordVisible,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("文件夹"),
                      TextField(),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("标签"),
                      TextField(),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("备注"),
                      TextField(
                        controller: notesController,
                      ),
                    ],
                  ),
                )
              ],
        )));
  }
}
