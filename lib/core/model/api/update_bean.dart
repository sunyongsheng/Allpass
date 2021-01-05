class UpdateBean {

  CheckUpdateResult checkResult;

  String version;

  String updateContent;

  String downloadUrl;

  String updateTime;

  String channel;

  UpdateBean({this.checkResult = CheckUpdateResult.NoUpdate,
    this.version, this.updateContent, this.downloadUrl, this.updateTime, this.channel});
}

enum CheckUpdateResult {
  HaveUpdate,
  NoUpdate,
  NetworkError,
  UnknownError
}