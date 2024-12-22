import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/widget/confirm_dialog.dart';
import 'package:allpass/common/widget/edit_text_dialog.dart';
import 'package:allpass/common/widget/information_help_dialog.dart';
import 'package:allpass/common/widget/select_item_dialog.dart';
import 'package:allpass/core/enums/allpass_type.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/encrypt/encryption.dart';
import 'package:allpass/l10n/l10n_support.dart';
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
    var l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.webDavSync,
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
                    var uploadTime = provider.uploadTime(context);
                    return ListTile(
                      title: Text(l10n.uploadToRemote),
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
                    var downloadTime = provider.downloadTime(context);
                    return ListTile(
                      title: Text(l10n.recoverToLocal),
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
                  title: Text(l10n.remoteBackupDirectory),
                  subtitle: Text("${Config.webDavBackupDirectory}"),
                  leading: Icon(
                    Icons.drive_folder_upload,
                    color: AllpassColorUI.allColor[4],
                  ),
                  onTap: () => _onClickBackupDirectory(),
                ),
                ListTile(
                  title: Text(l10n.backupFileMethod),
                  subtitle: Text(Config.webDavBackupMethod.title(context)),
                  leading: Icon(
                    Icons.file_present_outlined,
                    color: AllpassColorUI.allColor[7],
                  ),
                  onTap: () => _onClickBackupMethod(),
                ),
                ListTile(
                  title: Text(l10n.dataMergeMethod),
                  subtitle: Text("${Config.webDavMergeMethod.title(context)}"),
                  leading: Icon(
                    Icons.merge_type_rounded,
                    color: AllpassColorUI.allColor[2],
                  ),
                  onTap: () => _onClickMergeMethod(),
                ),
                ListTile(
                  title: Text(l10n.encryptLevel),
                  subtitle: Text("${Config.webDavEncryptLevel.title(context)}"),
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
              title: Text(l10n.logoutAccount),
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
    var l10n = context.l10n;
    showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        l10n.confirmUpload,
        l10n.confirmUploadWaring(Config.webDavEncryptLevel.title(context)),
        onConfirm: () async {
          var syncResult = await provider.syncToRemote(context);
          if (syncResult is SyncSuccess) {
            ToastUtil.show(msg: syncResult.message);
          } else if (syncResult is Syncing) {
            ToastUtil.show(msg: l10n.uploading);
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
        context.l10n.confirmRecover,
        context.l10n.confirmRecoverWarning(Config.webDavMergeMethod.title(context)),
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
      ToastUtil.show(msg: context.l10n.recovering);
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
      ToastUtil.show(msg: context.l10n.recovering);
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
    var l10n = context.l10n;
    showDialog(
      context: context,
      builder: (_) => DefaultSelectItemDialog(
        titleBuilder: (_) => null,
        list: [l10n.password, l10n.card],
        helpText: l10n.recoverV1FileHelp(Config.webDavEncryptLevel.title(context), filename),
        onSelected: (name) async {
          if (name == l10n.card) {
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
        dialogTitle: context.l10n.pleaseInputCustomSecretKey,
        initialText: "",
        helpText: context.l10n.inputCustomSecretKeyHelp,
        validator: (text) => text.length == 32,
        onConfirm: (encryptKey) => continuation(Encryption(encryptKey)),
      ),
    );
  }

  void _onClickBackupDirectory() {
    showDialog(
      context: context,
      builder: (context) => EditTextDialog(
        dialogTitle: context.l10n.pleaseInputBackupDirectory,
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
      builder: (_) => DefaultSelectItemDialog<WebDavBackupMethod>(
        list: WebDavBackupMethod.values,
        selector: (item) => item == Config.webDavBackupMethod,
        itemTitleBuilder: (ctx, data) => data.title(ctx),
        itemSubtitleBuilder: (ctx, data) {
          if (Config.webDavBackupMethod == WebDavBackupMethod.replaceExists &&
              data == WebDavBackupMethod.replaceExists) {
            return ctx.l10n.clickToViewAndEditConfig;
          }
          return null;
        },
        onSelected: (item) {
          if (item == WebDavBackupMethod.replaceExists) {
            showDialog(
              context: context,
              builder: (_) => WebDavCustomBackupFilenameDialog(
                filename: Config.webDavBackupFilename,
                onSubmit: (filename) {
                  setState(() {
                    Config.setWebDavBackupMethod(item);
                    Config.setWebDavCustomBackupFilename(filename);
                  });
                },
              ),
            );
          } else {
            setState(() {
              Config.setWebDavBackupMethod(item);
            });
          }
        },
      ),
    );
  }

  void _onClickMergeMethod() {
    showDialog(
      context: context,
      builder: (context) => DefaultSelectItemDialog<MergeMethod>(
        list: mergeMethods,
        selector: (data) => data == Config.webDavMergeMethod,
        itemTitleBuilder: (ctx, data) => data.title(ctx),
        itemSubtitleBuilder: (ctx, data) => data.desc(ctx),
        onSelected: (item) {
          setState(() {
            Config.setWebDavMergeMethod(item);
          });
        },
      ),
    );
  }

  void _onClickEncryptHelp() {
    var l10n = context.l10n;
    var boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
    var textStyle = TextStyle(fontSize: 14);
    showDialog(
      context: context,
      builder: (context) => InformationHelpDialog(
        content: <Widget>[
          Text(
            l10n.encryptHelp1,
            style: textStyle,
          ),
          Text.rich(TextSpan(children: [
            TextSpan(text: l10n.encryptHelp2, style: boldTextStyle),
            TextSpan(
              text: l10n.encryptHelp3,
              style: textStyle,
            )
          ])),
          Text.rich(TextSpan(children: [
            TextSpan(text: l10n.encryptHelp4, style: boldTextStyle),
            TextSpan(
              text: l10n.encryptHelp5,
              style: textStyle,
            )
          ])),
          Text.rich(TextSpan(children: [
            TextSpan(text: l10n.encryptHelp6, style: boldTextStyle),
            TextSpan(
              text: l10n.encryptHelp7,
              style: textStyle,
            )
          ])),
          Text(
            l10n.encryptHelp8,
            style: textStyle,
          ),
        ],
      ),
    );
  }

  void _onClickEncrypt() {
    showDialog(
      context: context,
      builder: (context) => DefaultSelectItemDialog<EncryptLevel>(
        list: encryptLevels,
        selector: (data) => data == Config.webDavEncryptLevel,
        itemTitleBuilder: (ctx, data) => data.title(ctx),
        itemSubtitleBuilder: (ctx, data) => data.desc(ctx),
        onSelected: (item) {
          setState(() {
            Config.setWevDavEncryptLevel(item);
          });
        },
      ),
    );
  }

  void _onClickLogout() {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        context.l10n.confirmLogout,
        context.l10n.confirmLogoutWaring,
        danger: true,
        onConfirm: () {
          Config.setWebDavAuthSuccess(false);
          Config.setWebDavUsername(null);
          Config.setWebDavPassword(null);
          Config.setWebDavUrl(null);
          Config.setWebDavUploadTime(null);
          Config.setWebDavDownloadTime(null);
          Config.setWevDavEncryptLevel(EncryptLevel.None);
          Config.setWebDavMergeMethod(MergeMethod.localFirst);
          Config.setWebDavBackupMethod(WebDavBackupMethod.createNew);
          Config.setWebDavCustomBackupFilename(null);
          Navigator.pop(context);
        },
      ),
    );
  }
}
