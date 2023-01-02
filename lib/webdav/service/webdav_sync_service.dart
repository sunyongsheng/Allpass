import 'dart:convert';

import 'package:allpass/application.dart';
import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/card/model/card_extension.dart';
import 'package:allpass/core/enums/allpass_type.dart';
import 'package:allpass/core/enums/encrypt_level.dart';
import 'package:allpass/core/model/data/base_model.dart';
import 'package:allpass/core/model/data/extra_model.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/password/model/password_extension.dart';
import 'package:allpass/util/allpass_file_util.dart';
import 'package:allpass/util/date_formatter.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/webdav/error/sync_error.dart';
import 'package:allpass/webdav/merge/merge_executors.dart';
import 'package:allpass/webdav/model/backup_file.dart';
import 'package:allpass/webdav/model/webdav_file.dart';
import 'package:allpass/webdav/service/webdav_requester.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

abstract class WebDavSyncService {
  /// 权限检查
  Future<bool> authCheck();

  /// 备份密码到指定的目录中
  Future<void> backupPassword(BuildContext context);

  /// 备份卡片到指定的目录中
  Future<void> backupCard(BuildContext context);

  /// 备份文件夹及标签
  Future<void> backupFolderAndLabel(BuildContext context);

  /// May Throws [DioError]/[DecodeException]/[UnsupportedArgumentError]/[UnknownError]
  Future<AllpassType> recovery(BuildContext context, String filename);

  Future<void> recoveryOld(
      BuildContext context, List<dynamic> list, AllpassType type);

  Future<List<WebDavFile>> getAllBackupFiles();
}

class WebDavSyncServiceImpl implements WebDavSyncService {
  final String _tag = "WebDavSyncServiceImpl";

  final String remoteWorkspace = "Allpass";
  final String localWorkspace = "webdav_backup";

  WebDavRequester? _requesterImpl;

  WebDavRequester get _requester {
    if (_requesterImpl == null) {
      _requesterImpl = WebDavRequester(
        urlPath: Config.webDavUrl,
        username: Config.webDavUsername,
        password: Config.webDavPassword == null
            ? null
            : EncryptUtil.decrypt(Config.webDavPassword!),
        port: Config.webDavPort,
      );
    }
    return _requesterImpl!;
  }

  @override
  Future<bool> authCheck() async => await _requester.authorityCheck();

  @override
  Future<void> backupPassword(BuildContext context) async {
    var passwords = context.read<PasswordProvider>().passwordList;
    await _backupActual(passwords, AllpassType.password);
  }

  @override
  Future<void> backupCard(BuildContext context) async {
    var cards = context.read<CardProvider>().cardList;
    await _backupActual(cards, AllpassType.card);
  }

  @override
  Future<void> backupFolderAndLabel(BuildContext context) async {
    await _backupActual([], AllpassType.other);
  }

  Future<void> _backupActual(List<BaseModel> data, AllpassType type) async {
    await ensureRemoteWorkspace();

    String contents = jsonEncode(_createBackup(data, type));
    String fileName = _generateFilename(type);

    var filePath =
        await AllpassFileUtil.writeFile(localWorkspace, fileName, contents);

    await _requester.uploadFile(
        fileName: fileName, dirName: remoteWorkspace, filePath: filePath);
    await AllpassFileUtil.deleteFile(filePath);
  }

  String _generateFilename(AllpassType type) {
    var now = DateFormatter.formatToFilename(DateTime.now());
    var isDebug = !bool.fromEnvironment("dart.vm.product");
    String suffix = "";
    if (isDebug) {
      suffix = "_debug";
    }
    switch (type) {
      case AllpassType.password:
        return "${now}_allpass_password$suffix.json";
      case AllpassType.card:
        return "${now}_allpass_card$suffix.json";
      case AllpassType.other:
        return "${now}_allpass_extra$suffix.json";
    }
  }

  BackupFile _createBackup(List<BaseModel> list, AllpassType type) {
    var level = Config.webDavEncryptLevel;
    String data;
    switch (type) {
      case AllpassType.password:
        var encryptedList = (list as List<PasswordBean>).encrypt(level);
        data = jsonEncode(encryptedList);
        break;
      case AllpassType.card:
        var encryptedList = (list as List<CardBean>).encrypt(level);
        data = jsonEncode(encryptedList);
        break;
      case AllpassType.other:
        List<String> folder = List.from(RuntimeData.folderList);
        List<String> label = List.from(RuntimeData.labelList);
        data = jsonEncode(ExtraModel(folder, label));
        break;
    }
    return BackupFile(
        metaData: FileMetaData(
            type: type,
            encryptLevel: level,
            appVersion: AllpassApplication.version),
        data: data);
  }

