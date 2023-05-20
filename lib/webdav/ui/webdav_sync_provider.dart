import 'dart:io';

import 'package:allpass/core/di/di.dart';
import 'package:allpass/core/enums/allpass_type.dart';
import 'package:allpass/core/error/app_error.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/encrypt/encrypt_util.dart';
import 'package:allpass/encrypt/encryption.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/webdav/model/backup_file.dart';
import 'package:allpass/webdav/service/webdav_sync_service.dart';
import 'package:allpass/util/date_formatter.dart';
import 'package:allpass/webdav/error/sync_error.dart';
import 'package:allpass/webdav/model/webdav_file.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

sealed class SyncResult<T> {
  String? message;
}

class SyncSuccess<T extends Object> extends SyncResult<T> {
  final T result;
  @override
  final String? message;

  SyncSuccess(this.result, this.message);
}

class SyncFailed extends SyncResult<Never> {
  @override
  final String? message;

  SyncFailed(this.message);
}

class SyncPreDecryptFail extends SyncResult<Never> {
  @override
  late String? message;

  SyncPreDecryptFail(BuildContext context) {
    message = context.l10n.decryptBackupError;
  }

}

class SyncAuthFailed extends SyncResult<Never> {
  @override
  late String? message;

  SyncAuthFailed(BuildContext context) {
    message = context.l10n.syncAuthFailed;
  }
}

class Syncing extends SyncResult<Never> {
  @override
  late String? message;

  Syncing(BuildContext context) {
    message = context.l10n.syncing;
  }
}


sealed class GetBackupFileState {}

class GettingBackupFile extends GetBackupFileState {}

class GetBackupFileSuccess extends GetBackupFileState {
  final List<WebDavFile> backupFiles;

  GetBackupFileSuccess(this.backupFiles);
}

class GetBackupFileFail extends GetBackupFileState {
  final String message;

  GetBackupFileFail(this.message);
}

class WebDavSyncProvider extends ChangeNotifier {
  final Logger _logger = Logger();

  var _uploading = false;
  var _downloading = false;

  var _backupFiles = <WebDavFile>[];
  GetBackupFileState _getBackupFileState = GettingBackupFile();

  late final WebDavSyncService _syncService;

  WebDavSyncProvider({WebDavSyncService? syncService}) {
    _syncService = syncService ?? inject();
  }

  bool get uploading => _uploading;
  bool get downloading => _downloading;
  List<WebDavFile> get backupFiles => _backupFiles;
  GetBackupFileState get getBackupFileState => _getBackupFileState;

  String? uploadTime(BuildContext context) {
    if (Config.webDavUploadTime != null) {
      return context.l10n.lastUploadAt(Config.webDavUploadTime!);
    }
    return null;
  }

  String? downloadTime(BuildContext context) {
    if (Config.webDavDownloadTime != null) {
      return context.l10n.lastRecoverAt(Config.webDavDownloadTime!);
    }
    return null;
  }

  void refreshFiles(BuildContext context) async {
    _getBackupFileState = GettingBackupFile();
    notifyListeners();

    var l10n = context.l10n;
    try {
      if (!await _preAuthorizationCheck()) {
        _getBackupFileState = GetBackupFileFail(l10n.syncNeedReLogin);
        notifyListeners();
        return;
      }

      var files = await _syncService.getAllBackupFiles();
      _backupFiles.clear();
      _backupFiles.addAll(files);

      _getBackupFileState = GetBackupFileSuccess(files);
      notifyListeners();
    } on DioError catch (e) {
      _logger.e("refreshFiles DioError", e, e.stackTrace);

      if (e.response?.statusCode == 405) {
        _backupFiles.clear();
        _getBackupFileState = GetBackupFileFail(l10n.getBackupFileFailed);
      } else {
        _getBackupFileState = GetBackupFileFail(l10n.getBackupFileFailedCheckNetwork);
      }
      notifyListeners();
    }
  }

  Future<bool> _preAuthorizationCheck() async {
    return await _syncService.authCheck();
  }

  Future<SyncResult<Object>> syncToRemote(BuildContext context) async {
    if (_uploading) {
      return Syncing(context);
    }

    _uploading = true;
    notifyListeners();

    var l10n = context.l10n;
    try {
      if (!await _preAuthorizationCheck()) {
        return SyncAuthFailed(context);
      }

      await _syncService.backupFolderAndLabel(context);
      await _syncService.backupPassword(context);
      await _syncService.backupCard(context);
      Config.setWebDavUploadTime(DateFormatter.format(DateTime.now()));

      return SyncSuccess(Null, l10n.uploadSuccess);
    } on Exception catch (e, s) {
      _logger.e("syncToRemote Exception: ${e.runtimeType}", e, s);

      return switch (e) {
        DioError dioError when dioError.response?.statusCode == 405 =>
          SyncFailed(l10n.uploadFileFailedReject),
        DioError _ => SyncFailed(l10n.uploadFileFailedCheckNetwork),
        FileSystemException _ => SyncFailed(l10n.uploadFileNotExists),
        UnknownException u =>
          SyncFailed(l10n.uploadFileFailedUnknown(u.message)),
        _ => SyncFailed(l10n.uploadFileFailedOther(e.toString())),
      };
    } finally {
      _uploading = false;
      notifyListeners();
    }
  }


