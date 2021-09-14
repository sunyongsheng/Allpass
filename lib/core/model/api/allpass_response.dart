class AllpassResponse {

  /// 响应状态，若没有任何问题则为[ResponseStatus.OK]，根据返回后的[code]字段进行确定
  ResponseStatus status;

  /// 此次请求的结果是否符合预期（即请求成功完成）
  bool success;

  /// 服务器返回的信息，一般用于展示给用户
  String? msg;

  /// 其他信息
  Map<String, String>? extra;

  AllpassResponse({this.status = ResponseStatus.OK,
    this.msg, this.success = true, this.extra});

  static AllpassResponse create(Map<String, String> data, {ResponseConfig? defaultConfig}) {

    ResponseStatus responseStatus = _evaluateStatus(data["code"], defaultConfig: defaultConfig);
    bool success = _evaluateSuccess(data["success"] ?? data["result"], defaultConfig: defaultConfig);
    String? msg = _evaluateMsg(data["msg"], success, defaultConfig: defaultConfig);

    return AllpassResponse(
      status: responseStatus,
      success: success,
      msg: msg
    );
  }

  static ResponseStatus _evaluateStatus(String? string, {ResponseConfig? defaultConfig}) {
    if (string == null) {
      return defaultConfig?.defaultStatus ?? ResponseStatus.UnknownError;
    }
    int code = int.parse(string);
    switch (code) {
      case 2000:
        return ResponseStatus.OK;
      case 3100:
      case 3200:
        return ResponseStatus.ParamError;
      case 4100:
        return ResponseStatus.ServerError;
      case 4900:
        return ResponseStatus.UnknownError;
      default:
        return defaultConfig?.defaultStatus ?? ResponseStatus.OK;
    }
  }

  static bool _evaluateSuccess(String? string, {ResponseConfig? defaultConfig}) {
    if (string == null) return defaultConfig?.defaultSuccess ?? false;
    if (string == "1") return true;
    if (string == "true") return true;
    return defaultConfig?.defaultSuccess ?? false;
  }

  static String? _evaluateMsg(String? string, bool success, { ResponseConfig? defaultConfig }) {
    if (string == null) {
      if (success) {
        return defaultConfig?.defaultSuccessMsg;
      } else {
        return defaultConfig?.defaultFailedMsg;
      }
    }
    return string;
  }

}

class ResponseConfig {

  ResponseStatus defaultStatus;

  bool defaultSuccess;

  String defaultSuccessMsg;

  String defaultFailedMsg;

  ResponseConfig({
    this.defaultStatus = ResponseStatus.OK,
    this.defaultSuccess = false,
    this.defaultSuccessMsg = "",
    this.defaultFailedMsg = ""});
}

enum ResponseStatus {
  OK,
  NetworkError,
  ParamError,
  ServerError,
  UnknownError
}