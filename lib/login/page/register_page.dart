import 'dart:io';
import 'dart:ui';

import 'package:allpass/classification/category_provider.dart';
import 'package:allpass/common/widget/loading_text_button.dart';
import 'package:allpass/home/about_page.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:allpass/application.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/encrypt/encrypt_util.dart';
import 'package:allpass/navigation/navigator.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {

  @override
  State createState() {
    return _RegisterPage();
  }
}

class _RegisterPage extends State<RegisterPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();

  @override
  void initState() {
    super.initState();

    var themeProvider = context.read<ThemeProvider>();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      themeProvider.setExtraColor(PlatformDispatcher.instance.platformBrightness);

      var isFirstRun = AllpassApplication.sp.getBool(SPKeys.firstRun) ?? true;
      if (isFirstRun) {
        context.read<CategoryProvider>().addFolder([
          context.l10n.folderEntertainment,
          context.l10n.folderOffice,
          context.l10n.folderFinance,
          context.l10n.folderSocial,
          context.l10n.folderGame,
          context.l10n.folderEducation,
          context.l10n.folderForum,
        ]);
        AllpassApplication.sp.setBool(SPKeys.firstRun, false);
      }

      _tryShowPrivacyDialog();
    });

    PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
      themeProvider.setExtraColor(PlatformDispatcher.instance.platformBrightness);
    };
  }

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: AllpassScreenUtil.setHeight(500)),
        child: Padding(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(150), right: ScreenUtil().setWidth(150)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                child: Text(
                  l10n.setupAllpass,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                padding: AllpassEdgeInsets.smallTBPadding,
              ),
              NoneBorderCircularTextField(
                  editingController:_passwordController,
                  hintText: l10n.pleaseInputMainPassword,
                  obscureText: true,
                  textAlign: TextAlign.center,
              ),
              NoneBorderCircularTextField(
                  editingController: _secondController,
                  hintText: l10n.pleaseInputAgain,
                  obscureText: true,
                  textAlign: TextAlign.center,
              ),
              Container(
                padding: AllpassEdgeInsets.smallTBPadding,
                child: LoadingTextButton(
                  color: Theme.of(context).primaryColor,
                  title: l10n.setup,
                  onPressed: () async => await register(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> register(BuildContext context) async {
    if (_passwordController.text != _secondController.text) {
      ToastUtil.showError(msg: context.l10n.passwordNotSame);
      return;
    }

    if (_passwordController.text.length < 6) {
      ToastUtil.showError(msg: context.l10n.passwordTooShort);
      return;
    }

    // 判断是否已有账号存在
    if (Config.password.isEmpty) {
      _registerActual();
      ToastUtil.show(msg: context.l10n.setupSuccess);
    } else {
      ToastUtil.showError(msg: context.l10n.alreadySetup);
    }
  }

  void _registerActual() {
    String _password = EncryptUtil.encrypt(_passwordController.text);
    Config.setPassword(_password);
    Config.setEnabledBiometrics(false);
    AllpassNavigator.goLoginPage(context);
  }

  void _tryShowPrivacyDialog() {
    if (AllpassApplication.sp.getBool(SPKeys.privacyAgreementAccepted) ?? false) {
      return;
    }

    var l10n = context.l10n;
    showDialog(
      context: context,
      builder: (cx) => AlertDialog(
        title: Text(l10n.serviceTerms),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AboutPage.serviceContent,
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(l10n.confirmServiceTerms),
            onPressed: () async {
              AllpassApplication.sp.setBool(SPKeys.privacyAgreementAccepted, true);
              Navigator.pop(cx);
            },
          ),
          TextButton(
            child: Text(l10n.cancel),
            onPressed: () => exit(0),
          )
        ],
      ),
    );
  }
}