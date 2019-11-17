import 'package:flutter/material.dart';

import 'package:allpass/pages/password_page.dart';
import 'package:allpass/pages/card_page.dart';
import 'package:allpass/pages/setting_page.dart';

class BottomNavigationWidget extends StatefulWidget {

  @override
  _BottomNavigationWidget createState() => _BottomNavigationWidget();
}

class _BottomNavigationWidget extends State<BottomNavigationWidget> {

  final Color _appColor = Colors.blue;
  List<Widget> pagesList = List();
  int _currentIndex = 0;

  @override
  void initState() {
    pagesList..add(PasswordPage())
             ..add(CardPage())
             ..add(SettingPage());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pagesList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.supervised_user_circle,
              color: _currentIndex==0?_appColor:Colors.grey,
            ),
            title: Text("密码"),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.credit_card,
                color: _currentIndex==1?_appColor:Colors.grey,
              ),
              title: Text("卡片")
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                color: _currentIndex==2?_appColor:Colors.grey,
              ),
              title: Text("设置")
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}