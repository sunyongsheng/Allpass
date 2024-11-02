import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/l10n/l10n_support.dart';
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
    var l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.autofill,
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
                    builder: (_, provider, __) {
                      var color = provider.autofillEnable
                          ? Colors.grey
                          : null;
                      var children = <Widget>[
                        Text(
                          provider.autofillEnable
                              ? l10n.autofillEnableAllpass
                              : l10n.autofillDisableAllpass,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: color,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ];
                      if (!provider.autofillEnable) {
                        children.add(Padding(
                          padding: EdgeInsets.only(
                            left: 4,
                            right: 4,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: color,
                            size: 14,
                          ),
                      ));
                    }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: children,
                      );
                    }
                  ),
                ),
              ),
              onTap: context.read<AutofillProvider>().gotoAutofillSetting,
            ),
          ),
          Padding(
            padding: AllpassEdgeInsets.settingCardInset,
            child: Text(
              l10n.autofillHelp,
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
