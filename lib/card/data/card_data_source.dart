import 'package:allpass/card/data/card_table.dart';
import 'package:allpass/core/dao/db_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/util/string_util.dart';

class CardDataSource extends BaseDBProvider with CardTable {

  /// 删除表
  Future<Null> deleteTable() async {
    Database db = await getDatabase();
    db.rawDelete("DROP TABLE ${CardTable.name}");
  }

  /// 删除表中所有数据
  Future<int> deleteContent() async {
    Database db = await getDatabase();
    var count = db.delete(CardTable.name);
    // 清除表的Key自增值
    db.delete("sqlite_sequence", where: "name=?", whereArgs: [CardTable.name]);
    return count;
  }

  /// 插入卡片
  Future<int> insert(CardBean bean) async {
    Database db = await getDatabase();
    return await db.insert(
      CardTable.name,
      bean.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 根据uniqueKey查询记录
  Future<CardBean?> findById(String id) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> maps = await db.query(
      CardTable.name,
      where: "${CardTable.columnId}=?",
      whereArgs: [id],
    );
    if (maps.length > 0) {
      return CardBean.fromJson(maps.first);
    }
    return null;
  }

  /// 获取所有的卡片List
  Future<List<CardBean>> findAll() async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> maps = await db.query(CardTable.name);
    if (maps.length > 0) {
      return maps.map((item) => CardBean.fromJson(item)).toList();
    }
    return [];
  }

  /// 删除指定uniqueKey的密码
  Future<int> deleteById(int key) async {
    Database db = await getDatabase();
    return await db.delete(
      CardTable.name,
      where: '${CardTable.columnId}=?',
      whereArgs: [key],
    );
  }

  /// 更新
  Future<int> updateById(CardBean bean) async {
    Database db = await getDatabase();
    String labels = StringUtil.list2WaveLineSegStr(bean.label);
    return await db.rawUpdate(
      "UPDATE ${CardTable.name} SET "
      "${CardTable.columnName}=?,"
      "${CardTable.columnOwnerName}=?,"
      "${CardTable.columnCardId}=?,"
      "${CardTable.columnPassword}=?,"
      "${CardTable.columnTelephone}=?,"
      "${CardTable.columnFolder}=?,"
      "${CardTable.columnNotes}=?,"
      "${CardTable.columnLabel}=?,"
      "${CardTable.columnFav}=?,"
      "${CardTable.columnSortNumber}=? WHERE ${CardTable.columnId}=${bean.uniqueKey}",
      [
        bean.name,
        bean.ownerName,
        bean.cardId,
        bean.password,
        bean.telephone,
        bean.folder,
        bean.notes,
        labels,
        bean.fav,
        bean.sortNumber
      ],
    );
  }
}