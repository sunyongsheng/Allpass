import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';

import 'package:allpass/application.dart';
import 'package:allpass/params/params.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/pages/about_page.dart';
import 'package:allpass/pages/setting/account_manager_page.dart';
import 'package:allpass/pages/setting/category_manager_page.dart';
import 'package:allpass/pages/setting/import/import_export_page.dart';
import 'package:allpass/widgets/setting/input_main_password_dialog.dart';
import 'package:allpass/widgets/setting/check_update_dialog.dart';
import 'package:allpass/services/authentication_service.dart';


/// 设置页面
class SettingPage extends StatefulWidget {
  @override
  _SettingPage createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> with AutomaticKeepAliveClientMixin {

  AuthenticationService _localAuthService;

  ScrollController _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _localAuthService = Application.getIt<AuthenticationService>();
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          splashColor: Colors.transparent,
          child: Text(
            "设置",
            style: AllpassTextUI.titleBarStyle,
          ),
          onTap: () {
            _controller.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
          },
        ),
        centerTitle: true,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        elevation: 0,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              controller: _controller,
              children: <Widget>[
                Container(
                  child: ListTile(
                    title: Text("主账号管理"),
                    leading: Icon(Icons.account_circle, color: AllpassColorUI.allColor[0],),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountManagerPage()));
                    },
                  ),
                  padding: AllpassEdgeInsets.listInset,
                ),
                Container(
                  child: ListTile(
                    title: Text("生物识别"),
                    leading: Icon(Icons.fingerprint, color: AllpassColorUI.allColor[1]),
                    trailing: Switch(
                      value: Params.enabledBiometrics,
                      onChanged: (sw) async {
                        if (await LocalAuthentication().canCheckBiometrics) {
                          showDialog(context: context,
                            builder: (context) => InputMainPasswordDialog(),
                          ).then((right) async {
                            if (right) {
                              var auth = await _localAuthService.authenticate();
                              if (auth) {
                                await _localAuthService.stopAuthenticate();
                                Application.sp.setBool("biometrics", sw);
                                Params.enabledBiometrics = sw;
                                setState(() {});
                              } else {
                                Fluttertoast.showToast(msg: "授权失败");
                              }
                            } else {
                              Fluttertoast.showToast(msg: "密码错误");
                            }
                          });
                        } else {
                          Application.sp.setBool("biometrics", false);
                          Params.enabledBiometrics = false;
                          Fluttertoast.showToast(msg: "您的设备似乎不支持生物识别");
                        }
                      },
                    ),
                  ),
                  padding: AllpassEdgeInsets.listInset
                ),
                Container(
                    child: ListTile(
                      title: Text("长按复制密码或卡号"),
                      leading: Icon(Icons.present_to_all, color: AllpassColorUI.allColor[2]),
                      // subtitle: Params.longPressCopy
                      //     ?Text("当前长按为复制密码或卡号")
                      //     :Text("当前长按为多选"),
                      trailing: Switch(
                        value: Params.longPressCopy,
                        onChanged: (sw) async {
                          Application.sp.setBool("longPressCopy", sw);
                          setState(() {
                            Params.longPressCopy = sw;
                          });
                        },
                      ),
                    ),
                    padding: AllpassEdgeInsets.listInset
                ),
                Container(
                  padding: AllpassEdgeInsets.dividerInset,
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                Container(
                  child: ListTile(
                    title: Text("标签管理"),
                    leading: Icon(Icons.label_outline, color: AllpassColorUI.allColor[3]),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryManagerPage("标签")));
                    },
                  ),
                  padding: AllpassEdgeInsets.listInset
                ),
                Container(
                  child: ListTile(
                    title: Text("文件夹管理"),
                    leading: Icon(Icons.folder_open, color: AllpassColorUI.allColor[4]),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CategoryManagerPage("文件夹")));
                    },
                  ),
                  padding: AllpassEdgeInsets.listInset
                ),
                Container(
                  padding: AllpassEdgeInsets.dividerInset,
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                Container(
                  child: ListTile(
                    title: Text("导入/导出"),
                    leading: Icon(Icons.import_export, color: AllpassColorUI.allColor[5]),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImportExportPage(),
                          ));
                    },
                  ),
                  padding: AllpassEdgeInsets.listInset
                ),
                Container(
                  padding: AllpassEdgeInsets.dividerInset,
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                Container(
                    child: ListTile(
                      title: Text("检查更新"),
                      leading: Icon(Icons.update, color: AllpassColorUI.allColor[6]),
                      onTap: () {
                        showDialog(
                          context: context,
                          child: CheckUpdateDialog()
                        );
                      }
                    ),
                    padding: AllpassEdgeInsets.listInset
                ),
                Container(
                  child: ListTile(
                    title: Text("关于"),
                    leading: Icon(Icons.details, color: AllpassColorUI.allColor[0]),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AboutPage(),
                          ));
                    },
                  ),
                  padding: AllpassEdgeInsets.listInset
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
