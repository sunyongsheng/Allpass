import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:allpass/utils/allpass_ui.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "关于",
          style: AllpassTextUI.mainTitleStyle,
        ),
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(20),
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 5),
                ),
                Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: ListTile(
                      title: Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Allpass",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Text("一款简单好用的密码管理软件"),
                    )),
                Container(
                  child: Divider(),
                  padding: EdgeInsets.only(left: 20, right: 20),
                ),
                Container(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 10),
                  child: Text("联系方式", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: FlatButton(
                    child: Text("微博：@Aengus_Sun"),
                    onPressed: () async {
                      await launch("https://weibo.com/u/5484402663");
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: FlatButton(
                    child: Text("邮箱：sys6511@126.com"),
                    onPressed: () async {
                      await launch("mailto:sys6511@126.com");
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: FlatButton(
                    child: Text("开发者网址：https://www.aengus.top"),
                    onPressed: () async {
                      await launch("https://www.aengus.top");
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 5),
                )
              ],
            ),
          ),
          Text("Copyright@2019 Aengus Sun. All Rights Reserved.", style: TextStyle(color: Colors.grey),)
        ],
      )
    );
  }
}
