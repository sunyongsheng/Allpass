import 'package:flutter/material.dart';
import 'package:allpass/common/ui/allpass_ui.dart';


class InitialErrorApp extends StatelessWidget {

  final String? errorMsg;

  const InitialErrorApp({Key? key, this.errorMsg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Allpass",
      home: CustomErrorPage(msg: errorMsg),
    );
  }
}

class CustomErrorPage extends StatelessWidget {

  final String? msg;

  const CustomErrorPage({Key? key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "出错了",
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              child: Text("App出现错误，快去反馈给作者!"),
              padding: EdgeInsets.symmetric(vertical: 15),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
            ),
            Padding(
              child: Text("以下是出错信息，请截图发到邮箱sys6511@126.com"),
              padding: EdgeInsets.symmetric(vertical: 15),
            ),
            Padding(
              child: Text(msg ?? "null", style: TextStyle(color: Colors.red),),
              padding: EdgeInsets.symmetric(vertical: 15),
            ),
          ],
        ),
      ),
    );
  }
}