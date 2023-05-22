import 'dart:convert';

import 'package:allpass/application.dart';
import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/core/enums/allpass_type.dart';
import 'package:allpass/core/model/data/base_model.dart';
import 'package:allpass/core/model/data/extra_model.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/encrypt/encryption.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/util/allpass_file_util.dart';
import 'package:allpass/util/date_formatter.dart';
import 'package:allpass/encrypt/encrypt_util.dart';
import 'package:allpass/util/version_util.dart';
import 'package:allpass/webdav/backup/webdav_backup_method.dart';
import 'package:allpass/webdav/encrypt/card_extension.dart';
import 'package:allpass/webdav/encrypt/encrypt_level.dart';
import 'package:allpass/webdav/encrypt/password_extension.dart';
import 'package:allpass/webdav/error/sync_error.dart';
import 'package:allpass/webdav/merge/merge_executors.dart';
import 'package:allpass/webdav/model/backup_file.dart';
import 'package:allpass/webdav/model/file_metadata.dart';
import 'package:allpass/webdav/model/webdav_file.dart';
import 'package:allpass/webdav/service/webdav_requester.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

abstract interface class WebDavSyncService {
  void updateConfig({
    String? urlPath,
    int? port,
    String? username,
    String? password,
  });

  void configPersistence();

  /// 权限检查
  Future<bool> authCheck();

  void cancelAuthCheck();

  /// 备份密码到指定的目录中
  Future<void> backupPassword(BuildContext context);

  /// 备份卡片到指定的目录中
  Future<void> backupCard(BuildContext context);

  /// 备份文件夹及标签
  Future<void> backupFolderAndLabel(BuildContext context);

  /// Throws
  /// [DioError] 下载失败
  /// [UnknownError] 下载异常
  /// [FileSystemException] 下载的文件不存在
  /// [UnsupportedEnumException] 解析枚举类型失败
  /// [UnsupportedContentException] 文件内容不是json类型
  Future<BackupFile> downloadFile(BuildContext context, String filename);

  /// Throws
  /// [PreDecryptException] 预解密失败
  /// [DecodeException] 反序列化文件内容失败
  /// [AssertionError] 反序列化文件内容时缺少字段
  Future<AllpassType> recoveryV2(
    BuildContext context,
    BackupFileV2 backupFile,
    Encryption decryption,
  );

  Future<void> recoveryV1(
    BuildContext context,
    BackupFileV1 backupFile,
    Encryption decryption,
  );

  Future<List<WebDavFile>> getAllBackupFiles();
}

class WebDavSyncServiceImpl implements WebDavSyncService {
  final String _tag = "WebDavSyncServiceImpl";
  final Logger _logger = Logger();

  String get remoteWorkspace => Config.webDavBackupDirectory;

  final String localWorkspace = "webdav_backup";

  WebDavRequester? _requesterImpl;

  WebDavRequester get _requester {
    if (_requesterImpl == null) {
      _requesterImpl = WebDavRequester(
        urlPath: Config.webDavUrl,
        username: Config.webDavUsername,
        password: Config.webDavPassword?.isNotEmpty == true
            ? EncryptUtil.decrypt(Config.webDavPassword!)
            : null,
      );
    }
    return _requesterImpl!;
  }

  @override
  void updateConfig({
    String? urlPath,
    int? port,
    String? username,
    String? password,
  }) {
    _requester.updateConfig(
      urlPath: urlPath,
      port: port,
      username: username,
      password: password,
    );
  }

  @override
  void configPersistence() {
    Config.setWebDavUrl(_requester.urlPath);
    Config.setWebDavUsername(_requester.username);
    Config.setWebDavPassword(EncryptUtil.encrypt(_requester.password));
  }

  @override
  Future<bool> authCheck() async => await _requester.authorityCheck();

  @override
  void cancelAuthCheck() {
    _requester.cancelConfirmAuth();
  }

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

    String contents = jsonEncode(await _createBackup(data, type));
    String fileName = _generateFilename(type);

    var filePath = await AllpassFileUtil.writeFile(localWorkspace, fileName, contents);

