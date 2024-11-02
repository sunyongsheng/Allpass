import 'dart:io';
import 'dart:ui';

import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/card/page/card_page.dart';
import 'package:allpass/classification/page/classification_page.dart';
import 'package:allpass/core/di/di.dart';
import 'package:allpass/core/model/api/update_bean.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/core/service/allpass_service.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/navigation/navigator.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/common/data/multi_item_edit_provider.dart';
import 'package:allpass/password/page/password_page.dart';
import 'package:allpass/setting/autofill/autofill_provider.dart';
import 'package:allpass/setting/setting_page.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:allpass/setting/update/update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {

  final AutofillProvider autofillProvider = AutofillProvider();

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

    autofillProvider.checkSupportAutofill();

    // 导入密码Channel
    var importCsvMessageChannel = MethodChannel(ChannelConstants.channelImportCsv);
    importCsvMessageChannel.setMethodCallHandler((call) {
      if (call.method == ChannelConstants.methodOpenImportPage) {
        AllpassNavigator.goImportDataPage(context, call.arguments);
      }
      return Future.value(null);
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
        default:
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
      body: PageView.builder(
        itemCount: 4,
        controller: _controller,
        onPageChanged: (index) {
          if (index != _currentIndex) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        itemBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return ChangeNotifierProvider(
                create: (context) => MultiItemEditProvider<PasswordBean>(),
                child: PasswordPage(),
              );
            case 1:
              return ChangeNotifierProvider(
                create: (_) => MultiItemEditProvider<CardBean>(),
                child: CardPage(),
              );
            case 2:
              return ClassificationPage();
            case 3:
              return ChangeNotifierProvider<AutofillProvider>(
                create: (_) => autofillProvider,
                child: SettingPage(),
              );
            default:
              return null;
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
