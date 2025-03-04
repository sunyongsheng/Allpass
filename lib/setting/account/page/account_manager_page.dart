import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/setting/account/input_main_password_timing.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:allpass/application.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/navigation/navigator.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/common/widget/confirm_dialog.dart';
import 'package:allpass/setting/account/widget/modify_password_dialog.dart';
import 'package:allpass/setting/account/widget/input_main_password_dialog.dart';
import 'package:allpass/common/widget/select_item_dialog.dart';
import 'package:allpass/setting/account/page/secret_key_upgrade_page.dart';
import 'package:provider/provider.dart';

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
    var l10n = context.l10n;
    var children = <Widget>[
      ListTile(
        title: Text(l10n.modifyMainPassword),
        leading: Icon(Icons.password, color: AllpassColorUI.allColor[0]),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => ModifyPasswordDialog(),
          );
        },
      ),
    ];
    if (Config.enabledBiometrics) {
      children.add(ListTile(
        title: Text(l10n.inputMainPasswordTiming),
        trailing: Text(
          Config.timingInMainPassword.l10n(context),
          style: AllpassTextUI.settingTrailing,
        ),
        leading: Icon(Icons.timer, color: AllpassColorUI.allColor[1]),
        onTap: () {
          _onTapInputMasterPasswordTiming(context);
        },
      ));
    }
    children.addAll([
      ListTile(
        title: Text(l10n.secretKeyUpdate),
        leading: Icon(Icons.security, color: AllpassColorUI.allColor[4]),
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => SecretKeyUpgradePage()),
          );
        },
      ),
      ListTile(
        title: Text(l10n.clearAllData),
        leading: Icon(Icons.clear_all, color: Colors.red),
        onTap: () {
          _onTapClearAllData(context);
        },
      ),
      ListTile(
        title: Text(l10n.lockAllpass),
        leading: Icon(Icons.lock, color: AllpassColorUI.allColor[7]),
        onTap: () {
          Config.setHasLockManually(true);
          AllpassNavigator.goLoginPage(context);
        },
      ),
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.mainPasswordManager,
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
      ),
      backgroundColor: context.watch<ThemeProvider>().specialBackgroundColor,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: AllpassEdgeInsets.smallTopInsets,
          ),
          Card(
            margin: AllpassEdgeInsets.settingCardInset,
            elevation: 0,
            child: Column(
              children: children,
            ),
          )
        ],
      ),
    );
  }

  void _onTapInputMasterPasswordTiming(BuildContext context) {
    var l10n = context.l10n;
    showDialog(
      context: context,
      builder: (context) {
        return DefaultSelectItemDialog(
          list: InputMainPasswordTiming.values,
          selector: (data) => data == Config.timingInMainPassword,
          itemTitleBuilder: (ctx, item) => item.l10n(ctx),
          onSelected: (timing) {
            if (timing == InputMainPasswordTiming.never) {
              showDialog(
                context: context,
                builder: (context) => ConfirmDialog(
                  l10n.confirmSelect,
                  l10n.selectNeverWarning,
                  onConfirm: () {
                    setState(() {
                      Config.setTimingInMainPassDays(timing);
                    });
                  },
                ),
              );
            } else {
              setState(() {
                Config.setTimingInMainPassDays(timing);
              });
            }
          },
        );
      },
    );
  }

  void _onTapClearAllData(BuildContext context) {
    var l10n = context.l10n;
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        l10n.confirmClearAll,
        l10n.clearAllWaring,
        danger: true,
        onConfirm: () {
          // 二次确认
          showDialog(
            context: context,
            builder: (context) => InputMainPasswordDialog(
              onVerified: () async {
                await AllpassApplication.clearAll(context);
                ToastUtil.show(msg: l10n.clearAllSuccess);
                AllpassNavigator.goLoginPage(context);
              },
            ),
          );
        },
      ),
    );
  }
}
