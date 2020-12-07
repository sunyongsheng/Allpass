class UserBean {
  
  String identification;
  
  String systemInfo;
  
  String version;
  
  UserBean({
    this.identification,
    this.version,
    this.systemInfo
  });
  
  Map<String, String> toJson() {
    Map<String, String> user = Map();
    user['identification'] = this.identification;
    user['systemInfo'] = this.systemInfo;
    user['allpassVersion'] = this.version;
    return user;
  }
}