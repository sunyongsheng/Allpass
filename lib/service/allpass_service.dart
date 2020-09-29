import 'package:allpass/model/api/allpass_response.dart';
import 'package:allpass/model/api/update_bean.dart';

abstract class AllpassService {

  /// 注册用户
  Future<AllpassResponse> registerUser(Map<String, String> user);

  /// 发送反馈
  Future<AllpassResponse> sendFeedback(Map<String, String> content);

  /// 检查更新
  Future<UpdateBean> checkUpdate();

  /// 获取最新版本
  Future<UpdateBean> getLatestVersion();
}