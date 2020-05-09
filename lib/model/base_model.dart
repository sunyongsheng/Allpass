import 'package:flutter/material.dart';

/// 基础Bean，其中的字段不会被存储到数据库中
class BaseModel {
  Color color;
  bool isChanged;  // 是否被修改
}