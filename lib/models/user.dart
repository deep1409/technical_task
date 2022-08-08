import 'package:flutter/foundation.dart';

class UserData with ChangeNotifier {
  String? name;
  String? email;
  int? phoneNo;
  bool? login;

  UserData({
    this.name,
    this.email,
    this.phoneNo,
    this.login,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        email: json["email"],
        name: json["name"],
        phoneNo: json["phonenumber"],
        login: json["login"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phonenumber": phoneNo,
        "login": login,
      };
}
