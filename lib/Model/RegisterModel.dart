// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';

RegisterModel registerModelFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  RegisterModel({
    this.classname,
    this.academicyear,
    this.classdivision,
    this.crname,
    this.srname,
    this.contactnumber,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  String classname;
  String academicyear;
  String classdivision;
  String crname;
  String srname;
  String contactnumber;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        classname: json["classname"],
        academicyear: json["academicyear"],
        classdivision: json["classdivision"],
        crname: json["crname"],
        srname: json["srname"],
        contactnumber: json["contactnumber"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "classname": classname,
        "academicyear": academicyear,
        "classdivision": classdivision,
        "crname": crname,
        "srname": srname,
        "contactnumber": contactnumber,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
