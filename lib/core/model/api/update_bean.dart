class UpdateBean {

  final CheckUpdateResult checkResult;

  final String? version;

  final String? updateContent;

  final String? downloadUrl;

  final String? updateTime;

  final String? channel;

  UpdateBean({
    this.checkResult = CheckUpdateResult.NoUpdate,
    this.version,
    this.updateContent,
    this.downloadUrl,
    this.updateTime,
    this.channel,
  });

  bool isBetaChannel() {
    return this.channel?.toUpperCase() == "BETA";
  }

  bool isReleaseChannel() {
    return this.channel?.toUpperCase() == "RELEASE";
  }
}

enum CheckUpdateResult {
  HaveUpdate,
  NoUpdate,
  NetworkError,
  UnknownError
}