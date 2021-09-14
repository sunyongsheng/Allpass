import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:allpass/common/ui/allpass_ui.dart';

class ThemeSelectPage extends StatefulWidget {

  @override
  _ThemeSelectPage createState() => _ThemeSelectPage();
}

class _ThemeSelectPage extends State<ThemeSelectPage> {

  @override
  Widget build(BuildContext context) {
    int theme = getSystemTheme();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "主题颜色",
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: AllpassEdgeInsets.listInset,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
              ),
              title: Text("蓝色"),
              trailing: theme == 1 ? Icon(Icons.check) : null,
              onTap: () {
                setTheme("blue");
              },
            ),
          ),
          Padding(
            padding: AllpassEdgeInsets.listInset,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red,
              ),
              title: Text("红色"),
              trailing: theme == 2 ? Icon(Icons.check) : null,
              onTap: () {
                setTheme("red");
              },
            ),
          ),
          Padding(
            padding: AllpassEdgeInsets.listInset,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal,
              ),
              title: Text("青色"),
              trailing: theme == 3 ? Icon(Icons.check) : null,
              onTap: () {
                setTheme("teal");
              },
            ),
          ),
          Padding(
            padding: AllpassEdgeInsets.listInset,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple,
              ),
              title: Text("深紫"),
              trailing: theme == 4 ? Icon(Icons.check) : null,
              onTap: () {
                setTheme("deepPurple");
              },
            ),
          ),
          Padding(
            padding: AllpassEdgeInsets.listInset,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange,
              ),
              title: Text("橙色"),
              trailing: theme == 5 ? Icon(Icons.check) : null,
              onTap: () {
                setTheme("orange");
              },
            ),
          ),
          Padding(
            padding: AllpassEdgeInsets.listInset,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.pink,
              ),
              title: Text("粉色"),
              trailing: theme == 6 ? Icon(Icons.check) : null,
              onTap: () {
                setTheme("pink");
              },
            ),
          ),
          Padding(
            padding: AllpassEdgeInsets.listInset,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueGrey,
              ),
              title: Text("蓝灰"),
              trailing: theme == 7 ? Icon(Icons.check) : null,
              onTap: () {
                setTheme("blueGrey");
              },
            ),
          ),
          Padding(
            padding: AllpassEdgeInsets.listInset,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.black,
              ),
              title: Text("暗黑"),
              trailing: theme == 0 ? Icon(Icons.check, color: Colors.grey,) : null,
              onTap: () {
                setTheme("dark");
              },
            ),
          ),
          Padding(
            padding: AllpassEdgeInsets.listInset,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
              ),
              title: Text("自动"),
              trailing: theme == -1 ? Icon(Icons.check, color: Colors.grey,) : null,
              onTap: () {
                setState(() {
                  Provider.of<ThemeProvider>(context, listen: false).changeTheme("system", context: context);
                });
              },
            ),
          ),
        ],
      )
    );
  }

  void setTheme(String themeName) {
    setState(() {
      Provider.of<ThemeProvider>(context, listen: false).changeTheme(themeName, context: context);
    });
  }

  int getSystemTheme() {
    if (Config.themeMode == "system") {
      return -1;
    } else if (Config.themeMode == "dark") {
      return 0;
    } else {
      switch (Config.lightTheme) {
        case "blue":
          return 1;
        case "red":
          return 2;
        case "teal":
          return 3;
        case "deepPurple":
          return 4;
        case "orange":
          return 5;
        case "pink":
          return 6;
        case "blueGrey":
          return 7;
      }
    }
    return -1;
  }
}