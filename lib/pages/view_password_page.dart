import 'package:flutter/material.dart';
import 'package:allpass/bean/password_bean.dart';

class ViewPasswordPage extends StatefulWidget {
  final PasswordBean data;

  ViewPasswordPage(this.data);

  @override
  _ViewPasswordPage createState() {
    print("打开查看页面");
    return _ViewPasswordPage(data);
  }

}

class _ViewPasswordPage extends State<ViewPasswordPage> {

  final PasswordBean data;

  _ViewPasswordPage(this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("查看密码"),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Text("名称",
                      style: TextStyle(fontSize: 16)
                  ),
                ],
              ),
            ),
            Expanded(child: Row(
              children: <Widget>[
                Text(data.name,
                    style: TextStyle(fontSize: 16)
                ),
              ],
            ),)
          ],
        ),
      )
    );
  }
}
