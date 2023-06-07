import 'dart:async';

import 'package:allpass/card/data/card_table.dart';
import 'package:allpass/core/dao/old_db_migration.dart';
import 'package:allpass/password/data/password_table.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBManager {

  static Logger _logger = Logger();

  static const String TAG = "DBManager";

  /// 数据库版本
  static const int _dbVersion = 5;

  /// 数据库名称
  static const String _dbName = "allpass_db";

  /// 数据库实例
  static Database? _database;

  static init() async {
    var dbPath = await getDatabasesPath();
    String dbName = _dbName;
    var path = join(dbPath, dbName);
    var migration = OldDatabaseMigration();
    if (await migration.needMigration()) {
      path = await migration.migrate(path);
    }
    // 打开数据库
    _database = await openDatabase(path, version: _dbVersion, onUpgrade: onUpdate);
  }

  /// 判断表是否存在
  static isTableExists(String tableName) async {
    await getCurrentDatabase();
    String sql = "SELECT * FROM Sqlite_master WHERE type = 'table' AND name = '$tableName'";
    var res = await _database?.rawQuery(sql) ?? [];
    return res.length > 0;
  }

  /// 获取当前数据库实例
  static Future<Database> getCurrentDatabase() async {
    if (_database == null) {
      await init();
    }
    return _database!;
  }

  /// 关闭数据库
  static close() {
    _database?.close();
    _database = null;
  }

  /// 数据库版本升级
  static FutureOr<void> onUpdate(Database database, int oldVersion, int newVersion) async {
    if (oldVersion < 1 || oldVersion >= newVersion) return;

    List<Function> upgradeFunctions = [_upgrade1To2, _upgrade2To3, _upgrade3To4, _upgrade4To5];
    int startIndex = oldVersion - 1;
    int endIndex = newVersion - 1;
    for (int index = startIndex; index < endIndex; index++) {
      await upgradeFunctions[index].call(database);
    }
  }

  static Future<void> _upgrade1To2(Database database) async {
    _logger.i("数据库升级： 1 -> 2");
    String renamePasswordSql = "ALTER TABLE ${PasswordTable.name} RENAME TO allpass_password1";
    String createPasswordSql = '''
        CREATE TABLE ${PasswordTable.name}(
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
    String movePasswordSql = "INSERT INTO ${PasswordTable.name}(uniqueKey,name,username,password,url,folder,notes,label,fav) "
        "SELECT uniqueKey,name,username,password,url,folder,notes,label,fav from allpass_password1";
    String dropPasswordSql = "DROP TABLE allpass_password1";
    String updatePasswordSql = "UPDATE ${PasswordTable.name} SET createTime=?";

    String renameCardSql = "ALTER TABLE ${CardTable.name} RENAME TO allpass_card1";
    String createCardSql = '''
        CREATE TABLE ${CardTable.name}(
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
    String moveCardSql = "INSERT INTO ${CardTable.name}(uniqueKey,name,ownerName,cardId,password,telephone,folder,notes,label,fav)"
        " SELECT uniqueKey,name,ownerName,cardId,password,telephone,folder,notes,label,fav from allpass_card1";
    String dropCardSql = "DROP TABLE allpass_card1";
    String updateCardSql = "UPDATE ${CardTable.name} SET createTime=?";

    await database.transaction((txn) async {
      await txn.execute(renamePasswordSql);
      await txn.execute(createPasswordSql);
      await txn.execute(movePasswordSql);
      await txn.execute(dropPasswordSql);
      await txn.execute(updatePasswordSql, [DateTime.now().toIso8601String()]);
      await txn.execute(renameCardSql);
      await txn.execute(createCardSql);
      await txn.execute(moveCardSql);
      await txn.execute(dropCardSql);
      await txn.execute(updateCardSql, [DateTime.now().toIso8601String()]);
    });

    _logger.i("数据库升级完成");
  }

  static Future<void> _upgrade2To3(Database database) async {
    _logger.i("数据库升级： 2 -> 3");
    String addPasswordColumnSql = "ALTER TABLE ${PasswordTable.name} ADD COLUMN ${PasswordTable.columnSortNumber} INTEGER DEFAULT -1";
    String addCardColumnSql = "ALTER TABLE ${CardTable.name} ADD COLUMN ${CardTable.columnSortNumber} INTEGER DEFAULT -1";
    await database.transaction((txn) async {
      await txn.execute(addPasswordColumnSql);
      await txn.execute(addCardColumnSql);
    });
    _logger.i("数据库升级完成");
  }

  static Future<void> _upgrade3To4(Database database) async {
    _logger.i("数据库升级： 3 -> 4");
    String addPasswordColumnSql = "ALTER TABLE ${PasswordTable.name} ADD COLUMN ${PasswordTable.columnAppId} TEXT DEFAULT ''";
    await database.execute(addPasswordColumnSql);
    _logger.i("数据库升级完成");
  }

  static Future<void> _upgrade4To5(Database database) async {
    _logger.i("数据库升级： 4 -> 5");
    String addPasswordColumnSql = "ALTER TABLE ${PasswordTable.name} ADD COLUMN ${PasswordTable.columnAppName} TEXT DEFAULT ''";
    await database.execute(addPasswordColumnSql);
    _logger.i("数据库升级完成");
  }
}