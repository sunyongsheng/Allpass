import 'package:allpass/autofill/autofill_save_request.dart';

class SimpleUser {
  String? name;
  String? username;
  String? password;
  String? appName;
  String? appId;

  SimpleUser(this.name, this.username, this.password, this.appName, this.appId);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'password': password,
      'appName': appName,
      'appId': appId
    };
  }

  static SimpleUser fromJson(Map<String, dynamic> map) {
    return SimpleUser(map['name'], map['username'], map['password'],
        map['appName'], map['appId']);
  }
}

extension RequestMapper on SimpleUser {
  AutofillSaveRequest mapToRequest() {
    return AutofillSaveRequest(name, username!, password!, appName, appId!);
  }
}
