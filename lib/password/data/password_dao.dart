import 'package:allpass/autofill/autofill_save_request.dart';
import 'package:sqflite/sqflite.dart';

import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/core/dao/db_provider.dart';
import 'package:allpass/util/string_util.dart';

class PasswordDao extends BaseDBProvider {

  /// 表名
  static final String name = "allpass_password";

  /// 表主键字段
  static final String columnId = "uniqueKey";

  /// 版本1列名
  static final String columnName = "name";
  static final String columnUsername = "username";
  static final String columnPassword = "password";
  static final String columnUrl = "url";
  static final String columnFolder = "folder";
  static final String columnNotes = "notes";
  static final String columnLabel = "label";
  static final String columnFav = "fav";
  /// 版本2列名
  static final String columnCreateTime = "createTime";
  /// 版本3列名
  static final String columnSortNumber = "sortNumber";
  /// 版本4列名
  static final String columnAppId = "appId";
  /// 版本5列名
  static final String columnAppName = "appName";

  @override
  String tableName() {
    return name;
  }

  /// 删除表
  Future<Null> deleteTable() async {
    Database db = await getDataBase();
    await db.rawDelete("DROP TABLE $name");
  }

  /// 删除表中所有内容
  Future<int> deleteContent() async {
    Database db = await getDataBase();
    var count = await db.delete(name);
    // 清除表的Key自增值
    await db.delete("sqlite_sequence", where: "name=?", whereArgs: [name]);
    return count;
  }

  /// 创建表的sql
  @override
  String tableSqlString() {
    return tableBaseString(name, columnId) +
      '''
      $columnName TEXT NOT NULL,
      $columnUsername TEXT NOT NULL,
      $columnPassword TEXT NOT NULL,
      $columnUrl TEXT NOT NULL,
      $columnFolder TEXT DEFAULT '默认',
      $columnNotes TEXT,
      $columnLabel TEXT,
      $columnFav INTEGER DEFAULT 0,
      $columnCreateTime TEXT,
      $columnSortNumber INTEGER DEFAULT -1,
      $columnAppId TEXT,
      $columnAppName TEXT)
      ''';
  }

  /// 插入密码
  Future<int> insert(PasswordBean bean) async {
    Database db = await getDataBase();
    Map<String, dynamic> map = bean.toJson();
    return await db.insert(name, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateUserData(AutofillSaveRequest request) async {
    Database db = await getDataBase();
    return await db.rawUpdate("UPDATE $name SET "
        "$columnName=?,"
        "$columnPassword=?,"
        "$columnAppName=? WHERE $columnUsername=${request.username} AND $columnAppId=${request.appId}",
        [request.name, request.password, request.appName]);
  }

  /// 根据uniqueKey查询记录
  Future<PasswordBean?> findById(String id) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.query(
      name,
      where: "$columnId=?",
      whereArgs: [id],
    );
    if (maps.length > 0) {
      return PasswordBean.fromJson(maps.first);
    }
    return null;
  }

  /// 获取所有的密码List
  Future<List<PasswordBean>> findAll() async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> list = await db.query(name);
    if (list.length > 0) {
      List<PasswordBean> res = [];
      for (var map in list) {
        PasswordBean bean = PasswordBean.fromJson(map);
        res.add(bean);
      }
      return res;
    }
    return [];
  }

  Future<List<PasswordBean>> findByAppIdAndUsername(String appId, String username) async {
    if (appId.length == 0) {
      return [];
    }
    Database db = await getDataBase();
    List<Map<String, dynamic>> list = await db.query(name,
        where: "$columnAppId=? AND $columnUsername=?",
        whereArgs: [appId, username]
    );
    return list
        .map((e) => PasswordBean.fromJson(e))
        .toList();
  }

  Future<List<PasswordBean>> findByAppIdOrAppName(String appId, String? appName,
      {int page = 0,
      int pageSize = 10,}) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> list;
    if (appName == null) {
      list = await db.query(name,
        where: "$columnAppId LIKE ?",
        whereArgs: ["%$appId%"],
        offset: page * pageSize,
        limit: pageSize
      );
    } else {
      list = await db.query(
        name,
        where: "$columnAppId LIKE ? OR $columnAppName=? OR $columnName LIKE ?",
        whereArgs: ["%$appId%", appName, "%$appName%"],
      );
    }
    return list
        .map((e) => PasswordBean.fromJson(e))
        .toList(growable: false);
  }

  /// 删除指定uniqueKey的密码
  Future<int> deleteById(int key) async {
    Database db = await getDataBase();
    return await db.delete(name, where: '$columnId = ?', whereArgs: [key]);
  }

  /// 更新
  Future<int> updateById(PasswordBean bean) async {
    Database db = await getDataBase();
    String labels = StringUtil.list2WaveLineSegStr(bean.label);
    return await db.rawUpdate("UPDATE $name SET "
        "$columnName=?,"
        "$columnUsername=?,"
        "$columnPassword=?,"
        "$columnUrl=?,"
        "$columnFolder=?,"
        "$columnFav=?,"
        "$columnNotes=?,"
        "$columnLabel=?,"
        "$columnSortNumber=?,"
        "$columnAppId=?,"
        "$columnAppName=? WHERE $columnId=${bean.uniqueKey}",
        [bean.name, bean.username, bean.password, bean.url, bean.folder, bean.fav, bean.notes, labels, bean.sortNumber, bean.appId, bean.appName]);
    // 下面的语句更新时提示UNIQUE constraint failed
    // return await db.update(name, passwordBean2Map(bean));
  }
}