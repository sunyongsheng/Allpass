class PasswordBean {
  final int key;          // ID
  String name;            // 账号名称
  String username;        // 用户名
  String password;        // 密码
  String url;             // 地址
  String folder;          // 文件夹
  String notes;           // 备注
  List<String> label = List();     // 标签

  PasswordBean(this.key, this.username, this.password, this.url, {this.folder: "默认", this.name, this.label, this.notes}) {
    if (name == null) {
      if (url.contains("weibo")) {
        this.name = "微博";
      } else if (url.contains("zhihu")) {
        this.name = "知乎";
      } else if (url.contains("gmail")) {
        this.name = "Gmail";
      } else if (url.contains("126")) {
        this.name = "126邮箱";
      } else {
        this.name = this.username;
      }
    }

    if (folder == null) {
      this.folder = "默认";
    }

    if (label == null) {
      this.label.add("undefined");
    }
  }
}