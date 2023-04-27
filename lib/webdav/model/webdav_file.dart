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
    String? _getNameFromHref(XmlElement responseNode) {
      var hrefNode = responseNode.obtainWebDavNode("href");
      if (hrefNode == null) {
        return null;
      }

      var index = hrefNode.text.lastIndexOf("/");
      if (index >= 0) {
        return hrefNode.text.substring(index + 1);
      }
      return null;
    }

    var propStatNode = responseNode.obtainWebDavNode("propstat");
    var propNode = propStatNode?.obtainWebDavNode("prop");
    if (propNode == null) {
      return null;
    }

    var name = propNode.obtainWebDavNode("displayname")?.text ??
        _getNameFromHref(responseNode) ??
        "未知名称";

    var lastModifiedString = propNode.obtainWebDavNode("getlastmodified")?.text;
    DateTime lastModified;
    if (lastModifiedString != null) {
      lastModified = HttpDate.parse(lastModifiedString).toLocal();
    } else {
      lastModified = DateTime.fromMillisecondsSinceEpoch(0);
    }

    var size = propNode.obtainWebDavNode("getcontentlength")?.text ?? "-1";

    var contentType = propNode.obtainWebDavNode("getcontenttype")?.text;
    var isFile = contentType != "httpd/unix-directory";

    var filename = name;
    try {
      filename = Uri.decodeComponent(name);
    } catch (_) {}

    return WebDavFile(
      filename: filename,
      lastModified: lastModified,
      byteSize: int.parse(size),
      isFile: isFile,
    );
  }
}

extension XmlElementWebDav on XmlElement {
  XmlElement? obtainWebDavNode(String node) {
    return this.getElement("d:$node") ??
        this.getElement("D:$node") ??
        this.getElement("lp1:$node");
  }
}
