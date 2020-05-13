import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/application.dart';
import 'package:allpass/ui/allpass_ui.dart';
import 'package:allpass/params/config.dart';
import 'package:allpass/services/webdav_sync_service.dart';
import 'package:allpass/widgets/common/confirm_dialog.dart';

class WebDavSyncPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WebDavSyncPage();
  }
}

class _WebDavSyncPage extends State<WebDavSyncPage> {

  bool _pressUpload;
  bool _pressDownload;
  WebDavSyncService _syncService;

  _WebDavSyncPage() {
    _syncService = Application.getIt<WebDavSyncService>();
  }

  @override
  void initState() {
    super.initState();
    _pressUpload = false;
    _pressDownload = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "WebDAV同步",
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: ListTile(
              title: Text("上传到云端"),
              leading: Icon(Icons.cloud_upload, color: AllpassColorUI.allColor[0],),
              trailing: _pressUpload ? SizedBox(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
                width: 15,
                height: 15,
              ) : null,
              onTap: () async {
                bool yes = await showDialog(
                  context: context,
                  builder: (context) => ConfirmDialog("请确认", "本地数据将覆盖云端数据，是否继续？")
                );
                if (yes) {
                  setState(() {
                    _pressUpload = true;
                  });
                  bool res = await _upload();
                  setState(() {
                    _pressUpload = false;
                  });
                  if (res) {
                    Fluttertoast.showToast(msg: "上传云端成功");
                  } else {
                    Fluttertoast.showToast(msg: "上传云端失败，请检查网络");
                  }
                }
              },
            ),
            padding: AllpassEdgeInsets.listInset,
          ),
          Container(
            child: ListTile(
              title: Text("恢复到本地"),
              leading: Icon(Icons.cloud_download, color: AllpassColorUI.allColor[1],),
              trailing: _pressDownload ? SizedBox(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
                width: 15,
                height: 15,
              ) : null,
              onTap: () async {
                bool yes = await showDialog<bool>(
                  context: context,
                  builder: (context) => ConfirmDialog("请确认", "恢复数据将覆盖本地所有数据，是否继续？")
                );
                if (yes) {
                  setState(() {
                    _pressDownload = true;
                  });
                  int res = await _download();
                  setState(() {
                    _pressDownload = false;
                  });
                  if (res == 0) {
                    Fluttertoast.showToast(msg: "恢复到本地成功");
                  } else if (res == 2){
                    Fluttertoast.showToast(msg: "恢复到本地失败，请检查网络或源文件受损");
                  } else {
                    Fluttertoast.showToast(msg: "恢复到本地失败，未知错误");
                  }
                }
              },
            ),
            padding: AllpassEdgeInsets.listInset,
          ),
          Container(
            child: ListTile(
              title: Text("退出账号"),
              leading: Icon(Icons.exit_to_app, color: AllpassColorUI.allColor[3],),
              onTap: () {
                showDialog<bool>(
                    context: context,
                  builder: (context) => ConfirmDialog("确认退出", "退出账号后需要重新登录，是否继续？")
                ).then((yes) {
                  if (yes) {
                    Config.setWebDavAuthSuccess(false);
                    Config.setWebDavUsername(null);
                    Config.setWebDavPassword(null);
                    Config.setWebDavUrl(null);
                    Config.setWebDavPort(null);
                    Navigator.pop(context);
                  }
                });
              },
            ),
            padding: AllpassEdgeInsets.listInset,
          ),
        ],
      ),
    );
  }

  Future<bool> _upload() async {
    try {
      return (await _syncService.backupPassword(context)) &&
          (await _syncService.backupCard(context));
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<int> _download() async {
    if ((await _syncService.recoverPassword(context) == 0) &&
        (await _syncService.recoverCard(context) == 0)) {
      return 0;
    } else if ((await _syncService.recoverPassword(context) == 1) ||
        (await _syncService.recoverCard(context) == 1)) {
      return 1;
    } else if ((await _syncService.recoverPassword(context) == 2) ||
        (await _syncService.recoverCard(context) == 2)) {
      return 2;
    } else {
      return 3;
    }
  }

}