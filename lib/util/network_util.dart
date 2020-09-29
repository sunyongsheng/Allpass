import 'package:dio/dio.dart';
import 'package:allpass/application.dart';
import 'package:allpass/param/param.dart';
import 'package:allpass/model/api/update_bean.dart';
import 'package:allpass/model/api/allpass_response.dart';

class NetworkUtil {

  NetworkUtil._();

  static Dio get dio {
    if (_dio == null) {
      _dio = Dio();
    }
    return _dio;
  }

  static Dio _dio;

  /// 发送注册
  static Future<AllpassResponse> registerUser(Map<String, String> user) async {
    try {
      Response response = await dio.post("$allpassUrl/user/", data: user);
      Map<String, String> res = Map();
      for (String key in response.data.keys) {
        res[key] = response.data[key];
      }
      return AllpassResponse.create(res);
    } catch (e) {
      return AllpassResponse(
        success: false,
        msg: e.toString()
      );
    }
  }

  /// 发送反馈
  static Future<AllpassResponse> sendFeedback(Map<String, String> content) async {
    try {
      Response response = await dio.post("$allpassUrl/feedback/", data: content);
      Map<String, String> res = Map();
      for (String key in response.data.keys) {
        res[key] = response.data[key];
      }
      return AllpassResponse.create(res,
        defaultConfig: ResponseConfig(
          defaultSuccessMsg: "感谢你的反馈！",
          defaultFailedMsg: "提交失败，请反馈给作者！"
        ));
    } on DioError catch (dioError) {
      if (dioError.type == DioErrorType.RESPONSE) {
        return AllpassResponse(
            status: ResponseStatus.ServerError,
            msg: "提交失败，远程服务器出现问题，请向作者反馈",
            success: false
        );
      } else {
        return AllpassResponse(
            status: ResponseStatus.NetworkError,
            msg: "提交失败，请检查网络连接",
            success: false
        );
      }
    } catch (e) {
      return AllpassResponse(
        status: ResponseStatus.UnknownError,
        msg: "提交失败，错误原因：${e.toString()}",
        success: false
      );
    }
  }

  /// 检查更新
  static Future<UpdateBean> checkUpdate() async {
    try {
      Response response = await dio.get("$allpassUrl/update/?version=${Application.version}");

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
  static Future<UpdateBean> getLatestVersion() async {
    try {
      Response<Map> response = await Dio(BaseOptions(connectTimeout: 10))
          .get("$allpassUrl/update/?version=1.0.0");
      Map<String, String> res = Map();
      for (String key in response.data.keys) {
        res[key] = response.data[key];
      }
      return UpdateBean(
        version: res["version"],
        downloadUrl: res["download_url"]
      );
    } catch (_) {
      return UpdateBean(
        version: Application.version,
        downloadUrl: "https://allpass.aengus.top/api/download/?version=${Application.version}"
      );
    }
  }
}