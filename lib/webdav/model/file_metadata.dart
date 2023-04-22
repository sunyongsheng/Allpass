import 'package:allpass/core/enums/allpass_type.dart';
import 'package:allpass/webdav/encrypt/encrypt_level.dart';

class FileMetadata {
  final AllpassType type;
  final EncryptLevel encryptLevel;
  final String appVersion;

  FileMetadata({
    required this.type,
    required this.encryptLevel,
    required this.appVersion,
  });

  FileMetadata.fromJson(Map<String, dynamic> json)
      : type = AllpassTypes.parse(json["type"]),
        encryptLevel = EncryptLevels.parse(json["encrypt_level"]),
        appVersion = json["app_version"];

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'app_version': appVersion,
    'encrypt_level': encryptLevel.index,
  };
}