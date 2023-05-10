import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:allpass/application.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/util/navigation_util.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.mainPasswordManager,
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
              children: [
                ListTile(
                  title: Text(context.l10n.modifyMainPassword),
                  leading: Icon(Icons.lock_open, color: AllpassColorUI.allColor[0]),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ModifyPasswordDialog(),
                    );
                  },
                ),
                ListTile(
                  title: Text(context.l10n.inputMainPasswordTiming),
                  leading: Icon(Icons.timer, color: AllpassColorUI.allColor[1]),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        String initial = context.l10n.nDays(Config.timingInMainPassword);
                        if (Config.timingInMainPassword == 36500) {
                          initial = context.l10n.never;
                        }
                        return DefaultSelectItemDialog<String>(
                          list: [
                            context.l10n.sevenDays,
                            context.l10n.tenDays,
                            context.l10n.fifteenDays,
                            context.l10n.thirtyDays,
                            context.l10n.never
                          ],
                          selector: (data) => data == initial,
                          onSelected: (days) {
                            if (days == context.l10n.never) {
                              showDialog(
                                context: context,
                                builder: (context) => ConfirmDialog(
                                  context.l10n.confirmSelect,
                                  context.l10n.selectNeverWarning,
                                  onConfirm: () {
                                    Config.setTimingInMainPassDays(36500);
                                  },
                                ),
                              );
                            } else if (days == context.l10n.sevenDays) {
                              Config.setTimingInMainPassDays(7);
                            } else if (days == context.l10n.tenDays) {
                              Config.setTimingInMainPassDays(10);
                            } else if (days == context.l10n.fifteenDays) {
                              Config.setTimingInMainPassDays(15);
                            } else if (days == context.l10n.thirtyDays) {
                              Config.setTimingInMainPassDays(30);
                            }
                          },
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  title: Text(context.l10n.secretKeyUpdate),
                  leading: Icon(Icons.security, color: AllpassColorUI.allColor[4]),
                  onTap: () {
                    Navigator.push(context, CupertinoPageRoute(
                        builder: (context) => SecretKeyUpgradePage()
                    ));
                  },
                ),
                ListTile(
                  title: Text(context.l10n.clearAllData),
                  leading: Icon(Icons.clear, color: Colors.red),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        context.l10n.confirmClearAll,
                        context.l10n.clearAllWaring,
                        danger: true,
                        onConfirm: () {
                          // 二次确认
                          showDialog(
                            context: context,
                            builder: (context) => InputMainPasswordDialog(
                              onVerified: () async {
                                await AllpassApplication.clearAll(context);
                                ToastUtil.show(msg: context.l10n.clearAllSuccess);
                                NavigationUtil.goLoginPage(context);
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text(context.l10n.logout),
                  leading: Icon(Icons.exit_to_app, color: AllpassColorUI.allColor[2]),
                  onTap: () => Config.enabledBiometrics
                      ? NavigationUtil.goAuthLoginPage(context)
                      : NavigationUtil.goLoginPage(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
