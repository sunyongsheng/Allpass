import 'package:allpass/application.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:allpass/core/model/api/update_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';

class UpdateDialog extends StatelessWidget {

  final Key? key;
  final UpdateBean updateBean;

  UpdateDialog(this.updateBean, {this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("检查更新"),
      content: SingleChildScrollView(child: _createUpdateContent()),
      actions: _createUpdateAction(context)
    );
  }

  Widget _createUpdateContent() {
    String _updateContent = updateBean.updateContent?.replaceAll("~", "\n") ?? "无";
    switch (updateBean.checkResult) {
      case CheckUpdateResult.HaveUpdate:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("有新版本可以下载！最新版本 ${updateBean.channel} V${updateBean.version}"),
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
            Text("您的版本是最新版！${updateBean.channel} V${updateBean.version}"),
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
            Text("由于网络原因出现错误，若您确保您的网络无问题，则可能是下面的原因\n"),
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
    Color mainColor = Theme.of(context).primaryColor;
    if (updateBean.checkResult == CheckUpdateResult.HaveUpdate) {
      return [
        TextButton(
            child: Text("下载更新", style: TextStyle(color: mainColor)),
            onPressed: () async {
              String? downloadUrl;
              if (updateBean.isBetaChannel()) {
                downloadUrl = "${updateBean.downloadUrl}&identification=${AllpassApplication.identification}";
              } else {
                downloadUrl = updateBean.downloadUrl;
              }
              if (downloadUrl != null) {
                await launchUrl(Uri.parse(downloadUrl));
              }
            }),
        TextButton(
            child: Text("下次再说", style: TextStyle(color: mainColor),),
            onPressed: () => Navigator.pop(context))];
    } else {
      return [
        TextButton(
            child: Text("确定", style: TextStyle(color: mainColor)),
            onPressed: () => Navigator.pop(context)),
        TextButton(
          child: Text("取消", style: TextStyle(color: mainColor)),
          onPressed: () => Navigator.pop(context),)];
    }
  }
}