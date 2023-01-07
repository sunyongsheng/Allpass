import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/widget/confirm_dialog.dart';
import 'package:allpass/common/widget/information_help_dialog.dart';
import 'package:allpass/common/widget/select_item_dialog.dart';
import 'package:allpass/core/enums/allpass_type.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/webdav/encrypt/encrypt_level.dart';
import 'package:allpass/webdav/merge/merge_method.dart';
import 'package:allpass/webdav/ui/webdav_sync_provider.dart';
import 'package:allpass/webdav/ui/widget/select_backup_file_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WebDavSyncPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WebDavSyncPage();
  }
}

class _WebDavSyncPage extends State<WebDavSyncPage> {
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
                Consumer<WebDavSyncProvider>(
                  builder: (context, provider, child) {
                    return ListTile(
                      title: Text("上传到云端"),
                      subtitle: uploadTime == null ? null : Text(uploadTime),
                      leading: Icon(
                        Icons.cloud_upload,
                        color: AllpassColorUI.allColor[0],
                      ),
                      trailing: provider.uploading ? child : null,
                      onTap: () => _onClickBackup(provider),
                    );
                  },
                  child: SizedBox(
                    child: CircularProgressIndicator(strokeWidth: 2),
                    width: 15,
                    height: 15,
                  ),
                ),
                Consumer<WebDavSyncProvider>(
                  builder: (context, provider, child) {
                    return ListTile(
                      title: Text("恢复到本地"),
                      subtitle:
                          downloadTime == null ? null : Text(downloadTime),
                      leading: Icon(
                        Icons.cloud_download,
                        color: AllpassColorUI.allColor[1],
                      ),
                      trailing: provider.downloading ? child : null,
                      onTap: () => _onClickRecovery(provider),
                    );
                  },
                  child: SizedBox(
                    child: CircularProgressIndicator(strokeWidth: 2),
                    width: 15,
                    height: 15,
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin: AllpassEdgeInsets.settingCardInset,
            elevation: 0,
            child: Column(
              children: [
                ListTile(
                  title: Text("数据恢复方式"),
                  subtitle: Text("${Config.webDavMergeMethod.name}"),
                  leading: Icon(
                    Icons.merge_type_rounded,
                    color: AllpassColorUI.allColor[2],
                  ),
                  onTap: () => _onClickMergeMethod(),
                ),
                ListTile(
                  title: Text("加密等级"),
                  subtitle: Text("${Config.webDavEncryptLevel.name}"),
                  leading: Icon(
                    Icons.enhanced_encryption,
                    color: AllpassColorUI.allColor[5],
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.help_outline,
                      color: Colors.grey,
                    ),
                    onPressed: () => _onClickEncryptHelp(),
                  ),
                  onTap: () => _onClickEncrypt(),
                ),
              ],
            ),
          ),
          Card(
            margin: AllpassEdgeInsets.settingCardInset,
            elevation: 0,
            child: ListTile(
              title: Text("退出账号"),
              subtitle: Text("${Config.webDavUsername}"),
              leading: Icon(
                Icons.exit_to_app,
                color: AllpassColorUI.allColor[3],
              ),
              onTap: () => _onClickLogout(),
            ),
          ),
        ],
      ),
    );
  }

  void _onClickBackup(WebDavSyncProvider provider) async {
    showDialog(
        context: context,
        builder: (_) => ConfirmDialog(
              "确认上传",
              "当前加密等级为「${Config.webDavEncryptLevel.name}」，是否继续？",
              onConfirm: () async {
                var syncResult = await provider.syncToRemote(context);
                if (syncResult is SyncSuccess) {
                  ToastUtil.show(msg: syncResult.message);
                } else if (syncResult is Syncing) {
                  ToastUtil.show(msg: "上传中，请等待完成后重试");
                } else {
                  ToastUtil.showError(msg: syncResult.message);
                }
              },
            ));
  }

  void _onClickRecovery(WebDavSyncProvider provider) {
    showDialog(
        context: context,
        builder: (context) => ChangeNotifierProvider.value(
              value: provider,
              child: SelectBackupFileDialog(
                onSelect: (filename) => _handleRecovery(provider, filename),
              ),
            ));
  }

  void _handleRecovery(WebDavSyncProvider provider, String filename) {
    showDialog(
        context: context,
        builder: (_) => ConfirmDialog(
              "确认恢复",
              "当前恢复数据合并方式为「${Config.webDavMergeMethod.name}」，是否继续？",
              onConfirm: () async {
                var syncResult = await provider.syncToLocal(context, filename);
                if (syncResult is SyncSuccess) {
                  ToastUtil.show(msg: syncResult.message);
                } else if (syncResult is Syncing) {
                  ToastUtil.show(msg: "正在恢复中，请等待完成后重试");
                } else if (syncResult is SyncFallbackOld) {
                  _handleOldRecovery(provider, filename, syncResult.data);
                } else {
                  ToastUtil.showError(msg: syncResult.message);
                }
              },
            ));
  }

  void _handleOldRecovery(
      WebDavSyncProvider provider, String filename, List<dynamic> data) {
    showDialog(
        context: context,
        builder: (_) => DefaultSelectItemDialog(
            titleBuilder: () => null,
            list: ["密码", "卡片"],
            helpText: "检测到正在恢复旧版备份文件，请选择文件种类，"
                "文件种类将影响到最终恢复结果，请确保选择正确\n\n"
                "加密等级: ${Config.webDavEncryptLevel.name}  文件名: $filename",
            onSelected: (name) async {
              AllpassType type;
              if (name == "卡片") {
                type = AllpassType.card;
              } else {
                type = AllpassType.password;
              }
              var syncResult =
                  await provider.syncToLocalOld(context, data, type);
              if (syncResult is SyncSuccess) {
                ToastUtil.show(msg: syncResult.message);
              } else {
                ToastUtil.showError(msg: syncResult.message);
              }
            }));
  }

  void _onClickMergeMethod() {
    showDialog(
        context: context,
        builder: (context) => DefaultSelectItemDialog<MergeMethodItem>(
              list: mergeMethods,
              selector: (data) => data.method == Config.webDavMergeMethod,
              itemTitleBuilder: (data) => data.method.name,
              itemSubtitleBuilder: (data) => data.desc,
              onSelected: (item) {
                setState(() {
                  Config.setWebDavMergeMethod(item.method);
                });
              },
            ));
  }

  void _onClickEncryptHelp() {
    var boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
    var textStyle = TextStyle(fontSize: 14);
    showDialog(
        context: context,
        builder: (context) => InformationHelpDialog(
              content: <Widget>[
                Text(
                  "加密等级是指备份到WebDAV的文件的加密方式，"
                  "对于旧版备份文件(Allpass 2.0以下版本生成的备份文件)，"
                  "请确保上传与恢复的加密等级相同\n",
                  style: textStyle,
                ),
                Text.rich(TextSpan(children: [
                  TextSpan(text: "不加密：", style: boldTextStyle),
                  TextSpan(
                    text: "数据直接以明文的方式备份，密码字段可见；"
                        "最不安全但通用性高，可以直接打开备份文件查看密码\n",
                    style: textStyle,
                  )
                ])),
                Text.rich(TextSpan(children: [
                  TextSpan(text: "仅加密密码字段：", style: boldTextStyle),
                  TextSpan(
                    text: "默认选项，仅将密码与卡片记录中的“密码”字段进行加密，"
                        "而名称、用户名、标签之类的字段不加密\n",
                    style: textStyle,
                  )
                ])),
                Text.rich(TextSpan(children: [
                  TextSpan(text: "全部加密：", style: boldTextStyle),
                  TextSpan(
                    text: "所有字段全部进行加密，加密后的数据完全不可读，"
                        "最安全但是如果丢失了密钥则有可能无法找回文件\n",
                    style: textStyle,
                  )
                ])),
                Text(
                  "后两种加密方式严格依赖本机Allpass使用的密钥，"
                  "在丢失密钥的情况下，"
                  "一旦进行卸载或者数据清除操作则数据将无法恢复！！！",
                  style: textStyle,
                ),
              ],
            ));
  }

  void _onClickEncrypt() {
    showDialog(
        context: context,
        builder: (context) => DefaultSelectItemDialog<EncryptItem>(
              list: encryptLevels,
              selector: (data) => data.level == Config.webDavEncryptLevel,
              itemTitleBuilder: (data) => data.level.name,
              itemSubtitleBuilder: (data) => data.desc,
              onSelected: (item) {
                setState(() {
                  Config.setWevDavEncryptLevel(item.level);
                });
              },
            ));
  }

  void _onClickLogout() {
    showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
              "确认退出",
              "退出账号后需要重新登录，是否继续？",
              danger: true,
              onConfirm: () {
                Config.setWebDavAuthSuccess(false);
                Config.setWebDavUsername(null);
                Config.setWebDavPassword(null);
                Config.setWebDavUrl(null);
                Config.setWebDavPort(null);
                Navigator.pop(context);
              },
            ));
  }
}
