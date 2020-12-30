
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {

  ToastUtil._();

  static void show({String msg}) {
    Fluttertoast.showToast(msg: msg,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black54,
        textColor: Colors.white);
  }
}