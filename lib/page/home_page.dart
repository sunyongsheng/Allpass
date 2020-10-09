import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:allpass/main.dart';
import 'package:allpass/application.dart';
import 'package:allpass/service/allpass_service.dart';
import 'package:allpass/model/api/update_bean.dart';
import 'package:allpass/provider/theme_provider.dart';
import 'package:allpass/page/setting/secret_key_upgrade_page.dart';
import 'package:allpass/page/password/password_page.dart';
import 'package:allpass/page/card/card_page.dart';
import 'package:allpass/page/classification/classification_page.dart';
import 'package:allpass/page/setting/setting_page.dart';
import 'package:allpass/widget/setting/update_dialog.dart';
import 'package:allpass/widget/common/confirm_dialog.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (needUpdateSecret) {
        showDialog(
            context: context,
            builder: (context) => ConfirmDialog(
                "密钥升级建议", "检测到您升级到Allpass 1.5.0，建议您进行密钥升级，可以极大的增加密码的安全性，是否继续（之后可在“设置-主账号管理-加密密钥更新”中操作）？"
            )
        ).then((value) {
          if (value != null && value) {
            Navigator.push(context, CupertinoPageRoute(
                builder: (context) => SecretKeyUpgradePage()
            ));
          }
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      UpdateBean updateBean = await Application.getIt<AllpassService>().checkUpdate();
      if (updateBean.checkResult == CheckUpdateResult.HaveUpdate) {
        showDialog(
          context: context,
          child: UpdateDialog(updateBean)
        );
      }
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