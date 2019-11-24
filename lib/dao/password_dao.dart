import 'package:sqflite/sqflite.dart';

import 'package:allpass/bean/password_bean.dart';
import 'package:allpass/utils/db_provider.dart';

class PasswordDao extends BaseDBProvider {

  // 表名
  final String name = "allpass_password";

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
      username TEXT NOT NULL,
      password TEXT NOT NULL,
      url TEXT NOT NULL,
      forder TEXT DEFALUT '默认',
      notes TEXT,
      label TEXT,
      fav INTEGER DEFAULT 0)
      ''';
  }

  // 插入密码
  Future insert(PasswordBean bean) async {
    Database db = await getDataBase();
    return db.insert(name, passwordBean2Map(bean));
  }

  // 根据uniqueKey查询记录
  Future<PasswordBean> getPasswordBean(String id) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.query(name);
    if (maps.length > 0) {
      return PasswordBean.fromJson(maps.first);
    }
    return null;
  }

  // 获取所有的密码List
  Future<List<PasswordBean>> getPasswordBeanList() async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.query(name);
    if (maps.length > 0) {
      List<PasswordBean> res = maps.map((item) => PasswordBean.fromJson(item)).toList();
      return res;
    }
    return null;
  }

  Map<String, dynamic> passwordBean2Map(PasswordBean bean) {
    String labels;
    for (String la in bean.label) {
      la += "~";
      labels += la;
    }
    Map<String, dynamic> map = {
      "uniqueKey": bean.uniqueKey,
      "name": bean.name,
      "username": bean.username,
      "password": bean.password,
      "url": bean.url,
      "folder": bean.folder,
      "fav": bean.fav,
      "notes": bean.notes,
      "label": labels
    };
    return map;
  }

}