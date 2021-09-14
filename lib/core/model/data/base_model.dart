import 'package:flutter/material.dart';

/// 基础Bean，其中的字段不会被存储到数据库中
class BaseModel {
  static final String noneData = "NONE_DATA_s8ua8dMwq12ud+h0q9wcHds9wq";
  Color? color;

  static String isNoneDataOrItSelf(String? text) {
    return (text == null || text.length == 0) ? noneData : text;
  }
}