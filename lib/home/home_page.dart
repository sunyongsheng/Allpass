import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:allpass/application.dart';
import 'package:allpass/core/service/allpass_service.dart';
import 'package:allpass/core/model/api/update_bean.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:allpass/password/page/password_page.dart';
import 'package:allpass/card/page/card_page.dart';
import 'package:allpass/classification/page/classification_page.dart';
import 'package:allpass/setting/setting_page.dart';
import 'package:allpass/setting/update/update_dialog.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {

  final List<Widget> _pagesList = []
    ..add(PasswordPage())
    ..add(CardPage())
    ..add(ClassificationPage())
    ..add(SettingPage());
  int _currentIndex = 0;
  late PageController _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      UpdateBean updateBean = await AllpassApplication.getIt<AllpassService>().checkUpdate();
      if (updateBean.checkResult == CheckUpdateResult.HaveUpdate) {
        showDialog(
            context: context,
            builder: (cx) => UpdateDialog(updateBean)
        );
      }
    });
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    context.read<ThemeProvider>().setExtraColor(context: context, needReverse: true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
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
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle,),
            label: "密码",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card,),
            label: "卡片"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_,),
            label: "分类"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,),
            label: "设置"
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
