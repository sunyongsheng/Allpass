import 'package:flutter/material.dart';
import 'package:allpass/ui/allpass_ui.dart';

class WebDavSyncPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WebDavSyncPage();
  }
}

class _WebDavSyncPage extends State<StatefulWidget> {

  bool _pressSyncNow;

  @override
  void initState() {
    super.initState();
    _pressSyncNow = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "WebDAV同步",
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: ListTile(
              title: Text("立刻同步"),
              leading: Icon(Icons.sync, color: AllpassColorUI.allColor[0],),
              trailing: _pressSyncNow ? SizedBox(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
                width: 15,
                height: 15,
              ) : null,
              onTap: () {
                setState(() {
                  _pressSyncNow = true;
                });
                // TODO
              },
            ),
            padding: AllpassEdgeInsets.listInset,
          ),
          Container(
            child: ListTile(
              title: Text("定时备份设置"),
              leading: Icon(Icons.settings_applications, color: AllpassColorUI.allColor[1],),
              onTap: () {
                // TODO
              },
            ),
            padding: AllpassEdgeInsets.listInset,
          ),
          Container(
            child: ListTile(
              title: Text("账号配置"),
              leading: Icon(Icons.web, color: AllpassColorUI.allColor[2],),
              onTap: () {
                // TODO
              },
            ),
            padding: AllpassEdgeInsets.listInset,
          ),
        ],
      ),
    );
  }

}