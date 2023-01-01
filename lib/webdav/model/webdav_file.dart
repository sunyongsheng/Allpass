import 'dart:io';

import 'package:xml/xml.dart';

class WebDavFile {
  final String filename;
  final DateTime lastModified;
  final int byteSize;
  final bool isFile;

  WebDavFile(
      {required this.filename,
      required this.lastModified,
      required this.byteSize,
      required this.isFile});

  static WebDavFile? parse(XmlElement responseNode) {
    var propStatNode = responseNode.getElement("d:propstat");
    var propNode = propStatNode?.getElement("d:prop");
    if (propNode == null) {
      return null;
    }

    var name = propNode.getElement("d:displayname")?.text ?? "未知名称";

    var lastModifiedString = propNode.getElement("d:getlastmodified")?.text;
    DateTime lastModified;
    if (lastModifiedString != null) {
      lastModified = HttpDate.parse(lastModifiedString).toLocal();
    } else {
      lastModified = DateTime.fromMillisecondsSinceEpoch(0);
    }

    var size = propNode.getElement("d:getcontentlength")?.text ?? "-1";

    var contentType = propNode.getElement("d:getcontenttype")?.text;
    var isFile = contentType != "httpd/unix-directory";
    return WebDavFile(
        filename: name,
        lastModified: lastModified,
        byteSize: int.parse(size),
        isFile: isFile);
  }
}
