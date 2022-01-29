import 'package:sqflite/sqflite.dart';

import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/core/dao/db_provider.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/util/string_util.dart';

class CardDao extends BaseDBProvider {
  /// 表名
  static final String name = "allpass_card";

  /// 表主键字段
  static final String columnId = "uniqueKey";

  /// 版本1列名
  static final String columnName = "name";
  static final String columnOwnerName = "ownerName";
  static final String columnCardId = "cardId";
  static final String columnPassword = "password";
  static final String columnTelephone = "telephone";
  static final String columnFolder  ="folder";
  static final String columnNotes = "notes";
  static final String columnLabel = "label";
  static final String columnFav = "fav";
  static final String columnCreateTime = "createTime";
  static final String columnSortNumber = "sortNumber";

  @override
  String tableName() {
    return name;
  }

  /// 创建表的sql
  @override
  String tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
      $columnName TEXT NOT NULL,
      $columnOwnerName TEXT,
      $columnCardId TEXT NOT NULL,
      $columnPassword TEXT,
      $columnTelephone TEXT,
      $columnFolder TEXT DEFAULT '默认',
      $columnNotes TEXT,
      $columnLabel TEXT,
      $columnFav INTEGER DEFAULT 0,
      $columnCreateTime TEXT,
      $columnSortNumber INTEGER DEFAULT -1)
      ''';
  }

  /// 删除表
  Future<Null> deleteTable() async {
    Database db = await getDataBase();
    db.rawDelete("DROP TABLE $name");
  }

  /// 删除表中所有数据
  Future<Null> deleteContent() async {
    Database db = await getDataBase();
    db.delete(name);
    // 清除表的Key自增值
    db.delete("sqlite_sequence", where: "name=?", whereArgs: [name]);
  }

  /// 插入卡片
  Future<int> insert(CardBean bean) async {
    Database db = await getDataBase();
    return await db.insert(name, bean.toJson());
  }

  /// 根据uniqueKey查询记录
  Future<CardBean?> getCardBeanById(String id) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.query(name);
    if (maps.length > 0) {
      CardBean bean = CardBean.fromJson(maps.first);
      bean.color = getRandomColor(seed: bean.uniqueKey);
      return bean;
    }
    return null;
  }

  /// 获取所有的卡片List
  Future<List<CardBean>> getAllCardBeanList() async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.query(name);
    if (maps.length > 0) {
      List<CardBean> res = maps.map((item) {
        CardBean bean = CardBean.fromJson(item);
        bean.color = getRandomColor(seed: bean.uniqueKey);
        return bean;
      }).toList();
      return res;
    }
    return [];
  }

  /// 删除指定uniqueKey的密码
  Future<int> deleteCardBeanById(int key) async {
    Database db = await getDataBase();
    return await db.delete(name, where: '$columnId=?', whereArgs: [key]);
  }

  /// 更新
  Future<int> updateCardBeanById(CardBean bean) async {
    Database db = await getDataBase();
    String labels = StringUtil.list2WaveLineSegStr(bean.label);
    return await db.rawUpdate("UPDATE $name SET "
        "$columnName=?,"
        "$columnOwnerName=?,"
        "$columnCardId=?,"
        "$columnPassword=?,"
        "$columnTelephone=?,"
        "$columnFolder=?,"
        "$columnNotes=?,"
        "$columnLabel=?,"
        "$columnFav=?,"
        "$columnSortNumber=? WHERE $columnId=${bean.uniqueKey}",
        [bean.name, bean.ownerName, bean.cardId, bean.password, bean.telephone, bean.folder, bean.notes, labels, bean.fav, bean.sortNumber]);
  }
}