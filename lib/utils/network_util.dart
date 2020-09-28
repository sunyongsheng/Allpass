import 'package:dio/dio.dart';
import 'package:allpass/application.dart';
import 'package:allpass/params/param.dart';
import 'package:allpass/model/update_bean.dart';

class NetworkUtil {
  Dio _dio;

  NetworkUtil() {
    _dio = Dio();
  }

  /// 发送注册
  Future<Map<String, String>> registerUser(Map<String, String> user) async {
    Response response = await _dio.post("$allpassUrl/user/", data: user);
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
  Future<UpdateBean> checkUpdate() async {
    try {
      Response response = await _dio.get(
          "$allpassUrl/update/?version=${Application.version}");

      Map<String, String> res = Map();
      for (String key in response.data.keys) {
        res[key] = response.data[key];
      }

      CheckUpdateResult result;
      String version = Application.version;
      String content = res["update_content"];
      String downloadUrl = res["download_url"];
      if (res["have_update"] == "1") {
        result = CheckUpdateResult.HaveUpdate;
        version = res["version"];
      } else {
        result = CheckUpdateResult.NoUpdate;
      }
      return UpdateBean(
        checkResult: result,
        version: version,
        updateContent: content,
        downloadUrl: downloadUrl
      );
    } on DioError catch (e){
      return UpdateBean(
        checkResult: CheckUpdateResult.NetworkError,
        version: Application.version,
        updateContent: e.toString(),
      );
    } catch (unknownError) {
      return UpdateBean(
        checkResult: CheckUpdateResult.UnknownError,
        version: Application.version,
        updateContent: unknownError.toString()
      );
    }
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