import 'package:allpass/autofill/autofill_save_request.dart';
import 'package:allpass/core/dao/db_provider.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/password/repository/password_data_source.dart';
import 'package:allpass/password/repository/password_table.dart';
import 'package:allpass/util/string_util.dart';
import 'package:sqflite/sqflite.dart';

class PasswordLocalDataSource extends BaseDBProvider
    with PasswordTable
    implements PasswordDataSource {
  /// 删除表
  @override
  Future<Null> deleteTable() async {
    Database db = await getDatabase();
    await db.rawDelete("DROP TABLE ${PasswordTable.name}");
  }

  /// 删除表中所有内容
  @override
  Future<int> deleteAll() async {
    Database db = await getDatabase();
    var count = await db.delete(PasswordTable.name);
    // 清除表的Key自增值
    await db.delete(
      "sqlite_sequence",
      where: "name=?",
      whereArgs: [PasswordTable.name],
    );
    return count;
  }

  /// 插入密码
  @override
  Future<int> insert(PasswordBean bean) async {
    Database db = await getDatabase();
    Map<String, dynamic> map = bean.toJson();
    return await db.insert(
      PasswordTable.name,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<int> updateUserData(AutofillSaveRequest request) async {
    Database db = await getDatabase();
    return await db.rawUpdate(
      "UPDATE ${PasswordTable.name} SET "
      "${PasswordTable.columnName}=?,"
      "${PasswordTable.columnPassword}=?,"
      "${PasswordTable.columnAppName}=? "
      "WHERE ${PasswordTable.columnUsername}=${request.username} "
      "AND ${PasswordTable.columnAppId}=${request.appId}",
      [request.name, request.password, request.appName],
    );
  }

  /// 根据uniqueKey查询记录
  @override
  Future<PasswordBean?> findById(int id) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> maps = await db.query(
      PasswordTable.name,
      where: "${PasswordTable.columnId}=?",
      whereArgs: [id],
    );
    if (maps.length > 0) {
      return PasswordBean.fromJson(maps.first);
    }
    return null;
  }

  /// 获取所有的密码List
  @override
  Future<List<PasswordBean>> findAll() async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> list = await db.query(PasswordTable.name);
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

  @override
  Future<List<PasswordBean>> findByAppIdAndUsername(
      String appId, String username) async {
    if (appId.length == 0) {
      return [];
    }
    Database db = await getDatabase();
    List<Map<String, dynamic>> list = await db.query(
      PasswordTable.name,
      where:
          "${PasswordTable.columnAppId}=? AND ${PasswordTable.columnUsername}=?",
      whereArgs: [appId, username],
    );
    return list.map((e) => PasswordBean.fromJson(e)).toList();
  }

  @override
  Future<List<PasswordBean>> findByAppIdOrAppName(
    String appId,
    String? appName, {
    int page = 0,
    int pageSize = 10,
  }) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> list;
    if (appName == null) {
      list = await db.query(
        PasswordTable.name,
        where: "${PasswordTable.columnAppId} LIKE ?",
        whereArgs: ["%$appId%"],
        offset: page * pageSize,
        limit: pageSize,
      );
    } else {
      list = await db.query(
        PasswordTable.name,
        where:
            "${PasswordTable.columnAppId} LIKE ? OR ${PasswordTable.columnAppName}=? OR ${PasswordTable.columnName} LIKE ?",
        whereArgs: ["%$appId%", appName, "%$appName%"],
      );
    }
    return list.map((e) => PasswordBean.fromJson(e)).toList(growable: false);
  }

  /// 删除指定uniqueKey的密码
  @override
  Future<int> deleteById(int key) async {
    Database db = await getDatabase();
    return await db.delete(
      PasswordTable.name,
      where: '${PasswordTable.columnId}=?',
      whereArgs: [key],
    );
  }

  /// 更新
  @override
  Future<int> updateById(PasswordBean bean) async {
    Database db = await getDatabase();
    String labels = StringUtil.list2WaveLineSegStr(bean.label);
    return await db.rawUpdate(
      "UPDATE ${PasswordTable.name} SET "
      "${PasswordTable.columnName}=?,"
      "${PasswordTable.columnUsername}=?,"
      "${PasswordTable.columnPassword}=?,"
      "${PasswordTable.columnUrl}=?,"
      "${PasswordTable.columnFolder}=?,"
      "${PasswordTable.columnFav}=?,"
      "${PasswordTable.columnNotes}=?,"
      "${PasswordTable.columnLabel}=?,"
      "${PasswordTable.columnSortNumber}=?,"
      "${PasswordTable.columnAppId}=?,"
      "${PasswordTable.columnAppName}=? WHERE ${PasswordTable.columnId}=${bean.uniqueKey}",
      [
        bean.name,
        bean.username,
        bean.password,
        bean.url,
        bean.folder,
        bean.fav,
        bean.notes,
        labels,
        bean.sortNumber,
        bean.appId,
        bean.appName
      ],
    );
    // 下面的语句更新时提示UNIQUE constraint failed
    // return await db.update(name, passwordBean2Map(bean));
  }
}
