import 'package:allpass/core/enums/allpass_type.dart';
import 'package:allpass/webdav/model/file_metadata.dart';

sealed class BackupFile {}

/// V1备份文件，内容格式
/// "${bean数组}"
class BackupFileV1 extends BackupFile {
  late AllpassType type;
  final List<dynamic> list;

  BackupFileV1(this.list);
}

/// V2备份文件，内容格式为
/// {
///   "meta_data": {
///     "type": "password",
///     "app_version": "1.7.0",
///     "encrypt_level": 1
///   },
///   "data": "${bean数组}"
/// }
class BackupFileV2 extends BackupFile {
  final FileMetadata metadata;
  final String data;

  BackupFileV2({
    required this.metadata,
    required this.data,
  });

  static BackupFileV2 fromJson(Map<String, dynamic> json) {
    return BackupFileV2(
      metadata: FileMetadata.fromJson(json["meta_data"]),
      data: json["data"],
    );
  }

  Map<String, dynamic> toJson() => {
    'meta_data': metadata,
    'data': data,
  };
}
