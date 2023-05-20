import 'package:allpass/core/di/di.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/setting/autofill/autofill_page.dart';
import 'package:allpass/setting/autofill/autofill_provider.dart';
import 'package:allpass/webdav/ui/webdav_sync_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:provider/provider.dart';

import 'package:allpass/application.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/core/enums/category_type.dart';
import 'package:allpass/core/model/api/update_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:allpass/core/service/auth_service.dart';
import 'package:allpass/core/service/allpass_service.dart';
import 'package:allpass/home/about_page.dart';
import 'package:allpass/setting/feedback_page.dart';
import 'package:allpass/setting/theme/theme_select_page.dart';
import 'package:allpass/setting/account/page/account_manager_page.dart';
import 'package:allpass/setting/category/category_manager_page.dart';
import 'package:allpass/setting/import/import_export_page.dart';
import 'package:allpass/webdav/ui/webdav_config_page.dart';
import 'package:allpass/webdav/ui/webdav_sync_page.dart';
import 'package:allpass/setting/account/widget/input_main_password_dialog.dart';
import 'package:allpass/setting/update/update_dialog.dart';


/// 设置页面
class SettingPage extends StatefulWidget {
  @override
  _SettingPage createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> with AutomaticKeepAliveClientMixin {

  late AuthService _localAuthService;

  late ScrollController _controller;

  final double cardElevation = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _localAuthService = inject<AuthService>();
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
    var l10n = context.l10n;

    var firstCardWidgets = [
      ListTile(
        title: Text(l10n.mainPasswordManager),
        leading: Icon(Icons.account_circle_outlined, color: AllpassColorUI.allColor[0],),
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(
              builder: (context) => AccountManagerPage()
          ));
        },
      ),
      ListTile(
        title: Text(l10n.biometricAuthentication),
        leading: Icon(Icons.fingerprint, color: AllpassColorUI.allColor[1]),
        trailing: Switch(
          value: Config.enabledBiometrics,
          onChanged: (sw) async {
            if (await _localAuthService.supportBiometric()) {
              showDialog(context: context,
                builder: (context) => InputMainPasswordDialog(
                  onVerified: () async {
                    var authResult = await _localAuthService.authenticate(context);
                    switch (authResult) {
                      case AuthResult.Success:
                        await _localAuthService.stopAuthenticate();
                        setState(() {
                          Config.setEnabledBiometrics(sw);
                        });
                        ToastUtil.show(msg: l10n.enableBiometricSuccess);
                        break;
                      case AuthResult.NotAvailable:
                        ToastUtil.show(msg: l10n.biometricNotAvailable);
                        break;
                      default:
                        ToastUtil.show(msg: l10n.authorizationFailed);
                    }
                  },
                ),
              );
            } else {
              Config.setEnabledBiometrics(false);
              ToastUtil.show(msg: l10n.biometricNotSupport);
            }
          },
        ),
      ),
      ListTile(
        title: Text(l10n.longPressToCopy),
        leading: Icon(Icons.content_copy, color: AllpassColorUI.allColor[2]),
        trailing: Switch(
          value: Config.longPressCopy,
          onChanged: (sw) async {
            setState(() {
              Config.setLongPressCopy(sw);
            });
          },
        ),
      ),
      ListTile(
        title: Text(l10n.appTheme),
        leading: Icon(Icons.color_lens_outlined, color: AllpassColorUI.allColor[5]),
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(
            builder: (context) => ThemeSelectPage(),
          ));
        },
      ),
    ];

    var secondCardWidgets = [
      ListTile(
        title: Text(l10n.labelManager),
        leading: Icon(Icons.label_outline, color: AllpassColorUI.allColor[3]),
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(
              builder: (context) => CategoryManagerPage(CategoryType.label)
          ));
        },
      ),
      ListTile(
        title: Text(l10n.folderManager),
        leading: Icon(Icons.folder_open, color: AllpassColorUI.allColor[4]),
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(
              builder: (context) => CategoryManagerPage(CategoryType.folder)
          ));
        },
      ),
    ];

    var thirdCardWidgets = [
      ListTile(
        title: Text(l10n.webDavSync),
        leading: Icon(Icons.cloud_outlined, color: AllpassColorUI.allColor[0]),
        onTap: () {
          if (Config.webDavAuthSuccess) {
            Navigator.push(context, CupertinoPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (context) => WebDavSyncProvider(),
                child: WebDavSyncPage(),
              ),
            ));
          } else {
            Navigator.push(context, CupertinoPageRoute(
              builder: (context) => WebDavConfigPage(),
            ));
          }
        },
      ),
      ListTile(
        title: Text(l10n.importExport),
        leading: Icon(Icons.import_export, color: AllpassColorUI.allColor[5]),
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(
            builder: (context) => ImportExportPage(),
          ));
        },
      )
    ];
    if (AllpassApplication.isAndroid && AllpassApplication.systemSdkInt >= 26) {
      thirdCardWidgets.add(ListTile(
        title: Text(l10n.autofill),
        leading: Icon(Icons.edit_road, color: AllpassColorUI.allColor[6]),
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (_) => AutofillProvider(),
              child: AutofillPage(),
            ),
          ));
        },
      ));
    }

    var forthCardWidgets = [
      ListTile(
          title: Text(l10n.shareToFriends),
          leading: Icon(Icons.share, color: AllpassColorUI.allColor[2]),
          onTap: () async => await doRecommend()
      ),
      ListTile(
          title: Text(l10n.feedback),
          leading: Icon(Icons.feedback_outlined, color: AllpassColorUI.allColor[1]),
          onTap: () => Navigator.push(context, CupertinoPageRoute(
            builder: (context) => FeedbackPage(),
          ))
      ),
      ListTile(
          title: Text(l10n.checkUpdate),
          leading: Icon(Icons.update, color: AllpassColorUI.allColor[6]),
          onTap: () => checkUpdate()
      ),
      ListTile(
        title: Text(l10n.about),
        leading: Icon(Icons.details, color: AllpassColorUI.allColor[0]),
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(
            builder: (context) => AboutPage(),
          ));
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          splashColor: Colors.transparent,
          child: Text(
            l10n.settings,
            style: AllpassTextUI.titleBarStyle,
          ),
          onTap: () {
            _controller.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
          },
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: context.watch<ThemeProvider>().specialBackgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              controller: _controller,
              children: <Widget>[
                Padding(
                  padding: AllpassEdgeInsets.smallTopInsets,
                ),
                Card(
                  margin: AllpassEdgeInsets.settingCardInset,
                  elevation: cardElevation,
                  child: Column(
                    children: firstCardWidgets,
                  ),
                ),
                Card(
                  margin: AllpassEdgeInsets.settingCardInset,
                  elevation: cardElevation,
                  child: Column(
                    children: secondCardWidgets,
                  ),
                ),
                Card(
                  margin: AllpassEdgeInsets.settingCardInset,
                  elevation: cardElevation,
                  child: Column(
                    children: thirdCardWidgets,
                  ),
                ),
                Card(
                  margin: AllpassEdgeInsets.settingCardInset,
                  elevation: cardElevation,
                  child: Column(
                    children: forthCardWidgets,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: AllpassScreenUtil.setHeight(15)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void checkUpdate() {
    var bean = inject<AllpassService>().checkUpdate();
    showDialog(
      context: context,
      builder: (cx) => FutureBuilder<UpdateBean>(
        future: bean,
        builder: (context, snapshot) => switch (snapshot.connectionState) {
          ConnectionState.done => UpdateDialog(snapshot.data!),
          _ => Center(
              child: CircularProgressIndicator(),
            ),
        },
      ),
    );
  }

  Future<Null> doRecommend() async {
    UpdateBean data = await inject<AllpassService>().getLatestVersion();
    if (data.downloadUrl != null) {
      Share.share(
        context.l10n.shareAllpassDesc(data.downloadUrl!),
        subject: context.l10n.shareAllpassSubject,
      );
    }
  }

}
