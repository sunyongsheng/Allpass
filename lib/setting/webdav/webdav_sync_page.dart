import 'package:flutter/material.dart';

import 'package:allpass/application.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/util/date_formatter.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/core/service/webdav_sync_service.dart';
import 'package:allpass/common/widget/confirm_dialog.dart';
import 'package:allpass/common/widget/information_help_dialog.dart';
import 'package:allpass/common/widget/select_item_dialog.dart';
import 'package:allpass/setting/webdav/widget/modify_webdav_filename_dialog.dart';

class WebDavSyncPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WebDavSyncPage();
  }
}

class _WebDavSyncPage extends State<WebDavSyncPage> {

  late bool _pressUpload;
  late bool _pressDownload;
  late WebDavSyncService _syncService;

  List<String> levels = ["不加密", "仅加密密码字段", "全部加密"];

  @override
  void initState() {
    super.initState();
    _pressUpload = false;
    _pressDownload = false;
    _syncService = AllpassApplication.getIt<WebDavSyncService>();
  }

  @override
  Widget build(BuildContext context) {
    String? uploadTime;
    String? downloadTime;
    if (Config.webDavUploadTime != null) {
      uploadTime = "最近上传于${Config.webDavUploadTime}";
    }
    if (Config.webDavDownloadTime != null) {
      downloadTime = "最近恢复于${Config.webDavDownloadTime}";
    }

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
              subtitle: uploadTime == null ? null : Text(uploadTime),
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
                  bool auth = await _authCheck();
                  if (auth) {
                    bool res = await _upload();
                    setState(() {
                      _pressUpload = false;
                    });
                    if (res) {
                      ToastUtil.show(msg: "上传云端成功");
                    } else {
                      ToastUtil.showError(msg: "上传云端失败，请检查网络");
                    }
                  } else {
                    setState(() {
                      _pressUpload = false;
                    });
                    ToastUtil.showError(msg: "账号权限失效，请检查网络或退出账号并重新配置");
                  }
                }
              },
            ),
            padding: AllpassEdgeInsets.listInset,
          ),
          Container(
            child: ListTile(
              title: Text("恢复到本地"),
              subtitle: downloadTime == null ? null : Text(downloadTime),
              leading: Icon(Icons.cloud_download, color: AllpassColorUI.allColor[1],),
              trailing: _pressDownload ? SizedBox(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
                width: 15,
                height: 15,
              ) : null,
              onTap: () async {
                bool? yes = await showDialog<bool>(
                  context: context,
                  builder: (context) => ConfirmDialog("请确认", "恢复数据将覆盖本地所有数据，是否继续？")
                );
                if (yes ?? false) {
                  setState(() {
                    _pressDownload = true;
                  });
                  bool auth = await _authCheck();
                  if (auth) {
                    List<String> res = await _download();
                    setState(() {
                      _pressDownload = false;
                    });
                    ToastUtil.show(msg: res[0]);
                    ToastUtil.show(msg: res[1]);
                  } else {
                    setState(() {
                      _pressDownload = false;
                    });
                    ToastUtil.showError(msg: "账号权限失效，请检查网络或退出账号并重新配置");
                  }
                }
              },
            ),
            padding: AllpassEdgeInsets.listInset,
          ),
          Container(
            child: ListTile(
              title: Text("备份文件名"),
              leading: Icon(Icons.insert_drive_file, color: AllpassColorUI.allColor[4],),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ModifyWebDavFileNameDialog(
                    oldPasswordName: Config.webDavPasswordName,
                    oldCardName: Config.webDavCardName,
                  )
                ).then((value) {
                  if (value is Map) {
                    Config.setPasswordFileName(value['password']);
                    Config.setCardFileName(value['card']);
                    ToastUtil.show(msg: "修改成功");
                  } else if (value is String) {
                    ToastUtil.show(msg: value);
                  }
                });
              },
            ),
            padding: AllpassEdgeInsets.listInset,
          ),
          Container(
            child: ListTile(
              title: Text("加密等级"),
              leading: Icon(Icons.enhanced_encryption, color: AllpassColorUI.allColor[5],),
              trailing: IconButton(
                icon: Icon(Icons.help_outline, color: Colors.grey,),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => InformationHelpDialog(
                      content: <Widget>[
                        Text("加密等级是指备份到WebDAV的文件的加密方式，请确保上传与恢复的加密等级相同\n"),
                        Text("不加密：数据直接以明文的方式备份，密码字段可见；最不安全但是可以在任意设备上查找密码\n"),
                        Text("仅加密密码字段：仅将密码与卡片记录中的“密码”字段进行加密，而名称、标签之类的字段不加密\n"),
                        Text("全部加密：所有字段全部进行加密，加密后的数据完全不可读，最安全但是如果丢失了密钥则有可能无法找回文件\n"),
                        Text("后两种加密方式严格依赖本机Allpass使用的密钥，在丢失密钥的情况下，一旦进行卸载或者数据清除操作则数据将无法恢复！！！"),
                      ],
                    )
                  );
                },
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => DefaultSelectItemDialog<String>(
                      list: levels,
                      selector: (data) => data == getEncryptLevelString(),
                    )
                ).then((value) {
                  if (value != null) {
                    Config.setWevDavEncryptLevel(getEncryptLevelInt(value));
                  }
                });
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
                  if (yes ?? false) {
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

  Future<bool> _authCheck() async {
    return await _syncService.authCheck();
  }

  Future<bool> _upload() async {
    try {
      await _syncService.backupFolderAndLabel(context);
      bool ps = await _syncService.backupPassword(context);
      bool cs = await _syncService.backupCard(context);
      if (ps && cs) {
        setState(() {
          Config.setWebDavUploadTime(DateFormatter.format(DateTime.now()));
        });
      }
      return ps && cs;
    } on Error catch (e) {
      print(e.toString());
      print(e.stackTrace.toString());
      return false;
    }
  }

  Future<List<String>> _download() async {
    int p = await _syncService.recoverPassword(context);
    int c = await _syncService.recoverCard(context);
    await _syncService.recoverFolderAndLabel();
    List<String> msg = [];
    bool pb = false;
    bool cb = false;
    bool ps = false;
    bool cs = false;
    if (p == -1) {
      msg.add("未找到云端密码文件，请确保云端文件名与设置相同并为json文件");
    } else if (p == 0) {
      msg.add("密码恢复成功");
      ps = true;
    } else if (p == 2) {
      msg.add("密码恢复失败，请检查网络或者是云端文件受损");
      pb = true;
    } else {
      msg.add("密码恢复失败，未知错误");
    }
    if (c == -1) {
      msg.add("未找到云端卡片文件，请确保云端文件名与设置相同并为json文件");
    } else if (c == 0) {
      msg.add("卡片信息恢复成功");
      cs = true;
    } else if (c == 2) {
      msg.add("卡片恢复失败，请检查网络或者是云端文件受损");
      cb = true;
    } else {
      msg.add("卡片恢复失败，未知错误");
    }
    if (pb && cb) {
      msg.add("请确保本机加密等级及密钥与备份云端时一致！");
    }
    if (ps && cs) {
      setState(() {
        Config.setWebDavDownloadTime(DateFormatter.format(DateTime.now()));
      });
    }
    return msg;
  }

  String getEncryptLevelString() {
    return levels[Config.webDavEncryptLevel];
  }

  int getEncryptLevelInt(String level) {
    return levels.indexOf(level);
  }
}