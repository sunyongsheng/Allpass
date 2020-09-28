class ResponseBean {

  /// 响应状态
  ConnectionStatus status;

  /// 服务器返回信息
  String msg;

  /// 对于某些简单的请求，其结果是否符合预期
  bool done;

  ResponseBean({this.status = ConnectionStatus.OK, this.msg, this.done = false});

}

enum ConnectionStatus {
  OK,
  NetworkError,
  ServerError,
  UnknownError
}