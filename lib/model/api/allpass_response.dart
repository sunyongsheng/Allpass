class AllpassResponse {

  ResponseStatus status;

  bool success;

  int code;

  String msg;
  
  Map<String, String> extra;

  AllpassResponse({this.status = ResponseStatus.OK,
    this.msg, this.success, this.code, this.extra});

}

enum ResponseStatus {
  OK,
  NetworkError,
  ServerError,
  UnknownError
}