import 'package:flutter/material.dart';

import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/ui/icon_resource.dart';
import 'package:allpass/util/screen_util.dart';

class NoDataWidget extends StatelessWidget {

  final Key? key;
  final String? additionalInfo;

  NoDataWidget(this.additionalInfo, {this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: AllpassScreenUtil.setHeight(400)),
        ),
        Padding(
          child: Center(
            child: Icon(
              CustomIcons.noData,
              size: AllpassScreenUtil.setWidth(100),
            ),
          ),
          padding: AllpassEdgeInsets.smallTBPadding,
        ),
        Padding(
          child: Center(child: Text("什么也没有，赶快添加吧"),),
          padding: AllpassEdgeInsets.forCardInset,
        ),
        Padding(
          padding: AllpassEdgeInsets.smallTBPadding,
        ),
        additionalInfo == null
            ? Container()
            : Padding(
                child: Center(
                  child: Text(
                    additionalInfo!,
                    textAlign: TextAlign.center,
                  ),
                ),
              padding: AllpassEdgeInsets.forCardInset,
        )
      ],
    );
  }
}