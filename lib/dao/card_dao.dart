import 'package:sqflite/sqflite.dart';

import 'package:allpass/utils/db_provider.dart';
import 'package:allpass/model/card_bean.dart';


class CardDao extends BaseDBProvider {
  // 表名
  final String name = "allpass_card";

  // 表主键字段
  final String columnId = "uniqueKey";

  @override
  tableName() {
    return name;
  }

  // 创建表的sql
  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
      name TEXT NOT NULL,
      ownerName TEXT NOT NULL,
      cardId TEXT NOT NULL,
      url TEXT,
      telephone TEXT,
      folder TEXT DEFALUT '默认',
      notes TEXT,
      label TEXT,
      fav INTEGER DEFAULT 0)
      ''';
  }

  // 删除表
  deleteTable() async {
    Database db = await getDataBase();
    db.rawDelete("DROP TABLE $name");
  }

  // 插入卡片
  Future insert(CardBean bean) async {
    Database db = await getDataBase();
    return await db.insert(name, cardBean2Map(bean));
  }

  // 根据uniqueKey查询记录
  Future<CardBean> getCardBeanById(String id) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.query(name);
    if (maps.length > 0) {
      return CardBean.fromJson(maps.first);
    }
    return null;
  }

  // 获取所有的卡片List
  Future<List<CardBean>> getAllCardBeanList() async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.query(name);
    if (maps.length > 0) {
      List<CardBean> res = maps.map((item) => CardBean.fromJson(item)).toList();
      return res;
    }
    return null;
  }

  // 删除指定uniqueKey的密码
  Future<int> deleteCardBeanById(int key) async {
    Database db = await getDataBase();
    return await db.delete(name, where: '$columnId=?', whereArgs: [key]);
  }

  // 更新
  Future<int> updatePasswordBean(CardBean bean) async {
    Database db = await getDataBase();
    String labels = "";
    for (String la in bean.label) {
      labels += la;
      if (la != bean.label.last) labels += "~";
    }
    return await db.rawUpdate("UPDATE $name SET name=?, ownerName=?, cardId=?, url=?, telephone=?, folder=?, notes=?, label=?, fav=? WHERE $columnId=${bean.uniqueKey}",
        [bean.name, bean.ownerName, bean.cardId, bean.url, bean.telephone, bean.folder, bean.notes, labels, bean.fav]);
  }

  Map<String, dynamic> cardBean2Map(CardBean bean) {
    String labels = "";
    for (String la in bean.label) {
      labels += la;
      if (la != bean.label.last) labels += "~";
    }
    Map<String, dynamic> map = {
      "uniqueKey": bean.uniqueKey,
      "name": bean.name,
      "ownerName": bean.ownerName,
      "cardId": bean.cardId,
      "telephone": bean.telephone,
      "url": bean.url,
      "folder": bean.folder,
      "fav": bean.fav,
      "notes": bean.notes,
      "label": labels
    };
    return map;
  }
}