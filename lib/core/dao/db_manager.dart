import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBManager {
  /// 数据库版本
  static const int _dbVersion = 3;

  /// 数据库名称
  static const String _dbName = "allpass_db";

  /// 数据库实例
  static Database _database;

  static init() async {
    var dbPath = await getDatabasesPath();
    String dbName = _dbName;
    String path = dbPath + dbName;
    if (Platform.isIOS) {
      path = dbName + "/" + dbName;
    }
    // 打开数据库
    _database = await openDatabase(path, version: _dbVersion, onUpgrade: onUpdate);
  }

  /// 判断表是否存在
  static isTableExists(String tableName) async {
    await getCurrentDatabase();
    String sql = "SELECT * FROM Sqlite_master WHERE type = 'table' AND name = '$tableName'";
    var res = await _database.rawQuery(sql);
    return res != null && res.length > 0;
  }

  /// 获取当前数据库实例
  static Future<Database> getCurrentDatabase() async {
    if (_database == null) {
      await init();
    }
    return _database;
  }

  /// 关闭数据库
  static close() {
    _database?.close();
    _database = null;
  }

  /// 数据库版本升级
  static void onUpdate(Database database, int oldVersion, int newVersion) {
    if (oldVersion < 1 || oldVersion >= newVersion) return;
    List<Function> upgradeFunctions = [_upgrade1To2, _upgrade2To3];
    int startIndex = oldVersion - 1;
    int endIndex = newVersion - 1;
    for (int index = startIndex; index < endIndex; index++) {
      upgradeFunctions[index].call(database);
    }
  }

  static void _upgrade1To2(Database database) {
    debugPrint("数据库升级： 1 -> 2");
    String renamePasswordSql = "ALTER TABLE allpass_password RENAME TO allpass_password1";
    database.execute(renamePasswordSql);
    String createPasswordSql = '''
        CREATE TABLE allpass_password(
        uniqueKey INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        url TEXT NOT NULL,
        folder TEXT DEFAULT '默认',
        notes TEXT,
        label TEXT,
        fav INTEGER DEFAULT 0,
        createTime TEXT)
      ''';
    database.execute(createPasswordSql);
    String movePasswordSql = "INSERT INTO allpass_password(uniqueKey,name,username,password,url,folder,notes,label,fav) "
        "SELECT uniqueKey,name,username,password,url,folder,notes,label,fav from allpass_password1";
    database.execute(movePasswordSql);
    String dropPasswordSql = "DROP TABLE allpass_password1";
    database.execute(dropPasswordSql);
    String updatePasswordSql = "UPDATE allpass_password SET createTime=?";
    database.execute(updatePasswordSql, [DateTime.now().toIso8601String()]);

    String renameCardSql = "ALTER TABLE allpass_card RENAME TO allpass_card1";
    database.execute(renameCardSql);
    String createCardSql = '''
        CREATE TABLE allpass_card(
        uniqueKey INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        ownerName TEXT,
        cardId TEXT NOT NULL,
        password TEXT,
        telephone TEXT,
        folder TEXT DEFAULT '默认',
        notes TEXT,
        label TEXT,
        fav INTEGER DEFAULT 0,
        createTime TEXT)
      ''';
    database.execute(createCardSql);
    String moveCardSql = "INSERT INTO allpass_card(uniqueKey,name,ownerName,cardId,password,telephone,folder,notes,label,fav)"
        " SELECT uniqueKey,name,ownerName,cardId,password,telephone,folder,notes,label,fav from allpass_card1";
    database.execute(moveCardSql);
    String dropCardSql = "DROP TABLE allpass_card1";
    database.execute(dropCardSql);
    String updateCardSql = "UPDATE allpass_card SET createTime=?";
    database.execute(updateCardSql, [DateTime.now().toIso8601String()]);

    debugPrint("数据库升级完成");
  }

  static void _upgrade2To3(Database database) {
    debugPrint("数据库升级： 2 -> 3");
    String addPasswordColumnSql = "ALTER TABLE allpass_password ADD COLUMN sortNumber INTEGER DEFAULT -1";
    database.execute(addPasswordColumnSql);
    String addCardColumnSql = "ALTER TABLE allpass_card ADD COLUMN sortNumber INTEGER DEFAULT -1";
    database.execute(addCardColumnSql);
    debugPrint("数据库升级完成");
  }
}