import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:allpass/ui/allpass_ui.dart';

/// 显示如何从Chrome中导入密码
class ChromeImportHelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "从Chrome中导入",
            style: AllpassTextUI.titleBarStyle,
          ),
          centerTitle: true,
        ),
      body: SingleChildScrollView(
        child: Container(
          padding: AllpassEdgeInsets.listInset,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("1. 打开手机Chrome，点击“菜单”", style: AllpassTextUI.titleBarStyle,),
              Image.asset("assets/images/import_step1.jpg", width: ScreenUtil.screenWidth*0.5,),
              Padding(padding: AllpassEdgeInsets.smallTBPadding,),
              Divider(thickness: 2,),
              Text("2. 点击“设置”", style: AllpassTextUI.titleBarStyle,),
              Image.asset("assets/images/import_step2.jpg"),
              Padding(padding: AllpassEdgeInsets.smallTBPadding,),
              Divider(thickness: 2,),
              Text("3. 点击“密码”", style: AllpassTextUI.titleBarStyle,),
              Image.asset("assets/images/import_step3.jpg"),
              Padding(padding: AllpassEdgeInsets.smallTBPadding,),
              Divider(thickness: 2,),
              Text("4. 点击右上角，选择”导出密码“", style: AllpassTextUI.titleBarStyle,),
              Image.asset("assets/images/import_step4.jpg"),
              Padding(padding: AllpassEdgeInsets.smallTBPadding,),
              Divider(thickness: 2,),
              Text("5. 选择”导入到Allpass中“，稍作等待，即可完成", style: AllpassTextUI.titleBarStyle,),
              Image.asset("assets/images/import_step5.png")
            ],
          ),
        ),
      )
    );
  }
}
