import 'package:dio/dio.dart';
import 'package:allpass/application.dart';
import 'package:allpass/params/param.dart';

class NetworkUtil {
  Dio _dio;

  NetworkUtil() {
    _dio = Dio();
  }

  /// 发送注册
  Future<Map> registerUser(Map<String, String> user) async {
    Response<Map> response = await _dio.post("$allpassUrl/user/", data: user);
    return response.data;
  }

  /// 发送反馈
  Future<Map> sendFeedback(Map<String, String> content) async {
    Response<Map> response = await _dio.post("$allpassUrl/feedback/", data: content);
    return response.data;
  }

  /// 检查更新
  Future<Map> checkUpdate() async {
    Response<Map> response =  await _dio.get(
        "$allpassUrl/update?version=${Application.version}");
    return response.data;
  }

  /// 获取最新版本
  Future<Map> getLatestVersion() async {
    Response<Map> response = await Dio(BaseOptions(connectTimeout: 10)).get(
        "$allpassUrl/update?version=1.0.0");
    return response.data;
  }
}