  @override
  Future<AllpassType> recovery(BuildContext context, String filename) async {
    String filePath = await _requester.downloadFile(
        fileName: filename, dirName: remoteWorkspace);

    String string = AllpassFileUtil.readFile(filePath);
    var decodeResult = jsonDecode(string);
    if (decodeResult is List<dynamic>) {
      throw FallbackOldException(decodeResult);
    } else if (!(decodeResult is Map<String, dynamic>)) {
      throw UnsupportedContentException();
    }

    BackupFile file = BackupFile.fromJson(decodeResult);
    var type = file.metaData.type;
    var level = file.metaData.encryptLevel;
    switch (type) {
      case AllpassType.password:
        var list = _decodeList<PasswordBean>(jsonDecode(file.data), level);
        if (list == null) {
          throw DecodeException();
        }

        recoverPassword(context, list);
        break;
      case AllpassType.card:
        var list = _decodeList<CardBean>(jsonDecode(file.data), level);
        if (list == null) {
          throw DecodeException();
        }

        recoverCard(context, list);
        break;
      case AllpassType.other:
        var model = _decodeFolderAndLabel(file.data);
        if (model == null) {
          throw DecodeException();
        }

        recoverFolderAndLabel(model);
        break;
    }
    return type;
  }

  List<T>? _decodeList<T extends BaseModel>(
      List<dynamic> list, EncryptLevel encryptLevel) {
    if (T == PasswordBean) {
      List<PasswordBean> results = [];
      for (var temp in list) {
        var bean = PasswordBean.fromJson(temp);
        results.add(bean.decrypt(encryptLevel));
      }
      return results as List<T>;
    } else if (T == CardBean) {
      List<CardBean> results = [];
      for (var temp in list) {
        var bean = CardBean.fromJson(temp);
        results.add(bean.decrypt(encryptLevel));
      }
      return results as List<T>;
    }
    return null;
  }

  ExtraModel? _decodeFolderAndLabel(String string) {
    try {
      var decoded = json.decode(string);

      var folderList = <String>[];
      for (var item in decoded['folder']) {
        folderList.add(item.toString());
      }

      var labelList = <String>[];
      for (var item in decoded['label']) {
        labelList.add(item.toString());
      }

      return ExtraModel(folderList, labelList);
    } on FormatException {
      return null;
    }
  }

  Future<int> recoverPassword(BuildContext context, List<PasswordBean> remoteList) async {
    var passwordProvider = context.read<PasswordProvider>();
    List<PasswordBean> localList = List.from(passwordProvider.passwordList);
    var mergeExecutor = Config.webDavMergeMethod.createExecutor<PasswordBean>();
    try {
      var result = mergeExecutor.merge(localList, remoteList);
      result.apply(add: (bean) {
        debugPrint("$_tag recoverCard insertPassword $bean");

        passwordProvider.insertPassword(bean);
        RuntimeData.labelListAdd(bean.label);
        RuntimeData.folderListAdd(bean.folder);
      }, delete: (bean) {
        debugPrint("$_tag recoverCard deletePassword $bean");

        passwordProvider.deletePassword(bean);
      });
      return result.length;
    } catch (e2) {
      print(e2);
      return -1;
    }
  }

  Future<int> recoverCard(BuildContext context, List<CardBean> remoteList) async {
    var cardProvider = context.read<CardProvider>();
    List<CardBean> localList = List.from(cardProvider.cardList);
    var mergeExecutor = Config.webDavMergeMethod.createExecutor<CardBean>();
    try {
      var result = mergeExecutor.merge(localList, remoteList);
      result.apply(add: (bean) {
        debugPrint("$_tag recoverCard insertCard $bean");

        cardProvider.insertCard(bean);
        RuntimeData.labelListAdd(bean.label);
        RuntimeData.folderListAdd(bean.folder);
      }, delete: (bean) {
        debugPrint("$_tag recoverCard deleteCard $bean");

        cardProvider.deleteCard(bean);
      });
      return result.length;
    } catch (e2) {
      print(e2);
      return -1;
    }
  }

  Future<bool> recoverFolderAndLabel(ExtraModel model) async {
    try {
      RuntimeData.folderList.clear();
      RuntimeData.folderList.addAll(model.folderList);
      RuntimeData.labelList.clear();
      RuntimeData.labelList.addAll(model.labelList);
      RuntimeData.folderParamsPersistence();
      RuntimeData.labelParamsPersistence();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<WebDavFile>> getAllBackupFiles() async {
    return await _requester.listFiles(remoteWorkspace) ?? [];
  }

  Future<Null> ensureRemoteWorkspace() async {
    if (!(await _requester.containsFile(fileName: remoteWorkspace))) {
      await _requester.createDir(remoteWorkspace);
    }
  }

  @override
  Future<void> recoveryOld(
      BuildContext context, List<dynamic> list, AllpassType type) async {
    switch (type) {
      case AllpassType.password:
        var result = _decodeList<PasswordBean>(list, Config.webDavEncryptLevel);
        if (result == null) {
          throw DecodeException();
        }

        recoverPassword(context, result);
        break;
      case AllpassType.card:
        var result = _decodeList<CardBean>(list, Config.webDavEncryptLevel);
        if (result == null) {
          throw DecodeException();
        }

        recoverCard(context, result);
        break;
      case AllpassType.other:
        break;
    }
  }
}
