import 'package:flutter/material.dart';

const String noneData = "NONE_DATA_s8ua8dMwq12ud+h0q9wcHds9wq";

/// 基础Bean，其中的字段不会被存储到数据库中
class BaseModel {
  Color? color;
}

extension NoneData on String? {
  String noneDataOrNot() {
    return (this == null || this!.isEmpty) ? noneData : this!;
  }
}