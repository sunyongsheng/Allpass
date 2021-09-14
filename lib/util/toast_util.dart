
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {

  ToastUtil._();

  static void show({required String msg}) {
    Fluttertoast.showToast(msg: msg,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black87,
        textColor: Colors.white);
  }

  static void showError({required String msg}) {
    Fluttertoast.showToast(msg: msg,
        gravity: ToastGravity.CENTER,
        backgroundColor: Color.fromRGBO(255, 0, 76, 0.87),
        textColor: Colors.white);
  }
}