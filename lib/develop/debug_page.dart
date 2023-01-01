import 'package:allpass/webdav/ui/webdav_sync_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_apps/device_apps.dart';
import 'package:allpass/application.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/password/data/password_dao.dart';
import 'package:allpass/card/data/card_dao.dart';
import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/login/page/init_encrypt_page.dart';
import 'package:allpass/webdav/ui/webdav_sync_page.dart';
import 'package:allpass/common/widget/select_item_dialog.dart';
import 'package:allpass/password/widget/select_app_dialog.dart';

/// 调试页
class DebugPage extends StatefulWidget {
  @override
  _DebugPage createState() {
    return _DebugPage();
  }

}

class _DebugPage extends State<DebugPage> {

  final PasswordDao _passwordDao = AllpassApplication.getIt.get();
  final CardDao _cardDao = AllpassApplication.getIt.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DEBUG MODE"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              title: TextButton(
                child: Text("显示设备已安装App"),
                onPressed: () async {
                  List<Application> installedApps = await DeviceApps.getInstalledApplications(includeAppIcons: true);
                  showDialog(
                      context: context,
                      builder: (_) => SelectAppDialog(
                        list: installedApps,
                        selectedApp: "top.aengus.fove",
                        onSelected: (app) {
                          debugPrint(app.appName);
                        },
                        onCancel: () {},
                      )
                  );
                },
              ),
            ),
            ListTile(
              title: TextButton(
                child: Text("页面测试"),
                onPressed: () async {
                  showDialog<String>(
                      context: context,
                      builder: (context) => DefaultSelectItemDialog<String>(
                        list: ["init_encrypt", "webdav_sync"],
                        onSelected: (value) {
                          if (value == "init_encrypt") {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => InitEncryptPage()
                            ));
                          } else if (value == "webdav_sync") {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (context) => WebDavSyncProvider(),
                                  child: WebDavSyncPage(),
                                )
                            ));
                          }
                        },
                      )
                  );
                },
              ),
            ),
            ListTile(
              title: TextButton(
                child: Text("查看sp"),
                onPressed: () async {
                  Set<String> keys = AllpassApplication.sp.getKeys();
                  keys.remove("password");
                  showDialog<Null>(
                      context: context,
                      builder: (context) =>
                          SimpleDialog(
                              children: keys.map((key) => ListTile(
                                title: Text(key),
                                subtitle: Text(AllpassApplication.sp.get(key).toString()),
                                onLongPress: () {
                                  AllpassApplication.sp.remove(key);
                                },
                              )).toList()
                          )
                  );
                },
              ),
            ),
            ListTile(
              title: TextButton(
                child: Text("删除所有密码记录"),
                onPressed: () async {
                  await context.read<PasswordProvider>().clear();
                  ToastUtil.show(msg: "已删除所有密码");
                },
              ),
            ),
            ListTile(
              title: TextButton(
                child: Text("删除所有卡片记录"),
                onPressed: () async {
                  await context.read<CardProvider>().clear();
                  ToastUtil.show(msg: "已删除所有卡片");
                },
              ),
            ),
            ListTile(
              title: TextButton(
                child: Text("删除密码数据库"),
                onPressed: () async {
                  await context.read<PasswordProvider>().clear();
                  await _passwordDao.deleteTable();
                  ToastUtil.show(msg: "已删除密码数据库");
                },
              ),
            ),
            ListTile(
              title: TextButton(
                child: Text("删除卡片数据库"),
                onPressed: () async {
                  await context.read<CardProvider>().clear();
                  await _cardDao.deleteTable();
                  ToastUtil.show(msg: "已删除卡片数据库");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}