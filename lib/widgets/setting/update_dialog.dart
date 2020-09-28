import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:allpass/model/update_bean.dart';
import 'package:allpass/ui/allpass_ui.dart';

class UpdateDialog extends StatelessWidget {

  final UpdateBean updateBean;


  UpdateDialog(this.updateBean);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("检查更新"),
      content: SingleChildScrollView(child: _createUpdateContent()),
      actions: _createUpdateAction(context)
    );
  }

  Widget _createUpdateContent() {
    String _updateContent = updateBean.updateContent?.replaceAll("~", "\n");
    switch (updateBean.checkResult) {
      case CheckUpdateResult.HaveUpdate:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("有新版本可以下载！最新版本V${updateBean.version}"),
            Padding(
              padding: AllpassEdgeInsets.smallTBPadding,
              child: Text("更新内容：", style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Text(_updateContent)
          ],
        );
      case CheckUpdateResult.NoUpdate:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("您的版本是最新版！"),
            Padding(
              padding: AllpassEdgeInsets.smallTBPadding,
              child: Text("最近更新：", style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Text(_updateContent)
          ],
        );
      case CheckUpdateResult.NetworkError:
        _updateContent = "网络错误：${updateBean.updateContent}";
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("由于网络原因出现错误，若您确保您的网络无问题，请截图发送到sys6511@126.com\n"),
            Text(_updateContent)
          ],
        );
      default:
        _updateContent = "未知错误: ${updateBean.updateContent}";
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("检查过程中有错误出现！下面是错误信息，请截图发送到sys6511@126.com\n"),
            Text(_updateContent)
          ],
        );
    }
  }

  List<Widget> _createUpdateAction(BuildContext context) {
    if (updateBean.checkResult == CheckUpdateResult.HaveUpdate) {
      return [
        FlatButton(
            child: Text("下载更新"),
            onPressed: () async => await launch(updateBean.downloadUrl)),
        FlatButton(
            child: Text("下次再说"),
            onPressed: () => Navigator.pop(context))];
    } else {
      return [
        FlatButton(
            child: Text("确定"),
            onPressed: () => Navigator.pop(context)),
        FlatButton(
          child: Text("取消"),
          onPressed: () => Navigator.pop(context),)];
    }
  }
}