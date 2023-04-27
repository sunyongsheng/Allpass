import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/widget/confirm_dialog.dart';
import 'package:allpass/common/widget/edit_text_dialog.dart';
import 'package:allpass/common/widget/information_help_dialog.dart';
import 'package:allpass/common/widget/select_item_dialog.dart';
import 'package:allpass/core/enums/allpass_type.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/encrypt/encryption.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:allpass/util/path_util.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/webdav/backup/webdav_backup_method.dart';
import 'package:allpass/webdav/encrypt/encrypt_level.dart';
import 'package:allpass/webdav/merge/merge_method.dart';
import 'package:allpass/webdav/model/backup_file.dart';
import 'package:allpass/webdav/ui/webdav_sync_provider.dart';
import 'package:allpass/webdav/ui/widget/custom_backup_filename_dialog.dart';
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
                  builder: (context, provider, loadingChild) {
                    var uploadTime = provider.uploadTime;
                    return ListTile(
                      title: Text("上传到云端"),
                      subtitle: uploadTime == null ? null : Text(uploadTime),
                      leading: Icon(
                        Icons.cloud_upload,
                        color: AllpassColorUI.allColor[0],
                      ),
                      trailing: provider.uploading ? loadingChild : null,
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
                  builder: (context, provider, loadingChild) {
                    var downloadTime = provider.downloadTime;
                    return ListTile(
                      title: Text("恢复到本地"),
                      subtitle: downloadTime == null ? null : Text(downloadTime),
                      leading: Icon(
                        Icons.cloud_download,
                        color: AllpassColorUI.allColor[1],
                      ),
                      trailing: provider.downloading ? loadingChild : null,
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
                  title: Text("云端备份目录"),
                  subtitle: Text("${Config.webDavBackupDirectory}"),
                  leading: Icon(
                    Icons.drive_folder_upload,
                    color: AllpassColorUI.allColor[4],
                  ),
                  onTap: () => _onClickBackupDirectory(),
                ),
                ListTile(
                  title: Text("备份文件方式"),
                  subtitle: Text(Config.webDavBackupMethod.desc),
                  leading: Icon(
                    Icons.file_present_outlined,
                    color: AllpassColorUI.allColor[7],
                  ),
                  onTap: () => _onClickBackupMethod(),
                ),
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
      ),
    );
  }

  void _onClickRecovery(WebDavSyncProvider provider) {
    showDialog(
      context: context,
      builder: (context) => ChangeNotifierProvider.value(
        value: provider,
        child: SelectBackupFileDialog(
          onSelect: (filename) => _handleRecovery(provider, filename),
        ),
      ),
    );
  }

  void _handleRecovery(WebDavSyncProvider provider, String filename) {
    showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        "确认恢复",
        "当前恢复数据合并方式为「${Config.webDavMergeMethod.name}」，是否继续？",
        onConfirm: () => _handleRecoveryFromFileActual(provider, filename),
      ),
    );
  }

  void _handleRecoveryFromFileActual(WebDavSyncProvider provider, String filename) async {
    var syncResult = await provider.downloadFile(context, filename);
    if (syncResult is SyncSuccess<BackupFile>) {
      var backupFile = syncResult.result;
      if (backupFile is BackupFileV1) {
        _handleV1Recovery(provider, filename, backupFile);
      } else if (backupFile is BackupFileV2) {
        _handleV2RecoveryActual(provider, backupFile);
      }
    } else if (syncResult is Syncing) {
      ToastUtil.show(msg: "正在恢复中，请等待完成后重试");
    } else {
      ToastUtil.showError(msg: syncResult.message);
    }
  }

  void _handleV2RecoveryActual(
    WebDavSyncProvider provider,
    BackupFileV2 file, {
    Encryption? decryption,
  }) async {
    var syncResult = await provider.syncToLocalV2(
      context,
      file,
      encryption: decryption,
    );
    if (syncResult is SyncSuccess) {
      ToastUtil.show(msg: syncResult.message);
    } else if (syncResult is Syncing) {
      ToastUtil.show(msg: "正在恢复中，请等待完成后重试");
    } else if (syncResult is SyncPreDecryptFail) {
      ToastUtil.showError(msg: syncResult.message);
      _handlePreDecryptFail(
        (customDecryption) => _handleV2RecoveryActual(
          provider,
          file,
          decryption: customDecryption,
        ),
      );
    } else {
      ToastUtil.showError(msg: syncResult.message);
    }
  }

  void _handleV1Recovery(
    WebDavSyncProvider provider,
    String filename,
    BackupFileV1 backupFile,
  ) {
    showDialog(
      context: context,
      builder: (_) => DefaultSelectItemDialog(
        titleBuilder: () => null,
        list: ["密码", "卡片"],
        helpText: "检测到正在恢复旧版备份文件，请选择文件种类，"
            "文件种类将影响到最终恢复结果，请确保选择正确\n\n"
            "加密等级: ${Config.webDavEncryptLevel.name}  文件名: $filename",
        onSelected: (name) async {
          if (name == "卡片") {
            backupFile.type = AllpassType.card;
          } else {
            backupFile.type = AllpassType.password;
          }
          await _handleV1RecoveryActual(provider, backupFile);
        },
      ),
    );
  }

  Future<void> _handleV1RecoveryActual(
    WebDavSyncProvider provider,
    BackupFileV1 backupFile, {
    Encryption? decryption,
  }) async {
    var syncResult = await provider.syncToLocalV1(
      context,
      backupFile,
      decryption: decryption,
    );
    if (syncResult is SyncSuccess) {
      ToastUtil.show(msg: syncResult.message);
    } else if (syncResult is SyncPreDecryptFail) {
      ToastUtil.showError(msg: syncResult.message);
      _handlePreDecryptFail(
        (customDecryption) => _handleV1RecoveryActual(
          provider,
          backupFile,
          decryption: customDecryption,
        ),
      );
    } else {
      ToastUtil.showError(msg: syncResult.message);
    }
  }

  void _handlePreDecryptFail(void Function(Encryption customDecryption) continuation) {
    showDialog(
      context: context,
      builder: (ctx) => EditTextDialog(
        dialogTitle: "请输入自定义密钥(32位)",
        initialText: "",
        helpText: "备份文件所使用加密密钥与当前密钥不一致，请更换备份文件或更新密钥",
        validator: (text) => text.length == 32,
        onConfirm: (encryptKey) => continuation(Encryption(encryptKey)),
      ),
    );
  }

  void _onClickBackupDirectory() {
    showDialog(
      context: context,
      builder: (context) => EditTextDialog(
        dialogTitle: '请输入备份目录路径',
        initialText: Config.webDavBackupDirectory,
        onConfirm: (value) {
          setState(() {
            Config.setWebDavBackupDirectory(PathUtil.formatRelativePath(value));
          });
        },
      ),
    );
  }

  void _onClickBackupMethod() {
    showDialog(
      context: context,
      builder: (_) => DefaultSelectItemDialog<WebDavBackupMethodItem>(
        list: backupMethods,
        selector: (item) => item.method == Config.webDavBackupMethod,
        itemTitleBuilder: (data) => data.name,
        onSelected: (item) {
          if (item.method == WebDavBackupMethod.replaceExists) {
            showDialog(
              context: context,
              builder: (_) => WebDavCustomBackupFilenameDialog(
                filename: Config.webDavBackupFilename,
                onSubmit: (filename) {
                  setState(() {
                    Config.setWebDavBackupMethod(item.method);
                    Config.setWebDavCustomBackupFilename(filename);
                  });
                },
              ),
            );
          } else {
            setState(() {
              Config.setWebDavBackupMethod(item.method);
            });
          }
        },
      ),
    );
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
      ),
    );
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
            "对于旧版备份文件(Allpass 1.7.0以下版本生成的备份文件)，"
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
      ),
    );
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
      ),
    );
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
          Navigator.pop(context);
        },
      ),
    );
  }
}
