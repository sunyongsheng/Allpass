import 'package:sqflite/sqflite.dart';

import 'package:allpass/model/password_bean.dart';
import 'package:allpass/utils/db_provider.dart';
import 'package:allpass/utils/encrypt_helper.dart';
import 'package:allpass/utils/string_process.dart';

class PasswordDao extends BaseDBProvider {

  // 表名
  final String name = "allpass_password";

  // 表主键字段
  final String columnId = "uniqueKey";

  @override
  tableName() {
    return name;
  }

  // 删除表
  deleteTable() async {
    Database db = await getDataBase();
    db.rawDelete("DROP TABLE $name");
  }

  // 创建表的sql
  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
      '''
      name TEXT NOT NULL,
      username TEXT NOT NULL,
      password TEXT NOT NULL,
      url TEXT NOT NULL,
      folder TEXT DEFALUT '默认',
      notes TEXT,
      label TEXT,
      fav INTEGER DEFAULT 0)
      ''';
  }

  // 插入密码
  Future insert(PasswordBean bean) async {
    Database db = await getDataBase();
    Map<String, dynamic> map = await PasswordBean.passwordBean2Map(bean);
    return await db.insert(name, map);
  }

  // 根据uniqueKey查询记录
  Future<PasswordBean> getPasswordBeanById(String id) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.query(name);
    if (maps.length > 0) {
      return await PasswordBean.fromJson(maps.first);
    }
    return null;
  }

  // 获取所有的密码List
  Future<List<PasswordBean>> getAllPasswordBeanList() async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.query(name);
    if (maps.length > 0) {
      List<PasswordBean> res = List();
      for (var map in maps) {
        res.add(await PasswordBean.fromJson(map));
      }
      return res;
    }
    return null;
  }

  // 删除指定uniqueKey的密码
  Future<int> deletePasswordBeanById(int key) async {
    Database db = await getDataBase();
    return await db.delete(name, where: '$columnId = ?', whereArgs: [key]);
  }

  // 更新
  Future<int> updatePasswordBean(PasswordBean bean) async {
    Database db = await getDataBase();
    String labels = list2Str(bean.label);
    return await db.rawUpdate("UPDATE $name SET name=?, username=?, password=?, url=?, folder=?, fav=?, notes=?, label=? WHERE $columnId=${bean.uniqueKey}",
        [bean.name, bean.username, await EncryptHelper.encrypt(bean.password), bean.url, bean.folder, bean.fav, bean.notes, labels]);
    // 下面的语句更新时提示UNIQUE constraint failed
    // return await db.update(name, passwordBean2Map(bean));
  }
}