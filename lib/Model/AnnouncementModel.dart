// To parse this JSON data, do
//
//     final announcementModel = announcementModelFromJson(jsonString);

import 'dart:convert';

List<AnnouncementModel> announcementModelFromJson(String str) =>
    List<AnnouncementModel>.from(
        json.decode(str).map((x) => AnnouncementModel.fromJson(x)));

String announcementModelToJson(List<AnnouncementModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AnnouncementModel {
  AnnouncementModel({
    this.id,
    this.classid,
    this.title,
    this.label,
    this.deadline,
    this.details,
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int classid;
  String title;
  String label;
  DateTime deadline;
  String details;
  dynamic rememberToken;
  DateTime createdAt;
  DateTime updatedAt;

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) =>
      AnnouncementModel(
        id: json["id"],
        classid: json["classid"],
        title: json["title"],
        label: json["label"],
        deadline: DateTime.parse(json["deadline"]),
        details: json["details"],
        rememberToken: json["remember_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "classid": classid,
        "title": title,
        "label": label,
        "deadline": deadline.toIso8601String(),
        "details": details,
        "remember_token": rememberToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
