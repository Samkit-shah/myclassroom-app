// To parse this JSON data, do
//
//     final createAnnouncementModel = createAnnouncementModelFromJson(jsonString);

import 'dart:convert';

CreateAnnouncementModel createAnnouncementModelFromJson(String str) =>
    CreateAnnouncementModel.fromJson(json.decode(str));

String createAnnouncementModelToJson(CreateAnnouncementModel data) =>
    json.encode(data.toJson());

class CreateAnnouncementModel {
  CreateAnnouncementModel({
    this.title,
    this.details,
    this.label,
    this.deadline,
    this.classid,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  String title;
  String details;
  String label;
  DateTime deadline;
  String classid;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  factory CreateAnnouncementModel.fromJson(Map<String, dynamic> json) =>
      CreateAnnouncementModel(
        title: json["title"],
        details: json["details"],
        label: json["label"],
        deadline: DateTime.parse(json["deadline"]),
        classid: json["classid"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "details": details,
        "label": label,
        "deadline": deadline.toIso8601String(),
        "classid": classid,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
