// To parse this JSON data, do
//
//     final listLikes = listLikesFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ListLikes listLikesFromJson(String str) => ListLikes.fromJson(json.decode(str));

String listLikesToJson(ListLikes data) => json.encode(data.toJson());

class ListLikes {
  ListLikes({
    @required this.error,
    @required this.errorMsg,
    @required this.result,
  });

  final bool error;
  final String errorMsg;
  final List<Result> result;

  factory ListLikes.fromJson(Map<String, dynamic> json) => ListLikes(
        error: json["error"] == null ? null : json["error"],
        errorMsg: json["error_msg"] == null ? null : json["error_msg"],
        result: json["result"] == null
            ? null
            : List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error == null ? null : error,
        "error_msg": errorMsg == null ? null : errorMsg,
        "result": result == null
            ? null
            : List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    @required this.userId,
    @required this.name,
    @required this.email,
    @required this.pic,
    @required this.bio,
    @required this.updatedAt,
    @required this.createdAt,
  });

  final int userId;
  final String name;
  final String email;
  final String pic;
  final String bio;
  final DateTime updatedAt;
  final DateTime createdAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        userId: json["user_id"] == null ? null : json["user_id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        pic: json["pic"] == null ? null : json["pic"],
        bio: json["bio"] == null ? null : json["bio"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId == null ? null : userId,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "pic": pic == null ? null : pic,
        "bio": bio == null ? null : bio,
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
      };
}
