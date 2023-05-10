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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.autofill,
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
                          ? context.l10n.autofillEnableAllpass
                          : context.l10n.autofillDisableAllpass,
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
              context.l10n.autofillHelp,
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
