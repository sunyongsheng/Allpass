import 'package:flutter/material.dart';

import 'package:allpass/pages/password/password_page.dart';
import 'package:allpass/pages/card/card_page.dart';
import 'package:allpass/pages/setting/setting_page.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  final List<Widget> _pagesList = List()
    ..add(PasswordPage())
    ..add(CardPage())
    ..add(SettingPage());
  int _currentIndex = 0;
  PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemBuilder: (context, index) {
            return _pagesList[index];
          },
        itemCount: _pagesList.length,
        controller: _controller,
        onPageChanged: (index) {
          if (index  != _currentIndex) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.supervised_user_circle,
              color: _currentIndex==0?null:Colors.grey,
            ),
            title: Text("密码", style: TextStyle(fontSize: 12),),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.credit_card,
                color: _currentIndex==1?null:Colors.grey,
              ),
              title: Text("卡片", style: TextStyle(fontSize: 12))
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                color: _currentIndex==2?null:Colors.grey,
              ),
              title: Text("设置", style: TextStyle(fontSize: 12))
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          _controller.jumpToPage(index);
        },
      ),
    );
  }
}