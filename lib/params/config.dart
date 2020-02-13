import 'package:allpass/application.dart';
import 'package:allpass/params/runtime_data.dart';

/// 存储系统参数
class Config {
  Config._();

  static String username; // 当前使用者用户名
  static String password; // 使用者密码
  static bool enabledBiometrics = false; // 是否启用生物识别
  static bool longPressCopy = true;     // 是否开启长按复制，否则为长按多选
  static bool multiSelected = false;      // 是否点击了多选按钮


  /// 参数初始化
  static configInit() async {
    RuntimeData.initData();
    if (Application.sp == null) {
      await Application.initSp();
    }
    // 初始化当前用户名与密码
    username = Application.sp.getString("username")??"j213!djoas9120jd";
    password = Application.sp.getString("password")??"213edsfr3@DE21d";
    // 判断是否开启生物识别
    enabledBiometrics = Application.sp.getBool("biometrics")??false;
    // 判断长按功能
    longPressCopy = Application.sp.getBool("longPressCopy")??true;
  }

  /// 清空参数
  static configClear() async {
    username = "";
    password = "";
    enabledBiometrics = false;
    RuntimeData.clearData();
  }

}
