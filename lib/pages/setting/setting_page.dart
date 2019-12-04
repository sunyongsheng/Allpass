import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';

import 'package:allpass/application.dart';
import 'package:allpass/params/params.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/pages/setting/account_manager_page.dart';
import 'package:allpass/pages/setting/category_manager_page.dart';
import 'package:allpass/pages/setting/import_export_page.dart';
import 'package:allpass/pages/about_page.dart';

/// 设置页面
class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _SettingPage();
}

class _SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<_SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "设置",
          style: AllpassTextUI.mainTitleStyle,
        ),
        centerTitle: true,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        elevation: 0,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  child: ListTile(
                    title: Text("主账号管理"),
                    leading: Icon(Icons.account_circle),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountManagerPage()));
                    },
                  ),
                  padding: EdgeInsets.only(left: 15, right: 15),
                ),
                Container(
                  child: ListTile(
                    title: Text("生物识别"),
                    leading: Icon(Icons.fingerprint),
                    trailing: Switch(
                      value: Params.enabledBiometrics,
                      onChanged: (sw) async {
                        if (await LocalAuthentication().canCheckBiometrics) {
                          Application.sp.setBool("biometrics", sw);
                          Params.enabledBiometrics = sw;
                        } else {
                          Application.sp.setBool("biometrics", false);
                          Params.enabledBiometrics = false;
                          Fluttertoast.showToast(msg: "您的设备似乎不支持生物识别");
                        }
                      },
                    ),
                  ),
                  padding: EdgeInsets.only(left: 15, right: 15),
                ),
                Container(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                Container(
                  child: ListTile(
                    title: Text("标签管理"),
                    leading: Icon(Icons.label_outline),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryManagerPage("标签")));
                    },
                  ),
                  padding: EdgeInsets.only(left: 15, right: 15),
                ),
                Container(
                  child: ListTile(
                    title: Text("文件夹管理"),
                    leading: Icon(Icons.folder_open),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CategoryManagerPage("文件夹")));
                    },
                  ),
                  padding: EdgeInsets.only(left: 15, right: 15),
                ),
                Container(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                Container(
                  child: ListTile(
                    title: Text("导入/导出"),
                    leading: Icon(Icons.import_export),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImportExportPage(),
                          ));
                    },
                  ),
                  padding: EdgeInsets.only(left: 15, right: 15),
                ),
                Container(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                Container(
                  child: ListTile(
                    title: Text("关于"),
                    leading: Icon(Icons.details),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AboutPage(),
                          ));
                    },
                  ),
                  padding: EdgeInsets.only(left: 15, right: 15),
                ),
              ],
            ),
          )
        ],
      ),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
    );
  }
}
