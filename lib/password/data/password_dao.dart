import 'package:allpass/password/model/simple_user.dart';
import 'package:sqflite/sqflite.dart';

import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
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

  @override
  String tableName() {
    return name;
  }

  /// 删除表
  Future<Null> deleteTable() async {
    Database db = await getDataBase();
    db.rawDelete("DROP TABLE $name");
  }

  /// 删除表中所有内容
  Future<Null> deleteContent() async {
    Database db = await getDataBase();
    db.delete(name);
    // 清除表的Key自增值
    db.delete("sqlite_sequence", where: "name=?", whereArgs: [name]);
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
      $columnAppId TEXT)
      ''';
  }

  /// 插入密码
  Future<int> insert(PasswordBean bean) async {
    Database db = await getDataBase();
    Map<String, dynamic> map = bean.toJson();
    return await db.insert(name, map);
  }

  Future<int> insertUserData(SimpleUser user) async {
    Database db = await getDataBase();
    Map<String, dynamic> map = user.toJson();
    map['createTime'] = DateTime.now().toIso8601String();
    return await db.insert(name, map);
  }

  /// 根据uniqueKey查询记录
  Future<PasswordBean?> getPasswordBeanById(String id) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.query(name);
    if (maps.length > 0) {
      PasswordBean bean = PasswordBean.fromJson(maps.first);
      bean.color = getRandomColor(seed: bean.uniqueKey);
      return bean;
    }
    return null;
  }

  /// 获取所有的密码List
  Future<List<PasswordBean>?> getAllPasswordBeanList() async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.query(name);
    if (maps.length > 0) {
      List<PasswordBean> res = [];
      for (var map in maps) {
        PasswordBean bean = PasswordBean.fromJson(map);
        bean.color = getRandomColor(seed: bean.uniqueKey);
        res.add(bean);
      }
      return res;
    }
    return null;
  }

  /// 删除指定uniqueKey的密码
  Future<int> deletePasswordBeanById(int key) async {
    Database db = await getDataBase();
    return await db.delete(name, where: '$columnId = ?', whereArgs: [key]);
  }

  /// 更新
  Future<int> updatePasswordBeanById(PasswordBean bean) async {
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
        "$columnAppId=? WHERE $columnId=${bean.uniqueKey}",
        [bean.name, bean.username, bean.password, bean.url, bean.folder, bean.fav, bean.notes, labels, bean.sortNumber, bean.appId]);
    // 下面的语句更新时提示UNIQUE constraint failed
    // return await db.update(name, passwordBean2Map(bean));
  }
}