import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseBottomSheet extends StatelessWidget {
  final List<Widget> Function(BuildContext context) builder;

  const BaseBottomSheet({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = builder(context);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
            topLeft: AllpassUI.smallRadius,
            topRight: AllpassUI.smallRadius,
          ),
        ),
        color: context.watch<ThemeProvider>().specialBackgroundColor,
      ),
      padding: EdgeInsets.symmetric(
        vertical: AllpassScreenUtil.setHeight(40),
        horizontal: AllpassScreenUtil.setWidth(20),
      ),
      child: Card(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    );
  }
}
