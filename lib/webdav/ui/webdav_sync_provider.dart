import 'dart:io';

import 'package:allpass/application.dart';
import 'package:allpass/core/enums/allpass_type.dart';
import 'package:allpass/core/error/app_error.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/webdav/service/webdav_sync_service.dart';
import 'package:allpass/util/date_formatter.dart';
import 'package:allpass/webdav/error/sync_error.dart';
import 'package:allpass/webdav/model/webdav_file.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

abstract class SyncResult {
  String? message;
}

class SyncSuccess extends SyncResult {
  @override
  final String? message;

  SyncSuccess(this.message);
}

class SyncFailed extends SyncResult {
  @override
  final String? message;

  SyncFailed(this.message);
}

class SyncFallbackOld extends SyncResult {
  final List<dynamic> data;

  SyncFallbackOld(this.data);
}

class SyncAuthFailed extends SyncResult {
  @override
  final String? message = "账号权限失效，请检查网络或退出账号并重新配置";
}

class Syncing extends SyncResult {
  @override
  final String? message = "同步中，请稍后";
}


abstract class GetBackupFileState {}

class GettingBackupFile implements GetBackupFileState {}

class GetBackupFileSuccess implements GetBackupFileState {
  final List<WebDavFile> backupFiles;

  GetBackupFileSuccess(this.backupFiles);
}

class GetBackupFileFail implements GetBackupFileState {
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
    _syncService = syncService ?? AllpassApplication.getIt.get();
  }

  bool get uploading => _uploading;
  bool get downloading => _downloading;
  List<WebDavFile> get backupFiles => _backupFiles;
  GetBackupFileState get getBackupFileState => _getBackupFileState;

  void refreshFiles() async {
    _getBackupFileState = GettingBackupFile();
    notifyListeners();

    try {
      if (!await _preAuthorizationCheck()) {
        _getBackupFileState = GetBackupFileFail("账号权限失效，请重新登录");
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
        _getBackupFileState = GetBackupFileFail("获取文件列表失败，请尝试将备份目录改为子文件夹后重试");
      } else {
        _getBackupFileState = GetBackupFileFail("获取文件列表失败，请检查网络");
      }
      notifyListeners();
    }
  }

  Future<bool> _preAuthorizationCheck() async {
    return await _syncService.authCheck();
  }

  Future<SyncResult> syncToRemote(BuildContext context) async {
    if (_uploading) {
      return Syncing();
    }

    _uploading = true;
    notifyListeners();

    try {
      if (!await _preAuthorizationCheck()) {
        _uploading = false;
        notifyListeners();

        return SyncAuthFailed();
      }

      await _syncService.backupFolderAndLabel(context);
      await _syncService.backupPassword(context);
      await _syncService.backupCard(context);
      Config.setWebDavUploadTime(DateFormatter.format(DateTime.now()));
      _uploading = false;
      notifyListeners();

      return SyncSuccess("上传成功");
    } on Exception catch (e, s) {
      _logger.e("syncToRemote Exception: ${e.runtimeType}", e, s);

      _uploading = false;
      notifyListeners();

      if (e is DioError) {
        if (e.response?.statusCode == 405) {
          return SyncFailed("上传失败，请尝试将备份目录改为子文件夹后重试");
        }
        return SyncFailed("上传失败，请检查网络");
      } else if (e is FileSystemException){
        return SyncFailed(e.message);
      } else if (e is UnknownException) {
        return SyncFailed("上传失败，错误信息 ${e.message}");
      } else {
        return SyncFailed("上传失败，${e.toString()}");
      }
    }
  }

  Future<SyncResult> syncToLocal(BuildContext context, String filename) async {
    if (_downloading) {
      return Syncing();
    }

    _downloading = true;
    notifyListeners();

    try {
      if (!await _preAuthorizationCheck()) {
        _downloading = false;
        notifyListeners();

        return SyncAuthFailed();
      }

      var type = await _syncService.recovery(context, filename);
      Config.setWebDavDownloadTime(DateFormatter.format(DateTime.now()));

      _downloading = false;
      notifyListeners();

      var name;
      switch (type) {
        case AllpassType.password:
          name = "密码";
          break;
        case AllpassType.card:
          name = "卡片";
          break;
        case AllpassType.other:
          name = "文件夹及标签";
          break;
      }
      return SyncSuccess("恢复$name成功");
    } on FallbackOldException catch (e) {
      _downloading = false;
      notifyListeners();

      return SyncFallbackOld(e.data);
    } on AssertionError catch (e) {
      _logger.e("syncToLocal AssertionError: ${e.message}", e);

      _downloading = false;
      notifyListeners();

      return SyncFailed("备份文件数据损坏");
    } on Exception catch (e, s) {
      _logger.e("syncToLocal Exception: ${e.runtimeType}", e, s);

      _downloading = false;
      notifyListeners();

      if (e is UnsupportedContentException) {
        return SyncFailed("不支持的备份文件");
      } else if (e is UnsupportedArgumentException || e is DecodeException) {
        return SyncFailed("备份文件数据损坏");
      } else if (e is DioError) {
        if (e.response?.statusCode == 404) {
          return SyncFailed("备份文件已被删除，请再次打开对话框刷新后重试");
        }

        return SyncFailed("网络错误，请稍后重试");
      } else if (e is UnknownException) {
        return SyncFailed("恢复失败，错误信息 ${e.message}");
      } else {
        return SyncFailed("恢复失败 ${e.toString()}");
      }
    }
  }

  Future<SyncResult> syncToLocalOld(BuildContext context, List<dynamic> data, AllpassType type) async {
    try {
      await _syncService.recoveryOld(context, data, type);
      Config.setWebDavDownloadTime(DateFormatter.format(DateTime.now()));
      return SyncSuccess("恢复成功");
    } on AssertionError catch (e) {
      _logger.e("syncToLocalOld AssertionError: ${e.message}", e);

      _downloading = false;
      notifyListeners();

      return SyncFailed("备份文件数据损坏");
    } on Exception catch (e, s) {
      _logger.e("syncToLocalOld Exception: ${e.runtimeType}", e, s);

      _downloading = false;
      notifyListeners();

      if (e is UnsupportedArgumentException || e is DecodeException) {
        return SyncFailed("备份文件数据损坏");
      } else {
        return SyncFailed("恢复失败 ${e.toString()}");
      }
    }
  }

}
