import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:allpass/application.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/password/data/password_dao.dart';
import 'package:allpass/card/data/card_dao.dart';
import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/login/page/init_encrypt_page.dart';
import 'package:allpass/setting/webdav/webdav_sync_page.dart';
import 'package:allpass/common/widget/select_item_dialog.dart';

/// 调试页
class DebugPage extends StatefulWidget {
  @override
  _DebugPage createState() {
    return _DebugPage();
  }

}

class _DebugPage extends State<DebugPage> {

  final PasswordDao _passwordDao = Application.getIt.get();
  final CardDao _cardDao = Application.getIt.get();

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
                child: Text("页面测试"),
                onPressed: () async {
                  showDialog<String>(
                      context: context,
                      builder: (context) => SelectItemDialog<String>(
                        list: ["init_encrypt", "webdav_sync"],
                        itemBuilder: (_, data) => Text(data),
                      )
                  ).then((value) {
                    if (value != null) {
                      if (value == "init_encrypt") {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => InitEncryptPage()
                        ));
                      } else if (value == "webdav_sync") {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => WebDavSyncPage()
                        ));
                      }
                    }
                  });
                },
              ),
            ),
            ListTile(
              title: TextButton(
                child: Text("查看sp"),
                onPressed: () async {
                  Set<String> keys = Application.sp.getKeys();
                  keys.remove("password");
                  showDialog<Null>(
                      context: context,
                      builder: (context) =>
                          SimpleDialog(
                              children: keys.map((key) => ListTile(
                                title: Text(key),
                                subtitle: Text(Application.sp.get(key).toString()),
                                onLongPress: () {
                                  Application.sp.remove(key);
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
                  await Provider.of<PasswordProvider>(context, listen: false).clear();
                  ToastUtil.show(msg: "已删除所有密码");
                },
              ),
            ),
            ListTile(
              title: TextButton(
                child: Text("删除所有卡片记录"),
                onPressed: () async {
                  await Provider.of<CardProvider>(context, listen: false).clear();
                  ToastUtil.show(msg: "已删除所有卡片");
                },
              ),
            ),
            ListTile(
              title: TextButton(
                child: Text("删除密码数据库"),
                onPressed: () async {
                  await Provider.of<PasswordProvider>(context, listen: false).clear();
                  await _passwordDao.deleteTable();
                  ToastUtil.show(msg: "已删除密码数据库");
                },
              ),
            ),
            ListTile(
              title: TextButton(
                child: Text("删除卡片数据库"),
                onPressed: () async {
                  await Provider.of<PasswordProvider>(context, listen: false).clear();
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