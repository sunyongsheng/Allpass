import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/screen_util.dart';

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
            margin: EdgeInsets.all(AllpassScreenUtil.setWidth(50)),
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(padding: AllpassEdgeInsets.smallPadding,),
                Container(
                    padding: AllpassEdgeInsets.listInset,
                    child: ListTile(
                      title: Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Allpass",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Text("一款简单好用的密码管理软件"),
                      trailing: Text("beta_v0.0.1", style: TextStyle(color: Colors.grey),),
                      isThreeLine: true,
                    )),
                Container(
                  child: Divider(),
                  padding: AllpassEdgeInsets.dividerInset,
                ),
                Container(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 10),
                  child: Text("联系方式", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Container(
                  padding: AllpassEdgeInsets.dividerInset,
                  child: FlatButton(
                    child: Text("微博：@Aengus_Sun"),
                    onPressed: () async {
                      await launch("https://weibo.com/u/5484402663");
                    },
                  ),
                ),
                Container(
                  padding: AllpassEdgeInsets.dividerInset,
                  child: FlatButton(
                    child: Text("邮箱：sys6511@126.com"),
                    onPressed: () async {
                      await launch("mailto:sys6511@126.com");
                    },
                  ),
                ),
                Container(
                  padding: AllpassEdgeInsets.dividerInset,
                  child: FlatButton(
                    child: Text("开发者网站：https://www.aengus.top"),
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
