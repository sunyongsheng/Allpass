import 'dart:io';
import 'dart:ui';

import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/card/page/card_page.dart';
import 'package:allpass/classification/page/classification_page.dart';
import 'package:allpass/core/di/di.dart';
import 'package:allpass/core/model/api/update_bean.dart';
import 'package:allpass/core/service/allpass_service.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/common/data/multi_item_edit_provider.dart';
import 'package:allpass/password/page/password_page.dart';
import 'package:allpass/setting/setting_page.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:allpass/setting/update/update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  final List<Widget> _pagesList = []
    ..add(ChangeNotifierProvider(
      create: (BuildContext context) => MultiItemEditProvider<PasswordBean>(),
      child: PasswordPage(),
    ))
    ..add(ChangeNotifierProvider(
      create: (_) => MultiItemEditProvider<CardBean>(),
      child: CardPage(),
    ))
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
      UpdateBean updateBean = await inject<AllpassService>().checkUpdate();
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
    context.read<ThemeProvider>().setExtraColor(PlatformDispatcher.instance.platformBrightness);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if (Platform.isIOS) {
      switch (state) {
        case AppLifecycleState.resumed:
          break;
        case AppLifecycleState.inactive:
          break;
        case AppLifecycleState.paused:
          break;
        case AppLifecycleState.detached:
          break;
      }
    }
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
    var l10n = context.l10n;
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
            label: l10n.password,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card,),
            label: l10n.card,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_,),
            label: l10n.folderTitle
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,),
            label: l10n.settings
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
