import 'package:flutter/widgets.dart';

extension ScrollControllerExtension on ScrollController {
  /// 滚动到顶部
  void scrollToTop() {
    animateTo(
      0,
      duration: Duration(milliseconds: 200),
      curve: Curves.decelerate,
    );
  }
}