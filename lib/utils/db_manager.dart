import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBManager {
  /// 数据库版本
  static const int _dbVersion = 2;

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
    _database = await openDatabase(path, version: _dbVersion);
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

}