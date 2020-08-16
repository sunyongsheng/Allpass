import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/application.dart';
import 'package:allpass/params/config.dart';
import 'package:allpass/ui/allpass_ui.dart';
import 'package:allpass/utils/navigation_util.dart';
import 'package:allpass/widgets/common/confirm_dialog.dart';
import 'package:allpass/widgets/setting/modify_password_dialog.dart';
import 'package:allpass/widgets/setting/input_main_password_dialog.dart';
import 'package:allpass/widgets/common/select_item_dialog.dart';

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
        centerTitle: true,
      ),
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
              title: Text("定期输入主密码"),
              leading: Icon(Icons.timer, color: AllpassColorUI.allColor[3]),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      String initial = "${Config.timingInMainPassword}天";
                      if (Config.timingInMainPassword == 36500) {
                        initial = "永不";
                      }
                      return SelectItemDialog(
                        ["7天", "10天", "15天", "30天", "永不"],
                        initialSelected: initial,
                      );
                    }
                ).then((days) {
                  if (days == "永不") {
                    showDialog<bool>(
                        context: context,
                      builder: (context) => ConfirmDialog("确认选择", "选择此项后，Allpass将不再定期要求您输入主密码，请妥善保管好主密码")
                    ).then((yes) {
                      if (yes) {
                        Config.setTimingInMainPassDays(36500);
                      }
                    });
                  } else if (days == "7天") {
                    Config.setTimingInMainPassDays(7);
                  } else if (days == "10天") {
                    Config.setTimingInMainPassDays(10);
                  } else if (days == "15天") {
                    Config.setTimingInMainPassDays(15);
                  } else if (days == "30天") {
                    Config.setTimingInMainPassDays(30);
                  }
                });
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
                        await Application.clearAll(context);
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
