import 'package:dio/dio.dart';
import 'package:allpass/application.dart';
import 'package:allpass/params/param.dart';

class NetworkUtil {
  Dio _dio;

  NetworkUtil() {
    _dio = Dio();
  }

  /// 发送注册
  Future<Map<String, String>> registerUser(Map<String, String> user) async {
    Response response = await _dio.post<Map<String, String>>("$allpassUrl/user/", data: user);
    Map<String, String> res = Map();
    for (String key in response.data.keys) {
      res[key] = response.data[key];
    }
    return res;
  }

  /// 发送反馈
  Future<Map<String, String>> sendFeedback(Map<String, String> content) async {
    Response response = await _dio.post("$allpassUrl/feedback/", data: content);
    Map<String, String> res = Map();
    for (String key in response.data.keys) {
      res[key] = response.data[key];
    }
    return res;
  }

  /// 检查更新
  Future<Map<String, String>> checkUpdate() async {
    Response response =  await _dio.get(
        "$allpassUrl/update/?version=${Application.version}");
    Map<String, String> res = Map();
    for (String key in response.data.keys) {
      res[key] = response.data[key];
    }
    return res;
  }

  /// 获取最新版本
  Future<Map<String, String>> getLatestVersion() async {
    Response<Map> response = await Dio(BaseOptions(connectTimeout: 10)).get(
        "$allpassUrl/update/?version=1.0.0");
    Map<String, String> res = Map();
    for (String key in response.data.keys) {
      res[key] = response.data[key];
    }
    return res;
  }
}