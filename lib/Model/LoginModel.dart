// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  Login({
    this.classname,
    this.rememberMe,
    this.admin,
    this.classid,
  });

  String classname;
  String rememberMe;
  int admin;
  int classid;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        classname: json["classname"],
        rememberMe: json["remember_me"],
        admin: json["admin"],
        classid: json["classid"],
      );

  Map<String, dynamic> toJson() => {
        "classname": classname,
        "remember_me": rememberMe,
        "admin": admin,
        "classid": classid,
      };
}