    String remoteFilename = _generateRemoteFilename(fileName, type);
    await _requester.uploadFile(
      fileName: remoteFilename,
      dirName: remoteWorkspace,
      localFilePath: filePath,
    );
    await AllpassFileUtil.deleteFile(filePath);
  }

  String _generateFilename(AllpassType type) {
    var now = DateFormatter.formatToFilename(DateTime.now());
    var isDebug = VersionUtil.isDebug();
    String suffix = "";
    if (isDebug) {
      suffix = "_debug";
    }
    return switch (type) {
      AllpassType.password => "${now}_allpass_password$suffix.json",
      AllpassType.card => "${now}_allpass_card$suffix.json",
      AllpassType.other => "${now}_allpass_extra$suffix.json",
    };
  }

  String _generateRemoteFilename(String filename, AllpassType type) {
    if (Config.webDavBackupMethod == WebDavBackupMethod.createNew) {
      return filename;
    } else {
      var name = Config.webDavBackupFilename?[type] ?? filename;
      if (name.endsWith(".json")) {
        return name;
      } else {
        return "$name.json";
      }
    }
  }

  BackupFileV2 _createBackup(List<BaseModel> list, AllpassType type) {
    var level = Config.webDavEncryptLevel;
    String data = switch (type) {
      AllpassType.password =>
        jsonEncode((list as List<PasswordBean>).encrypt(level)),
      AllpassType.card => jsonEncode((list as List<CardBean>).encrypt(level)),
      AllpassType.other => jsonEncode(ExtraModel(
          List.from(RuntimeData.folderList),
          List.from(RuntimeData.labelList),
        )),
    };

    return BackupFileV2(
      metadata: FileMetadata(
        type: type,
        encryptLevel: level,
        appVersion: AllpassApplication.version,
      ),
      data: data,
    );
  }

  @override
  Future<BackupFile> downloadFile(BuildContext context, String filename) async {
    String filePath = await _requester.downloadFile(
      fileName: filename,
      dirName: remoteWorkspace,
    );

    String string = AllpassFileUtil.readFile(filePath);
    var decodeResult = jsonDecode(string);
    if (decodeResult is List<dynamic>) {
      return BackupFileV1(decodeResult);
    } else if (!(decodeResult is Map<String, dynamic>)) {
      throw UnsupportedContentException();
    }

    return BackupFileV2.fromJson(decodeResult);
  }

  @override
  Future<AllpassType> recoveryV2(
    BuildContext context,
    BackupFileV2 backupFile,
    Encryption decryption,
  ) async {
    var type = backupFile.metadata.type;
    var level = backupFile.metadata.encryptLevel;
    var content = backupFile.data;
    switch (type) {
      case AllpassType.password:
        var list = _decodeList<PasswordBean>(jsonDecode(content), decryption, level);
        if (list == null) {
          throw DecodeException();
        }

        await recoverPassword(context, list);
        break;
      case AllpassType.card:
        var list = _decodeList<CardBean>(jsonDecode(content), decryption, level);
        if (list == null) {
          throw DecodeException();
        }

        await recoverCard(context, list);
        break;
      case AllpassType.other:
        var model = _decodeFolderAndLabel(content);
        if (model == null) {
          throw DecodeException();
        }

        await recoverFolderAndLabel(model);
        break;
    }
    return type;
  }

  List<T>? _decodeList<T extends BaseModel>(
    List<dynamic> list,
    Encryption decryption,
    EncryptLevel encryptLevel,
  ) {
    if (T == PasswordBean) {
      if (!_preDecrypt(list, decryption, encryptLevel)) {
        throw PreDecryptException();
      }

      List<PasswordBean> results = [];
      for (var temp in list) {
        var bean = PasswordBean.fromJson(temp);
        results.add(bean.decrypt(decryption, encryptLevel));
      }
      return results as List<T>;
    } else if (T == CardBean) {
      if (!_preDecrypt(list, decryption, encryptLevel)) {
        throw PreDecryptException();
      }

      List<CardBean> results = [];
      for (var temp in list) {
        var bean = CardBean.fromJson(temp);
        results.add(bean.decrypt(decryption, encryptLevel));
      }
      return results as List<T>;
    }
    return null;
  }

  bool _preDecrypt(
    List<dynamic> list,
    Encryption encryption,
    EncryptLevel encryptLevel,
  ) {
    if (list.isEmpty) {
      return true;
    }

    String password = list.first["password"];
    switch (encryptLevel) {
      case EncryptLevel.None:
        break;
      case EncryptLevel.OnlyPassword:
      case EncryptLevel.All:
        try {
          encryption.decrypt(password);
        } on ArgumentError {
          _logger.w("$_tag _preDecrypt error password=$password");
          return false;
        }
    }
    return true;
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
    } on FormatException catch (e) {
      _logger.e("$_tag _decodeFolderAndLabel error", e);
      return null;
    }
  }

  Future<int> recoverPassword(
    BuildContext context,
    List<PasswordBean> remoteList,
  ) async {
    var passwordProvider = context.read<PasswordProvider>();
    List<PasswordBean> localList = List.from(passwordProvider.passwordList);
    var mergeExecutor = Config.webDavMergeMethod.createExecutor<PasswordBean>();
    try {
      var result = mergeExecutor.merge(localList, remoteList);
      await result.apply(
        onAdd: (bean, source) async {
          _logger.d("$_tag recoverPassword insert dataSource=$source $bean");

          await passwordProvider.insertPassword(bean);
          RuntimeData.labelListAdd(bean.label);
          RuntimeData.folderListAdd(bean.folder);
        },
        onDelete: (bean, source) async {
          _logger.d("$_tag recoverPassword delete dataSource=$source $bean");

          await passwordProvider.deletePassword(bean);
        },
        onSkip: (bean, source) {
          _logger.d("$_tag recoverPassword skip   dataSource=$source $bean");
        },
      );
      return result.length;
    } catch (e2) {
      _logger.e("$_tag recoverPassword", e2);
      return -1;
    }
  }

  Future<int> recoverCard(
    BuildContext context,
    List<CardBean> remoteList,
  ) async {
    var cardProvider = context.read<CardProvider>();
    List<CardBean> localList = List.from(cardProvider.cardList);
    var mergeExecutor = Config.webDavMergeMethod.createExecutor<CardBean>();
    try {
      var result = mergeExecutor.merge(localList, remoteList);
      await result.apply(
        onAdd: (bean, source) async {
          _logger.d("$_tag recoverCard insert dataSource=$source $bean");

          await cardProvider.insertCard(bean);
          RuntimeData.labelListAdd(bean.label);
          RuntimeData.folderListAdd(bean.folder);
        },
        onDelete: (bean, source) async {
          _logger.d("$_tag recoverCard delete dataSource=$source $bean");

          await cardProvider.deleteCard(bean);
        },
        onSkip: (bean, source) {
          _logger.d("$_tag recoverCard skip   dataSource=$source $bean");
        },
      );
      return result.length;
    } catch (e2) {
      _logger.e("$_tag recoverCard", e2);
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
      _logger.e("$_tag recoverFolderAndLabel", e);
      return false;
    }
  }

  @override
  Future<List<WebDavFile>> getAllBackupFiles() async {
    await ensureRemoteWorkspace();
    
    return await _requester.listFiles(remoteWorkspace) ?? [];
  }

  Future<void> ensureRemoteWorkspace() async {
    if (!(await _requester.exists(remoteWorkspace))) {
      await _requester.createDir(remoteWorkspace);
    }
  }

  @override
  Future<void> recoveryV1(
    BuildContext context,
    BackupFileV1 backupFile,
    Encryption decryption,
  ) async {
    var encryptLevel = Config.webDavEncryptLevel;
    var data = backupFile.list;
    switch (backupFile.type) {
      case AllpassType.password:
        var result = _decodeList<PasswordBean>(data, decryption, encryptLevel);
        if (result == null) {
          throw DecodeException();
        }

        await recoverPassword(context, result);
        break;
      case AllpassType.card:
        var result = _decodeList<CardBean>(data, decryption, encryptLevel);
        if (result == null) {
          throw DecodeException();
        }

        await recoverCard(context, result);
        break;
      case AllpassType.other:
        break;
    }
  }
}
