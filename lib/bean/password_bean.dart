class PasswordBean {
  String name;      // 账号名称
  String username;  // 用户名
  String password;  // 密码
  String url;       // 地址
  String folder;    // 文件夹
  String notes;     // 备注
  String label;     // 标签

  PasswordBean(this.username, this.password, this.url, {this.folder="default"}) {
    if (name == null) {
      this.name = this.username;
    }
  }
}