import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DecryptErrorWidget extends StatelessWidget {

  final String originalValue;

  const DecryptErrorWidget({
    Key? key,
    required this.originalValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "查看失败",
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
      ),
      backgroundColor: context.watch<ThemeProvider>().specialBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("待解码密码：$originalValue\n"),
            Text("密码解码失败，可能是因为您通过WebDAV恢复了数据，但是数据加密的密钥与您当前密钥不同的原因\n"),
            Text("有以下几种解决方案："),
            Text(
                "1. 删除从WebDA恢复的数据，然后在 设置 - 主账号管理 - 加密密钥更新 中更新密钥，再重新从WebDAV恢复数据"),
            Text("2. 删除从WebDA恢复的数据，然后选择未经加密的备份文件恢复数据\n"),
            Text("如果上述解决方案均不可用，则代表原文件已经无法再使用，您仍需删除从WebDAV恢复的数据"),
          ],
        ),
      ),
    );
  }
}
