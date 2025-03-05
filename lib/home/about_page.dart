import 'package:allpass/core/common_logger.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/util/version_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:allpass/application.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/develop/debug_page.dart';
import 'package:allpass/setting/theme/theme_provider.dart';

class AboutPage extends StatelessWidget {

  static final Text serviceContent = Text(
    '''
        1. Allpass（下称“本产品”）是一款开源的私密数据管理工具，采用Apache 2.0协议，所以你可以在满足Apache 2.0协议的基础上对本产品进行再发布。
        2. 本产品不做任何担保。由于用户行为（Root等）导致用户信息泄露或丢失，本产品免责。
        3. 任何由于黑客攻击、计算机病毒侵入或发作、因政府管制而造成的暂时性关闭等影响网络正常经营的不可抗力而造成的个人资料泄露、丢失、被盗用或被窜改等，本产品均得免责。
        4. 使用者因为违反本声明的规定而触犯中华人民共和国法律的，一切后果自己负责，本产品不承担任何责任。
        5. 开发者不会向任何无关第三方提供、出售、出租、分享或交易您的个人信息。Allpass也不会将普通用户的信息用于商业用途。
        6. 在使用过程中，Allpass需要获取手机的存储权限（导入及导出功能）、手机识别码（用于Allpass用户统计）、生物识别验证（用于指纹登录）及联网权限（检查更新）。
        ''',
    style: AllpassTextUI.firstTitleStyle,
  );

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.about,
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
      ),
      backgroundColor: context.watch<ThemeProvider>().specialBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Card(
                margin: EdgeInsets.all(AllpassScreenUtil.setWidth(50)),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: AllpassUI.smallBorderRadius),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: AllpassEdgeInsets.smallTBPadding,),
                    Container(
                        padding: AllpassEdgeInsets.listInset,
                        child: ListTile(
                          title: Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              l10n.allpass,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          subtitle: Text(l10n.allpassIntroduction),
                          trailing: Text("V${AllpassApplication.version}", style: TextStyle(color: Colors.grey),),
                          isThreeLine: true,
                          onLongPress: () {
                            if (!VersionUtil.isDebug()) {
                              commonLogger.w("current isn't debug mode");
                              return;
                            }

                            ToastUtil.show(msg: l10n.enterDebugMode);
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => DebugPage()
                            ));
                          },
                        )),
                    Container(
                      child: Divider(),
                      padding: AllpassEdgeInsets.dividerInset,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 10),
                      child: Text(l10n.contact, style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    Container(
                      padding: AllpassEdgeInsets.dividerInset,
                      child: TextButton(
                        child: Text(l10n.website),
                        onPressed: () async {
                          await launchUrl(
                            Uri.parse("https://allpass.aengus.top"),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: AllpassEdgeInsets.dividerInset,
                      child: TextButton(
                        child: Text(l10n.contact1),
                        onPressed: () async {
                          await launchUrl(
                            Uri.parse(l10n.contact1Url),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: AllpassEdgeInsets.dividerInset,
                      child: TextButton(
                        child: Text(l10n.contact2),
                        onPressed: () async {
                          await launchUrl(Uri.parse("mailto:sys6511@126.com"));
                        },
                      ),
                    ),
                    Container(
                      padding: AllpassEdgeInsets.dividerInset,
                      child: TextButton(
                        child: Text(l10n.contact3),
                        onPressed: () async {
                          await launchUrl(
                            Uri.parse("https://www.aengus.top"),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),
                    ),
                    Container(
                        padding: AllpassEdgeInsets.dividerInset,
                        child: Row(
                          children: <Widget>[
                            TextButton(
                              child: Text(l10n.projectUrl),
                              onPressed: () async {
                                  await launchUrl(
                                    Uri.parse("https://github.com/sunyongsheng/Allpass"),
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                            ),
                            Text("|"),
                            TextButton(
                              child: Text(l10n.gitee),
                              onPressed: () async {
                                await launchUrl(
                                  Uri.parse("https://gitee.com/sunyongsheng/Allpass"),
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                            ),
                          ],
                        )
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                    )
                  ],
                ),
              ),
              Text("Copyright ${DateTime.now().year} Aengus Sun. Apache License 2.0", style: TextStyle(color: Colors.grey),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                child: Text(l10n.serviceTerms),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => DetailsPage(
                      title: l10n.serviceTerms,
                      content: serviceContent,
                    )
                  ));
                },
              ),
            ],
          )
        ],
      )
    );
  }
}

class DetailsPage extends StatelessWidget {

  final String title;
  final Widget content;

  const DetailsPage({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              child: content,
              padding: AllpassEdgeInsets.listInset,
            )
          ],
        ),
      ),
    );
  }
}