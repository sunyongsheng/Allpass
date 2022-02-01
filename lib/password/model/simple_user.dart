class SimpleUser {
  String? name;
  String? username;
  String? password;
  String? appId;

  SimpleUser(this.name, this.username, this.password, this.appId);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'password': password,
      'appId': appId
    };
  }

  static SimpleUser fromJson(Map<String, dynamic> map) {
    return SimpleUser(
        map['name'],
        map['username'],
        map['password'],
        map['appId']
    );
  }
}