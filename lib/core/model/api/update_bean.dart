class UpdateBean {

  CheckUpdateResult checkResult;

  String version;

  String updateContent;

  String downloadUrl;

  String updateTime;

  UpdateBean({this.checkResult = CheckUpdateResult.NoUpdate,
    this.version, this.updateContent, this.downloadUrl, this.updateTime});
}

enum CheckUpdateResult {
  HaveUpdate,
  NoUpdate,
  NetworkError,
  UnknownError
}