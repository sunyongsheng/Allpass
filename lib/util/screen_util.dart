import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllpassScreenUtil {

  static ScreenUtil _instance = ScreenUtil();
  static double screenHighDp = _instance.screenHeight;

  static double setWidth(num width) {
    return _instance.setWidth(width);
  }

  static double setHeight(num height) {
    return _instance.setHeight(height);
  }
}