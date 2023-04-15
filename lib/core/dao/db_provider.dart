import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allpass/core/dao/db_manager.dart';


/// 这个类定义创建数据库表的基础方法；
/// 这个类是一个抽象类，把具体创建数据库表的sql暴露出去，让子类去具体实现；
/// 由它直接和DBManager打交道，业务层实现这个接口即可
abstract class BaseDBProvider {
  bool _isTableExists = false;

  String tableSqlString();

  String tableName();

  String tableBaseString(String name, String columnId) {
    return '''
      CREATE TABLE $name (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    ''';
  }

  Future<Database> getDataBase() async {
    return await open();
  }

  @mustCallSuper
  Future<void> prepare(name, String createSql) async {
    _isTableExists = await DBManager.isTableExists(name);
    if (!_isTableExists) {
      Database db = await DBManager.getCurrentDatabase();
      return await db.execute(createSql);
    }
  }

  @mustCallSuper
  Future<Database> open() async {
    if (!_isTableExists) {
      await prepare(tableName(), tableSqlString());
    }
    return await DBManager.getCurrentDatabase();
  }
}