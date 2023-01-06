import 'package:allpass/core/enums/allpass_type.dart';
import 'package:allpass/webdav/encrypt/encrypt_level.dart';

class FileMetaData {
  final AllpassType type;
  final EncryptLevel encryptLevel;
  final String appVersion;

  FileMetaData({required this.type, required this.encryptLevel, required this.appVersion});

  FileMetaData.fromJson(Map<String, dynamic> json)
      : type = AllpassTypes.parse(json["type"]),
        encryptLevel = EncryptLevels.parse(json["encrypt_level"]),
        appVersion = json["app_version"];

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'app_version': appVersion,
    'encrypt_level': encryptLevel.index
  };
}

class BackupFile {
  final FileMetaData metaData;
  final String data;

  BackupFile({required this.metaData, required this.data});

  static BackupFile fromJson(Map<String, dynamic> json) {
    return BackupFile(
        metaData: FileMetaData.fromJson(json["meta_data"]),
        data: json["data"]
    );
  }

  Map<String, dynamic> toJson() => {
    'meta_data': metaData,
    'data': data,
  };
}
