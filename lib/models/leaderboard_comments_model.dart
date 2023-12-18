// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

List<Comment> commentFromJson(String str) =>
    List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

String commentToJson(List<Comment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comment {
  Model model;
  int pk;
  Fields fields;

  Comment({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  String comment;

  Fields({
    required this.comment,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
      };
}

enum Model { LEADERBOARD_COMMENT }

final modelValues =
    EnumValues({"leaderboard.comment": Model.LEADERBOARD_COMMENT});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