  Future<SyncResult<BackupFile>> downloadFile(
    BuildContext context,
    String filename,
  ) async {
    if (_downloading) {
      return Syncing(context);
    }

    _downloading = true;
    notifyListeners();

    var l10n = context.l10n;
    try {
      if (!await _preAuthorizationCheck()) {
        return SyncAuthFailed(context);
      }

      var backupFile = await _syncService.downloadFile(context, filename);
      return SyncSuccess(backupFile, l10n.downloadComplete);
    } on Exception catch (e, s) {
      _logger.e("downloadFile Exception: ${e.runtimeType}", e, s);

      return switch (e) {
        UnsupportedContentException _ => SyncFailed(l10n.unsupportedBackupFile),
        UnsupportedEnumException _ => SyncFailed(l10n.backupFileCorrupt),
        DioError dioError when dioError.response?.statusCode == 404 =>
          SyncFailed(l10n.backupFileNotFound),
        DioError _ => SyncFailed(l10n.networkError),
        FileSystemException _ => SyncFailed(l10n.downloadFileFailed),
        UnknownException _ => SyncFailed(l10n.downloadFailedUnknown(e.message)),
        _ => SyncFailed(l10n.downloadFailedOther(e.toString())),
      };
    } finally {
      _downloading = false;
      notifyListeners();
    }
  }

  Future<SyncResult<Object>> syncToLocalV2(
    BuildContext context,
    BackupFileV2 backupFile, {
    Encryption? encryption,
  }) async {
    if (_downloading) {
      return Syncing(context);
    }

    _downloading = true;
    notifyListeners();

    var l10n = context.l10n;
    try {
      var realDecryption = encryption ?? EncryptUtil.getEncryption();
      await _syncService.recoveryV2(context, backupFile, realDecryption);
      Config.setWebDavDownloadTime(DateFormatter.format(DateTime.now()));

      var name = switch (backupFile.metadata.type) {
        AllpassType.password => l10n.passwords,
        AllpassType.card => l10n.cards,
        AllpassType.other => l10n.folderLabel,
      };
      return SyncSuccess(Null, l10n.recoverySuccessMsg(name));
    } on PreDecryptException {
      return SyncPreDecryptFail(context);
    } on AssertionError catch (e) {
      _logger.e("syncToLocal AssertionError: ${e.message}", e);

      return SyncFailed(l10n.backupFileCorrupt);
    } on Exception catch (e, s) {
      _logger.e("syncToLocal Exception: ${e.runtimeType}", e, s);

      return switch (e) {
        DecodeException _ => SyncFailed(l10n.backupFileCorrupt),
        _ => SyncFailed(l10n.recoveryFailedMsg(e.toString())),
      };
    } finally {
      _downloading = false;
      notifyListeners();
    }
  }

  Future<SyncResult> syncToLocalV1(
    BuildContext context,
    BackupFileV1 backupFile, {
    Encryption? decryption,
  }) async {
    var l10n = context.l10n;
    try {
      var realEncryption = decryption ?? EncryptUtil.getEncryption();
      await _syncService.recoveryV1(context, backupFile, realEncryption);
      Config.setWebDavDownloadTime(DateFormatter.format(DateTime.now()));

      return SyncSuccess(Null, l10n.recoverySuccess);
    } on PreDecryptException {
      return SyncPreDecryptFail(context);
    } on AssertionError catch (e) {
      _logger.e("syncToLocalOld AssertionError: ${e.message}", e);

      return SyncFailed(l10n.backupFileCorrupt);
    } on Exception catch (e, s) {
      _logger.e("syncToLocalOld Exception: ${e.runtimeType}", e, s);

      return switch (e) {
        UnsupportedEnumException _ => SyncFailed(l10n.backupFileCorrupt),
        DecodeException _ => SyncFailed(l10n.backupFileCorrupt),
        PreDecryptException _ => SyncFailed(l10n.inputCustomSecretKeyHelp),
        _ => SyncFailed(l10n.recoveryFailedMsg(e.toString())),
      };
    } finally {
      _downloading = false;
      notifyListeners();
    }
  }

}
