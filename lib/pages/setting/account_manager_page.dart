import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:allpass/application.dart';
import 'package:allpass/params/config.dart';
import 'package:allpass/provider/card_list.dart';
import 'package:allpass/provider/password_list.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/navigation_util.dart';
import 'package:allpass/widgets/common/confirm_dialog.dart';
import 'package:allpass/widgets/setting/modify_password_dialog.dart';
import 'package:allpass/widgets/setting/input_main_password_dialog.dart';

/// 主账号管理页
class AccountManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccountManagerPage();
  }
}

class _AccountManagerPage extends State<AccountManagerPage> {

  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "主账号管理",
          style: AllpassTextUI.titleBarStyle,
        ),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        elevation: 0,
        brightness: Brightness.light,
      ),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
      body: ListView(
        children: <Widget>[
          Container(
            padding: AllpassEdgeInsets.listInset,
            child: ListTile(
              title: Text("修改主密码"),
              leading: Icon(Icons.lock_open, color: AllpassColorUI.allColor[0]),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => ModifyPasswordDialog());
              },
            ),
          ),
          Container(
            padding: AllpassEdgeInsets.listInset,
            child: ListTile(
              title: Text("清除所有数据"),
              leading: Icon(Icons.clear, color: AllpassColorUI.allColor[1]),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmDialog("确认删除", "此操作将删除所有数据，继续吗？")
                ).then((confirm) {
                  if (confirm) {
                    // 二次确认
                    showDialog(
                      context: context,
                      builder: (context) => InputMainPasswordDialog(),
                    ).then((right) async {
                      if (right) {
                        await Provider.of<PasswordList>(context).clear();
                        await Provider.of<CardList>(context).clear();
                        await Application.sp.clear();
                        Config.configClear();
                        Fluttertoast.showToast(msg: "已删除所有数据");
                        NavigationUtil.goLoginPage(context);
                      }
                    });
                  }
                });
              },
            ),
          ),
          Container(
            padding: AllpassEdgeInsets.listInset,
            child: ListTile(
              title: Text("注销"),
              leading: Icon(Icons.exit_to_app, color: AllpassColorUI.allColor[2]),
              onTap: () => Config.enabledBiometrics
                  ? NavigationUtil.goAuthLoginPage(context)
                  : NavigationUtil.goLoginPage(context),
            ),
          )
        ],
      ),
    );
  }
}
