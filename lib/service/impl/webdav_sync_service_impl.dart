import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:allpass/application.dart';
import 'package:allpass/param/config.dart';
import 'package:allpass/param/allpass_type.dart';
import 'package:allpass/param/runtime_data.dart';
import 'package:allpass/model/data/password_bean.dart';
import 'package:allpass/model/data/card_bean.dart';
import 'package:allpass/provider/password_provider.dart';
import 'package:allpass/provider/card_provider.dart';
import 'package:allpass/util/allpass_file_util.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/util/webdav_util.dart';
import 'package:allpass/util/version_util.dart';
import 'package:allpass/service/webdav_sync_service.dart';


class WebDavSyncServiceImpl implements WebDavSyncService{

  WebDavUtil _webDavUtilHolder;
  AllpassFileUtil _fileUtilHolder;

  @override
  Future<bool> authCheck() async {
    return await _webDavUtil().authConfirm();
  }

  @override
  Future<bool> backupPassword(BuildContext context) async {
    List<PasswordBean> passwords = Provider.of<PasswordProvider>(context).passwordList;
    String contents = _fileUtil().encodeList(passwords);

    Directory appDir = await getApplicationDocumentsDirectory();
    String fileName = "${Config.webDavPasswordName}.json";
    String backupFilePath = appDir.uri.toFilePath() + fileName;
    File backupFile = File(backupFilePath);
    if (!backupFile.existsSync()) backupFile.createSync();

    _fileUtil().writeFile(backupFilePath, contents);

    bool res = await _webDavUtil().uploadFile(
        fileName: fileName,
        dirName: "Allpass",
        filePath: backupFilePath);
    _fileUtil().deleteFile(backupFilePath);
    return res;
  }

  @override
  Future<bool> backupCard(BuildContext context) async {
    List<CardBean> cards = Provider.of<CardProvider>(context).cardList;
    String contents = _fileUtil().encodeList(cards);

    Directory appDir = await getApplicationDocumentsDirectory();
    String fileName = "${Config.webDavCardName}.json";
    String backupFilePath = appDir.uri.toFilePath() + fileName;
    File backupFile = File(backupFilePath);
    if (!backupFile.existsSync()) backupFile.createSync();

    _fileUtil().writeFile(backupFilePath, contents);

    bool res = await _webDavUtil().uploadFile(
        fileName: fileName,
        dirName: "Allpass",
        filePath: backupFilePath);
    _fileUtil().deleteFile(backupFilePath);
    return res;
  }

  @override
  Future<bool> backupFolderAndLabel(BuildContext context) async {
    List<String> folder = List.from(RuntimeData.folderList);
    List<String> label = List.from(RuntimeData.labelList);
    String contents = _fileUtil().encodeFolderAndLabel(folder, label);

    Directory appDir = await getApplicationDocumentsDirectory();
    String backupFilePath = appDir.uri.toFilePath() + "folder_label_info.json";
    File backupFile = File(backupFilePath);
    if (!backupFile.existsSync()) backupFile.createSync();

    _fileUtil().writeFile(backupFilePath, contents);

    bool res = await _webDavUtil().uploadFile(
      fileName: "folder_label_info.json",
      dirName: "Allpass",
      filePath: backupFilePath
    );
    _fileUtil().deleteFile(backupFilePath);
    return res;
  }

  @override
  Future<int> recoverPassword(BuildContext context) async {
    String fileName = "${Config.webDavPasswordName}.json";
    String filePath = await _webDavUtil().downloadFile(
        fileName: fileName,
        dirName: "Allpass");
    if (filePath == null) {
      return -1;
    }
    List<PasswordBean> backup = List()..addAll(Provider.of<PasswordProvider>(context).passwordList);
    try {
      String string = _fileUtil().readFile(filePath);
      List<PasswordBean> list = _fileUtil().decodeList(string, AllpassType.Password);
      try {
        // 正常执行
        await Provider.of<PasswordProvider>(context).clear();
        for (var bean in list) {
          await Provider.of<PasswordProvider>(context).insertPassword(bean);
          if (VersionUtil.twoIsNewerVersion("1.2.0", Application.version)) continue;
          RuntimeData.labelListAdd(bean.label);
          RuntimeData.folderListAdd(bean.folder);
        }
        return 0;
      } catch (e1) {
        // 插入云端数据出错，恢复数据
        for (var bean in backup) {
          await Provider.of<PasswordProvider>(context).insertPassword(bean);
          if (VersionUtil.twoIsNewerVersion("1.2.0", Application.version)) continue;
          RuntimeData.labelListAdd(bean.label);
          RuntimeData.folderListAdd(bean.folder);
        }
        return 1;
      }
    } catch (e2) {
      // 解析json出错
      print(e2);
      return 2;
    }
  }

  @override
  Future<int> recoverCard(BuildContext context) async {
    String fileName = "${Config.webDavCardName}.json";
    String filePath = await _webDavUtil().downloadFile(
        fileName: fileName,
        dirName: "Allpass");
    if (filePath == null) {
      return -1;
    }
    List<CardBean> backup = List()..addAll(Provider.of<CardProvider>(context).cardList);
    try {
      String string = _fileUtil().readFile(filePath);
      List<CardBean> list = _fileUtil().decodeList(string, AllpassType.Card);
      try {
        // 正常执行
        await Provider.of<CardProvider>(context).clear();
        for (var bean in list) {
          await Provider.of<CardProvider>(context).insertCard(bean);
          if (VersionUtil.twoIsNewerVersion("1.2.0", Application.version)) continue;
          RuntimeData.labelListAdd(bean.label);
          RuntimeData.folderListAdd(bean.folder);
        }
        return 0;
      } catch (e1) {
        // 插入云端数据出错，恢复数据
        for (var bean in backup) {
          await Provider.of<CardProvider>(context).insertCard(bean);
          if (VersionUtil.twoIsNewerVersion("1.2.0", Application.version)) continue;
          RuntimeData.labelListAdd(bean.label);
          RuntimeData.folderListAdd(bean.folder);
        }
        return 1;
      }
    } catch (e2) {
      // 解析json出错
      print(e2);
      return 2;
    }
  }

  @override
  Future<bool> recoverFolderAndLabel() async {
    try {
      String filePath = await _webDavUtil().downloadFile(
          fileName: "folder_label_info.json",
          dirName: "Allpass");
      String contents = _fileUtil().readFile(filePath);
      Map<String, List<String>> res = _fileUtil().decodeFolderAndLabel(contents);
      RuntimeData.folderList.clear();
      RuntimeData.folderList.addAll(res['folder']);
      RuntimeData.labelList.clear();
      RuntimeData.labelList.addAll(res['label']);
      RuntimeData.folderParamsPersistence();
      RuntimeData.labelParamsPersistence();
      return true;
    } catch (e) {
      return false;
    }
  }

  WebDavUtil _webDavUtil() {
    if (_webDavUtilHolder == null) {
      _webDavUtilHolder = WebDavUtil(
        urlPath: Config.webDavUrl,
        username: Config.webDavUsername,
        password: EncryptUtil.decrypt(Config.webDavPassword),
        port: Config.webDavPort,
      );
    }
    return _webDavUtilHolder;
  }

  AllpassFileUtil _fileUtil() {
    if (_fileUtilHolder == null) {
      _fileUtilHolder = AllpassFileUtil();
    }
    return _fileUtilHolder;
  }
}