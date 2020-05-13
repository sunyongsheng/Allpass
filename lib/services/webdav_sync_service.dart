import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import 'package:allpass/params/config.dart';
import 'package:allpass/params/runtime_data.dart';
import 'package:allpass/model/password_bean.dart';
import 'package:allpass/model/card_bean.dart';
import 'package:allpass/provider/password_list.dart';
import 'package:allpass/provider/card_list.dart';
import 'package:allpass/utils/allpass_file_util.dart';
import 'package:allpass/utils/encrypt_util.dart';
import 'package:allpass/utils/webdav_util.dart';

class WebDavSyncService {
  WebDavUtil _webDavUtil;
  AllpassFileUtil _fileUtil;

  WebDavSyncService() {
    _webDavUtil = WebDavUtil(
      urlPath: Config.webDavUrl,
      username: Config.webDavUsername,
      password: EncryptUtil.decrypt(Config.webDavPassword),
      port: Config.webDavPort,
    );
    _fileUtil = AllpassFileUtil();
  }

  Future<bool> authCheck() async {
    return await _webDavUtil.authConfirm();
  }

  /// 备份密码到指定的目录中
  Future<bool> backupPassword(BuildContext context) async {
    List<PasswordBean> passwords = Provider.of<PasswordList>(context).passwordList;
    String contents = _fileUtil.encodeList(passwords);

    Directory appDir = await getApplicationDocumentsDirectory();
    String backupFilePath = appDir.uri.toFilePath() + "allpass_password.appt";
    File backupFile = File(backupFilePath);
    if (!backupFile.existsSync()) backupFile.createSync();

    _fileUtil.writeFile(backupFilePath, contents);

    return await _webDavUtil.uploadFile(
        fileName: "allpass_password.appt",
        dirName: "Allpass",
        filePath: backupFilePath);
  }

  /// 备份卡片到指定的目录中
  Future<bool> backupCard(BuildContext context) async {
    List<CardBean> cards = Provider.of<CardList>(context).cardList;
    String contents = _fileUtil.encodeList(cards);

    Directory appDir = await getApplicationDocumentsDirectory();
    String backupFilePath = appDir.uri.toFilePath() + "allpass_card.appt";
    File backupFile = File(backupFilePath);
    if (!backupFile.existsSync()) backupFile.createSync();

    _fileUtil.writeFile(backupFilePath, contents);

    return await _webDavUtil.uploadFile(
        fileName: "allpass_card.appt",
        dirName: "Allpass",
        filePath: backupFilePath);
  }

  /// 恢复密码到本地
  /// ！！！恢复密码时将会清除本地所有数据
  /// 0: 正常执行完毕
  /// 1: 插入云端数据时出错
  /// 2: 解析json出错，可能是网络原因
  Future<int> recoverPassword(BuildContext context) async {
    String filePath = await _webDavUtil.downloadFile(
        fileName: "allpass_password.appt",
        dirName: "Allpass");
    List<PasswordBean> backup = Provider.of<PasswordList>(context).passwordList;
    try {
      String string = _fileUtil.readFile(filePath);
      List<PasswordBean> list = _fileUtil.decodeList(string);
      try {
        // 正常执行
        await Provider.of<PasswordList>(context).clear();
        for (var bean in list) {
          await Provider.of<PasswordList>(context).insertPassword(bean);
          RuntimeData.labelListAdd(bean.label);
          RuntimeData.folderListAdd(bean.folder);
        }
        return 0;
      } catch (e1) {
        // 插入云端数据出错，恢复数据
        for (var bean in backup) {
          await Provider.of<PasswordList>(context).insertPassword(bean);
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

  /// 恢复卡片到本地
  /// ！！！恢复卡片时将会清除本地所有数据
  /// 0: 正常执行完毕
  /// 1: 插入云端数据时出错
  /// 2: 解析json出错，可能是网络原因
  Future<int> recoverCard(BuildContext context) async {
    String filePath = await _webDavUtil.downloadFile(
        fileName: "allpass_card.appt",
        dirName: "Allpass");
    List<CardBean> backup = Provider.of<CardList>(context).cardList;
    try {
      String string = _fileUtil.readFile(filePath);
      List<CardBean> list = _fileUtil.decodeList(string);
      try {
        // 正常执行
        await Provider.of<CardList>(context).clear();
        for (var bean in list) {
          await Provider.of<CardList>(context).insertCard(bean);
          RuntimeData.labelListAdd(bean.label);
          RuntimeData.folderListAdd(bean.folder);
        }
        return 0;
      } catch (e1) {
        // 插入云端数据出错，恢复数据
        for (var bean in backup) {
          await Provider.of<CardList>(context).insertCard(bean);
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
}