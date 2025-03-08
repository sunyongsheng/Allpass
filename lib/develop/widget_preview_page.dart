import 'package:allpass/common/widget/tips_card.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/material.dart';

class WidgetPreviewPage extends StatefulWidget {
  @override
  State createState() {
    return _WidgetPreviewPageState();
  }
}

class _WidgetPreviewPageState extends State<WidgetPreviewPage> {

  var tipsVisible = Map<TipsCardType, bool>();

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    TipsCardType.values.forEach((type) {
      children.add(TipsCard(
        type: type,
        visible: tipsVisible[type] ?? true,
        title: context.l10n.importFromExternalTips,
        onClose: () {
          setState(() {
            tipsVisible[type] = false;
          });
        },
      ));
    });
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: children),
    );
  }
}
