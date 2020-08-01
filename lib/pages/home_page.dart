import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:allpass/provider/theme_provider.dart';
import 'package:allpass/pages/password/password_page.dart';
import 'package:allpass/pages/card/card_page.dart';
import 'package:allpass/pages/classification/classification_page.dart';
import 'package:allpass/pages/setting/setting_page.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {

  final List<Widget> _pagesList = List()
    ..add(PasswordPage())
    ..add(CardPage())
    ..add(ClassificationPage())
    ..add(SettingPage());
  int _currentIndex = 0;
  PageController _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ThemeProvider>(context).setExtraColor(context: context);
    });
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    Provider.of<ThemeProvider>(context).setExtraColor(context: context, needReverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: PageView(
        children: _pagesList,
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
        backgroundColor: Theme.of(context).bottomAppBarColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle,),
            title: Text("密码", style: TextStyle(fontSize: 12),),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card,),
              title: Text("卡片", style: TextStyle(fontSize: 12))
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.class_,),
              title: Text("分类", style: TextStyle(fontSize: 12))
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings,),
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