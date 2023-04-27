import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/setting/autofill/autofill_provider.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AutofillPage extends StatefulWidget {
  @override
  State createState() {
    return _AutofillState();
  }
}

class _AutofillState extends State<AutofillPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AutofillProvider>().checkAutofillEnable();
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<AutofillProvider>().checkAutofillEnable();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "自动填充",
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
      ),
      backgroundColor: context.watch<ThemeProvider>().specialBackgroundColor,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: AllpassEdgeInsets.smallTopInsets,
          ),
          Card(
            margin: AllpassEdgeInsets.settingCardInset,
            elevation: 0,
            child: InkWell(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Align(
                  child: Consumer<AutofillProvider>(
                    builder: (_, provider, __) => Text(
                      provider.autofillEnable
                          ? "Allpass已是您的自动填充服务"
                          : "未使用Allpass作为自动填充服务",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: provider.autofillEnable
                            ? Colors.grey
                            : null,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              onTap: context.read<AutofillProvider>().gotoAutofillSetting,
            ),
          ),
          Padding(
            padding: AllpassEdgeInsets.settingCardInset,
            child: Text(
              "当您在应用程序中输入密码时，自动填充功能会自动提供可能的密码匹配项以便您进行选择。当存储的密码条目符合以下条件之一时，将作为候选项：\n"
              "\n"
              "1. 密码条目所属App与当前App相匹配时；\n"
              "2. 密码条目的名称与当前App名称匹配时；\n"
              "\n"
              "如果您发现自动填充的结果不准确，您可以在密码编辑页面中修改密码条目所属App，以帮助自动填充功能更准确地匹配密码",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }
}
