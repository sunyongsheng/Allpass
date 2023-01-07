import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/core/param/config.dart';
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
            "主题颜色",
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
                children: themeModes
                    .map((e) => _createThemeModeItem(e))
                    .toList(),
              ),
            ),
            Card(
                margin: AllpassEdgeInsets.settingCardInset,
                elevation: 0,
                child: Column(
                  children: primaryColors
                      .map((e) => _createPrimaryColorItem(e))
                      .toList(),
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
          provider.changePrimaryColor(mode, context: context);
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
          provider.changeThemeMode(item.mode, context: context);
        });
      },
    );
  }
}
