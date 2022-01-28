class SimpleUser {
  String? username;
  String? password;
  String? appId;

  SimpleUser(this.username, this.password, this.appId);

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'appId': appId
    };
  }

  static SimpleUser fromJson(Map<String, dynamic> map) {
    return SimpleUser(
        map['username'],
        map['password'],
        map['appId']
    );
  }
}