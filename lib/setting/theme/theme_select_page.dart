import 'dart:ui';

import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/setting/theme/theme_mode.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSelectPage extends StatefulWidget {
  @override
  _ThemeSelectPage createState() => _ThemeSelectPage();
}

class _ThemeSelectPage extends State<ThemeSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            context.l10n.appTheme,
            style: AllpassTextUI.titleBarStyle,
          ),
          centerTitle: true,
        ),
        backgroundColor: context.watch<ThemeProvider>().specialBackgroundColor,
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: AllpassScreenUtil.setHeight(15)),
            ),
            Card(
              margin: AllpassEdgeInsets.settingCardInset,
              elevation: 0,
              child: Column(
                children: [
                  _createThemeModeItem(ThemeModeItem(
                    ThemeMode.system,
                    context.l10n.themeSystem,
                  )),
                  _createThemeModeItem(ThemeModeItem(
                    ThemeMode.light,
                    context.l10n.themeLight,
                  )),
                  _createThemeModeItem(ThemeModeItem(
                    ThemeMode.dark,
                    context.l10n.themeDark,
                  )),
                ],
              ),
            ),
            Card(
                margin: AllpassEdgeInsets.settingCardInset,
                elevation: 0,
                child: Column(
                  children: [
                    _createPrimaryColorItem(PrimaryColorItem(
                      PrimaryColor.blue,
                      context.l10n.themeColorBlue,
                      Colors.blue,
                    )),
                    _createPrimaryColorItem(PrimaryColorItem(
                      PrimaryColor.red,
                      context.l10n.themeColorRed,
                      Colors.red,
                    )),
                    _createPrimaryColorItem(PrimaryColorItem(
                      PrimaryColor.teal,
                      context.l10n.themeColorTeal,
                      Colors.teal,
                    )),
                    _createPrimaryColorItem(PrimaryColorItem(
                      PrimaryColor.deepPurple,
                      context.l10n.themeColorDeepPurple,
                      Colors.deepPurple,
                    )),
                    _createPrimaryColorItem(PrimaryColorItem(
                      PrimaryColor.orange,
                      context.l10n.themeColorOrange,
                      Colors.orange,
                    )),
                    _createPrimaryColorItem(PrimaryColorItem(
                      PrimaryColor.pink,
                      context.l10n.themeColorPink,
                      Colors.pink,
                    )),
                    _createPrimaryColorItem(PrimaryColorItem(
                      PrimaryColor.blueGrey,
                      context.l10n.themeColorBlueGrey,
                      Colors.blueGrey,
                    )),
                  ],
                )),
          ],
        ));
  }

  Widget _createPrimaryColorItem(PrimaryColorItem item) {
    var mode = item.primaryColor;
    bool selected = Config.primaryColor == mode;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: item.color,
        radius: 15,
      ),
      title: Text(item.desc),
      trailing: selected ? Icon(Icons.check, color: Colors.grey) : null,
      onTap: () {
        var provider = context.read<ThemeProvider>();
        setState(() {
          provider.changePrimaryColor(mode, window.platformBrightness);
        });
      },
    );
  }

  Widget _createThemeModeItem(ThemeModeItem item) {
    return ListTile(
      title: Text(item.desc),
      trailing: Config.themeMode == item.mode
          ? Icon(Icons.check, color: Colors.grey)
          : null,
      onTap: () {
        var provider = context.read<ThemeProvider>();
        setState(() {
          provider.changeThemeMode(item.mode, window.platformBrightness);
        });
      },
    );
  }
}
