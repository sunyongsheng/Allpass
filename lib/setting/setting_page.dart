import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:provider/provider.dart';

import 'package:allpass/application.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/core/enums/category_type.dart';
import 'package:allpass/core/param/constants.dart';
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
import 'package:allpass/setting/webdav/webdav_config_page.dart';
import 'package:allpass/setting/webdav/webdav_sync_page.dart';
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
    _localAuthService = AllpassApplication.getIt<AuthService>();
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

    var firstCardWidgets = [
      ListTile(
        title: Text("主账号管理"),
        leading: Icon(Icons.account_circle_outlined, color: AllpassColorUI.allColor[0],),
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(
              builder: (context) => AccountManagerPage()
          ));
        },
      ),
      ListTile(
        title: Text("生物识别"),
        leading: Icon(Icons.fingerprint, color: AllpassColorUI.allColor[1]),
        trailing: Switch(
          value: Config.enabledBiometrics,
          onChanged: (sw) async {
            if (await _localAuthService.canAuthenticate()) {
              showDialog(context: context,
                builder: (context) => InputMainPasswordDialog(),
              ).then((right) async {
                if (right) {
                  var authResult = await _localAuthService.authenticate();
                  switch (authResult) {
                    case AuthResult.Success:
                      await _localAuthService.stopAuthenticate();
                      setState(() {
                        Config.setEnabledBiometrics(sw);
                      });
                      ToastUtil.show(msg: "已开启生物识别");
                      break;
                    case AuthResult.NotAvailable:
                      ToastUtil.show(msg: "生物识别不可用，请确保设备支持并已启用");
                      break;
                    default:
                      ToastUtil.show(msg: "授权失败");
                  }
                }
              });
            } else {
              Config.setEnabledBiometrics(false);
              ToastUtil.show(msg: "您的设备似乎不支持生物识别");
            }
          },
        ),
      ),
      ListTile(
        title: Text("长按复制密码或卡号"),
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
        title: Text("主题颜色"),
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
        title: Text("标签管理"),
        leading: Icon(Icons.label_outline, color: AllpassColorUI.allColor[3]),
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(
              builder: (context) => CategoryManagerPage(CategoryType.label)
          ));
        },
      ),
      ListTile(
        title: Text("文件夹管理"),
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
        title: Text("WebDAV同步"),
        leading: Icon(Icons.cloud_outlined, color: AllpassColorUI.allColor[0]),
        onTap: () {
          if (Config.webDavAuthSuccess) {
            Navigator.push(context, CupertinoPageRoute(
              builder: (context) => WebDavSyncPage(),
            ));
          } else {
            Navigator.push(context, CupertinoPageRoute(
              builder: (context) => WebDavConfigPage(),
            ));
          }
        },
      ),
      ListTile(
        title: Text("导入/导出"),
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
        title: Text("自动填充"),
        leading: Icon(Icons.edit_road, color: AllpassColorUI.allColor[6]),
        onTap: () {
          AllpassApplication.methodChannel.invokeMethod(ChannelConstants.methodIsAppDefaultAutofill).then((enabled) => {
            if (enabled) {
              ToastUtil.show(msg: "Allpass已经是默认自动填充服务，无需设置")
            } else {
              AllpassApplication.methodChannel.invokeMethod(ChannelConstants.methodSetAppDefaultAutofill)
            }
          });
        },
      ));
    }

    var forthCardWidgets = [
      ListTile(
          title: Text("推荐给好友"),
          leading: Icon(Icons.share, color: AllpassColorUI.allColor[2]),
          onTap: () async => await doRecommend()
      ),
      ListTile(
          title: Text("意见反馈"),
          leading: Icon(Icons.feedback_outlined, color: AllpassColorUI.allColor[1]),
          onTap: () => Navigator.push(context, CupertinoPageRoute(
            builder: (context) => FeedbackPage(),
          ))
      ),
      ListTile(
          title: Text("检查更新"),
          leading: Icon(Icons.update, color: AllpassColorUI.allColor[6]),
          onTap: () => checkUpdate()
      ),
      ListTile(
        title: Text("关于"),
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
            "设置",
            style: AllpassTextUI.titleBarStyle,
          ),
          onTap: () {
            _controller.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
          },
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Provider.of<ThemeProvider>(context).specialBackgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              controller: _controller,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: AllpassScreenUtil.setHeight(15)),
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
    var bean = AllpassApplication.getIt<AllpassService>().checkUpdate();
    showDialog(
        context: context,
        builder: (cx) => FutureBuilder<UpdateBean>(
          future: bean,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return UpdateDialog(snapshot.data!);
              default:
                return Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        )
    );
  }

  Future<Null> doRecommend() async {
    UpdateBean data = await AllpassApplication.getIt<AllpassService>().getLatestVersion();
    Share.share(
        "【Allpass】一款简洁好用的私密信息管理工具。【下载地址】${data.downloadUrl}",
        subject: "软件推荐——Allpass");
  }

}
