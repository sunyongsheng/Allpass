/// 服务器地址
const String allpassUrl = "https://allpass.aengus.top/api";

class SPKeys {
  static const String firstRun = "FIRST_RUN";
  static const String needRegister = "NEED_REGISTER";
  static const String allpassVersion = "ALLPASS_VERSION";
  static const String password = "password";
  static const String biometrics = "biometrics";
  static const String longPressCopy = "longPressCopy";
  static const String primaryColor = "theme";
  static const String themeMode = "themeMode";
  static const String folder = "folder";
  static const String label = "label";
  static const String latestUsePassword = "latestUsePassword";
  static const String webDavAuthSuccess = "webDavAuthSuccess";
  static const String webDavUrl = "webDavUrl";
  static const String webDavUsername = "webDavUsername";
  static const String webDavPassword = "webDavPassword";
  static const String webDavCardName = "webDavCardName";
  static const String webDavEncryptLevel = "webDavEncryptLevel";
  static const String webDavMergeMethod = "webDavMergeMethod";
  static const String webDavBackupDirectory = "webDavBackupDirectory";
  static const String webDavUploadTime = "webDavUploadTime";
  static const String webDavDownloadTime = "webDavDownloadTime";
  static const String webDavBackupMethod = "webDavBackupMethod";
  static const String webDavCustomBackupFilename = "webDavCustomBackupFilename";
  static const String contact = "contact";
  static const String timingInputMainPassword = "timingInputMainPass";
}

class ChannelConstants {

  ChannelConstants._();

  static const String channel = "top.aengus.allpass";

  static const String channelImportCsv = "$channel/importCsv";
  static const String channelQueryAutofillPassword = "$channel/queryPasswordForAutofill";
  static const String channelSaveForAutofill = "$channel/savePasswordForAutofill";

  // Android -> Flutter
  static const String methodSavePasswordForAutofill = "savePasswordForAutofill";
  static const String methodOpenImportPage = "openImportPage";

  // Flutter -> Android
  static const String methodSupportAutofill = "supportAutofill";
  static const String methodIsAppDefaultAutofill = "isAppDefaultAutofill";
  static const String methodSetAppDefaultAutofill = "setAppDefaultAutofill";
  static const String methodOpenAppSettingsPage = "openAppSettingsPage";
}

class DataOperation {
  static const int add = 1;
  static const int delete = -1;
  static const int update = 0;
  static const int query = 2;
  static const int skipped = 3;
}