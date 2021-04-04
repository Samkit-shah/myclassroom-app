// To parse this JSON data, do
//
//     final classData = classDataFromJson(jsonString);

import 'dart:convert';

ClassData classDataFromJson(String str) => ClassData.fromJson(json.decode(str));

String classDataToJson(ClassData data) => json.encode(data.toJson());

class ClassData {
  ClassData({
    this.id,
    this.classname,
    this.academicyear,
    this.classdivision,
    this.crname,
    this.srname,
    this.contactnumber,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String classname;
  int academicyear;
  String classdivision;
  String crname;
  String srname;
  String contactnumber;
  DateTime createdAt;
  DateTime updatedAt;

  factory ClassData.fromJson(Map<String, dynamic> json) => ClassData(
        id: json["id"],
        classname: json["classname"],
        academicyear: json["academicyear"],
        classdivision: json["classdivision"],
        crname: json["crname"],
        srname: json["srname"],
        contactnumber: json["contactnumber"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "classname": classname,
        "academicyear": academicyear,
        "classdivision": classdivision,
        "crname": crname,
        "srname": srname,
        "contactnumber": contactnumber,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
