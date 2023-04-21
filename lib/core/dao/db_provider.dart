import 'package:allpass/core/dao/table_definition.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allpass/core/dao/db_manager.dart';

/// 这个类定义创建数据库表的基础方法；
/// 这个类是一个抽象类，把具体创建数据库表的sql暴露出去，让子类去具体实现；
/// 由它直接和DBManager打交道，业务层实现这个接口即可
abstract class BaseDBProvider {
  bool _isTableExists = false;

  String tableName();

  List<ColumnDefinition> tableColumns();

  Future<Database> getDatabase() async {
    return await _open();
  }

  Future<void> _prepare(name) async {
    _isTableExists = await DBManager.isTableExists(name);
    if (!_isTableExists) {
      final Database db = await DBManager.getCurrentDatabase();
      final statement = CreateTableStatement(name, tableColumns());
      return await db.execute(statement.create());
    }
  }

  Future<Database> _open() async {
    if (!_isTableExists) {
      await _prepare(tableName());
    }
    return await DBManager.getCurrentDatabase();
  }
}
